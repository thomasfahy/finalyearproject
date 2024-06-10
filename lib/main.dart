import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'node.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';


List<Node> listOfNodes = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title text
            const Text(
              'Taekwondo Reaction Trainer',
              style: TextStyle(
                fontSize: 64.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            // Instruction text
            const Text(
              'This simple exercise helps to focus your mind on the present moment and is beneficial in preparation for mental performance:\n \nInhale slowly through your nose for a count of 4 seconds \nHold your breath for a count of 4 seconds \nExhale slowly through your mouth for a count of 4 seconds \nHold your breath again for a count of 4 seconds \nRepeat 6 times and enter the dojang when ready to perform!”,',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: 24.0),
            // Start button
            FloatingActionButton.extended(
              onPressed: () {
                // Navigate to the MyFlutterApp widget
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyFlutterApp()),
                );
              },
              label: Text('Begin'),
              icon: Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}

class MyFlutterApp extends StatefulWidget {
  const MyFlutterApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyFlutterState();
  }
}

class MyFlutterState extends State<MyFlutterApp> {
  
  //AUDIO
  final audioPlayer = AudioPlayer();
  late VideoPlayerController _controller;
  late int iD;
  late int option1; // Renamed yesID to option1 for consistency
  late int option2; // Renamed noID to option2 for consistency
  late int option3; // Renamed maybeID to option3 for consistency
  String optionOneText = ""; // Updated variable name
  String optionTwoText = ""; // Updated variable name
  String optionThreeText = ""; // Updated variable name
  String question = "";
  String video = "";
  bool showOption1 = true;
  bool showOption3 = true;
  Timer? _timer;
  DateTime? _startTime;
  
  double score = 0;
  double time = 0;

