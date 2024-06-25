import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<bool> _sec = ValueNotifier(true);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      _sec.value = !_sec.value;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _sec.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: const Color(0xFF2D2F41),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(55.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF151538),
                  shape: BoxShape.circle,
                  boxShadow: [
                    const BoxShadow(
                      color: Color(0xff58586A),
                      offset: Offset(-9, -9),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(15, 15),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClockView(dateTime: DateTime.now()),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF151538).withOpacity(.8),
                    offset: const Offset(10, 10),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF151538),
              ),
              width: 170,
              height: 90,
              child: Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _sec,
                  builder: (context, sec, child) {
                    final now = DateTime.now();
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: now.hour.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                          TextSpan(
                            text: " : ",
                            style: TextStyle(
                              color:
                                  sec ? Colors.amber : const Color(0xFF2D2F41),
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                          TextSpan(
                            text: now.minute.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClockView extends StatelessWidget {
  final DateTime dateTime;

  const ClockView({super.key, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(dateTime: dateTime),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter({required this.dateTime});

  static const double radius = 150;
  static const double strokeWidth = 5;
  static const double strokeWidth2 = 2;
  static const double hourHandLength = 60;
  static const double minuteHandLength = 80;
  static const double secondHandLength = 100;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final fillBrush = Paint()..color = const Color(0xFF151538);

    final outlineBrush = Paint()
      ..color = const Color(0xFF151538).withOpacity(.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18;

    final outlineBrush2 = Paint()
      ..color = const Color(0xFF0D0E30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final centerFillBrush = Paint()..color = const Color(0xffF3B200);
    final centerFillBrush2 = Paint()..color = Colors.black;

    final secHandBrush = Paint()
      ..color = const Color(0xffF3B200)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final secHandBrush2 = Paint()
      ..color = const Color(0xffF3B200)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    final minHandBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final hourHandBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    final hourHandBrush2 = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth2;

    final secMarkerBrush = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outlineBrush);
    canvas.drawCircle(center, radius - 40, outlineBrush2);

    final hourHandX = center.dx +
        hourHandLength *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    final hourHandY = center.dy +
        hourHandLength *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    final minHandX =
        center.dx + minuteHandLength * cos(dateTime.minute * 6 * pi / 180);
    final minHandY =
        center.dy + minuteHandLength * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    final secHandX =
        center.dx + secondHandLength * cos(dateTime.second * 6 * pi / 180);
    final secHandY =
        center.dy + secondHandLength * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    final secHandX2 = center.dx - 20 * cos(dateTime.second * 6 * pi / 180);
    final secHandY2 = center.dy - 20 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX2, secHandY2), secHandBrush2);

    canvas.drawCircle(center, 10, centerFillBrush);
    canvas.drawCircle(center, 3, centerFillBrush2);

    const outerCircleRadius = radius - 40;
    const innerCircleRadius = outerCircleRadius - 10;
    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30) * pi / 180;
      final outerX = center.dx + outerCircleRadius * cos(angle);
      final outerY = center.dy + outerCircleRadius * sin(angle);
      final innerX = center.dx + innerCircleRadius * cos(angle);
      final innerY = center.dy + innerCircleRadius * sin(angle);
      canvas.drawLine(
          Offset(outerX, outerY), Offset(innerX, innerY), hourHandBrush2);
    }

    for (int i = 1; i <= 60; i++) {
      final angle = (i * 6) * pi / 180;
      final outerX = center.dx + outerCircleRadius * cos(angle);
      final outerY = center.dy + outerCircleRadius * sin(angle);
      final innerX = center.dx + (outerCircleRadius - 5) * cos(angle);
      final innerY = center.dy + (outerCircleRadius - 5) * sin(angle);
      canvas.drawLine(
          Offset(outerX, outerY), Offset(innerX, innerY), secMarkerBrush);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