  @override
  void initState() {
    super.initState();
    video = "assets/node1.mp4";
    WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.setVolume(0); 
        _controller.play();
        _controller.seekTo(Duration(seconds: _controller.value.duration.inSeconds));
        _controller.pause();
      });
    _controller = VideoPlayerController.asset(video)
      ..initialize().then((_) {
        setState(() {});
      });
      _updateAndPlayVideo();
      
          String csv = "my_data.csv";
    rootBundle.loadString(csv).then((fileData) {
      List<String> rows = fileData.split("\n");
      for (int i = 0; i < rows.length; i++) {
        String row = rows[i];
        List<String> itemInRow = row.split(",");
        String vid = itemInRow[8].trim();
        Node node = Node(
          int.parse(itemInRow[0]),
          int.parse(itemInRow[1]),
          int.parse(itemInRow[2]),
          int.parse(itemInRow[3]),
          itemInRow[4],
          itemInRow[5],
          itemInRow[6],
          itemInRow[7],
          vid,
        );
        listOfNodes.add(node);
        _startTimer();
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (listOfNodes.isNotEmpty) {
            Node current = listOfNodes.first;
            iD = current.iD;
            option1 = current.option1;
            option2 = current.option2;
            option3 = current.option3;
            optionOneText = current.optionOneText;
            optionTwoText = current.optionTwoText;
            optionThreeText = current.optionThreeText;
            question = current.question;
            video = current.videoUrl;
          }
        });
      });
    });


    
      @override
      void dispose() {
        _controller.dispose();
        _timer?.cancel();
        super.dispose();
      }
  }
  void _startTimer() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        time = (DateTime.now().difference(_startTime!).inSeconds + 1).toDouble();
      });
    });
  }

  void option1Handler(){
    setState(() {
      for (Node nextNode in listOfNodes) {
        if (nextNode.iD == option1) {
          iD = nextNode.iD;
          option1 = nextNode.option1;
          option2 = nextNode.option2;
          option3 = nextNode.option3;
          optionOneText = nextNode.optionOneText;
          optionTwoText = nextNode.optionTwoText;
          optionThreeText = nextNode.optionThreeText;
          question = nextNode.question;
          video = nextNode.videoUrl;
          showOption1 = !showOption1;
          showOption3 = !showOption3;
          if (question == "Perfect Response"){
            score += 100 / (time + 1);
          }
          if(question == "Okay Response"){
            score += 50 / (time + 1);
          }
          if(question == "Failed Response"){
            score += 25 / (time + 1);         
          }
          else{
            _timer?.cancel(); // Cancel the previous timer
            _startTimer();
          }       
            _updateAndPlayVideo();
          // Play audio when the UI is built
          break;
        }
      }
    });
  }

  void option2Handler(){
    setState(() {
      for (Node nextNode in listOfNodes) {
        if (nextNode.iD == option2) {
          iD = nextNode.iD;
          option1 = nextNode.option1;
          option2 = nextNode.option2;
          option3 = nextNode.option3;
          optionOneText = nextNode.optionOneText;
          optionTwoText = nextNode.optionTwoText;
          optionThreeText = nextNode.optionThreeText;
          question = nextNode.question;
          video = nextNode.videoUrl;
          showOption1 = !showOption1;
          showOption3 = !showOption3;  
          if (question == "Perfect Response"){
            score += 100 / (time + 1);
          }
          if(question == "Okay Response"){
            score += 50 / (time + 1);
          }
          if(question == "Failed Response"){
            score += 25 / (time + 1);         
          }
          else{
            _timer?.cancel(); // Cancel the previous timer
            _startTimer();
          }     
            _updateAndPlayVideo();
          // Play audio when the UI is built
          break;
        }
      }
    });
  }

  void option3Handler(){
    setState(() {
      for (Node nextNode in listOfNodes) {
        if (nextNode.iD == option3) {
          iD = nextNode.iD;
          option1 = nextNode.option1;
          option2 = nextNode.option2;
          option3 = nextNode.option3;
          optionOneText = nextNode.optionOneText;
          optionTwoText = nextNode.optionTwoText;
          optionThreeText = nextNode.optionThreeText;
          question = nextNode.question;
          video = nextNode.videoUrl;
          showOption1 = !showOption1;
          showOption3 = !showOption3;
          if (question == "Perfect Response"){
            score += 115 / (time + 1);
          }
          if(question == "Okay Response"){
            score += 60 / (time + 1);
          }
          if(question == "Failed Response"){
            score += 20 / (time + 1);         
          }
          else{
            _timer?.cancel(); // Cancel the previous timer
            _startTimer();
          }     
          _updateAndPlayVideo();
          // Play audio when the UI is built
          break;
        }
      }
    });
  }

  void _updateAndPlayVideo() {
    if (_controller.value.isInitialized) {
      _controller.play();
      _controller.seekTo(Duration(seconds: _controller.value.duration.inSeconds));
      _controller.pause();
      _controller = VideoPlayerController.asset(video)
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
        });
      _controller.seekTo(Duration(seconds: _controller.value.duration.inSeconds));
      _controller.pause();
    }
  }
  
  int roundScore(double score) {
    return score.round();
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Align(
                  alignment: const Alignment(0.4, 0.7),
                  child: video.isNotEmpty
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              // Updated Align widget for option 1 button
              if (showOption1)
                Align(
                  alignment: const Alignment(-0.8, 0.7),
                  child: MaterialButton(
                    onPressed: () {
                      option1Handler();
                    },
                    color: Color.fromARGB(255, 47, 0, 255),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // Adjust the radius as needed
                    ),
                    textColor: const Color(0xfffffdfd),
                    height: 100,
                    minWidth: 180,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      optionOneText,
                      style: const TextStyle(
                        fontFamily: 'Roboto', // Set the font family to Roboto
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 37,
                        color: Color.fromARGB(255, 255, 255, 255), // White text color
                        shadows: [
                          Shadow( // Black outline
                            offset: Offset(0, 0),
                            blurRadius: 15, // Increase the blur radius for stronger outline
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Updated Align widget for option 2 button
              Align(
                alignment: const Alignment(0.0, 0.7),
                child: MaterialButton(
                  onPressed: () {
                    option2Handler();
                  },
                  color: Color.fromARGB(255, 214, 0, 0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40), // Adjust the radius as needed
                  ),
                  textColor: const Color(0xfffffdfd),
                  height: 100,
                  minWidth: 180,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    optionTwoText,
                    style: const TextStyle(
                      fontFamily: 'Roboto', // Set the font family to Roboto
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 37,
                      color: Color.fromARGB(255, 255, 255, 255), // White text color
                      shadows: [
                        Shadow( // Black outline
                          offset: Offset(0, 0),
                          blurRadius: 15, // Increase the blur radius for stronger outline
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Updated Align widget for option 3 button
              if (showOption3)
                Align(
                  alignment: const Alignment(0.8, 0.7),
                  child: MaterialButton(
                    onPressed: () {
                      option3Handler();
                    },
                    color: Color.fromARGB(255, 3, 0, 0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // Adjust the radius as needed
                    ),
                    textColor: const Color(0xfffffdfd),
                    height: 100,
                    minWidth: 180,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      optionThreeText,
                      style: const TextStyle(
                        fontFamily: 'Roboto', // Set the font family to Roboto
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 37,
                        color: Color.fromARGB(255, 255, 255, 255), // White text color
                        shadows: [
                          Shadow( // Black outline
                            offset: Offset(0, 0),
                            blurRadius: 15, // Increase the blur radius for stronger outline
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: const Alignment(0.0, -0.9),
                child: Text(
                  question,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontFamily: 'Roboto', // Set the font family to Roboto
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 64,
                    color: Color.fromARGB(255, 0, 0, 0), // White text color
                    shadows: [
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 15,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.8, -0.85),
                child: Text(
                  "Score ${roundScore(score)}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontFamily: 'Roboto', // Set the font family to Roboto
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 35,
                    color: Color.fromARGB(255, 0, 0, 0), // White text color
                    shadows: [
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 15,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(-0.8, -0.85),
                child: Text(
                  "Time: $time",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontFamily: 'Roboto', // Set the font family to Roboto
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 35,
                    color: Color.fromARGB(255, 0, 0, 0), // White text color
                    shadows: [
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 15,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

