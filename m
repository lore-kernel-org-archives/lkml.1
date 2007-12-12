Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbXLLTQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbXLLTQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756765AbXLLTQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:16:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:28709 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbXLLTQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:16:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:from;
        b=ObhRz0A38nFpbLt83EXt7tgtBGIDxQ1LnBeXkFFIN6M3BTJXT6jn78CVBmRbyN2H3CtLKdLrSXvDLHvUSWaOsqZaeHwK2L5R6iA4o8hIPV2VJWMYRTiSONdmYvgD+iepHvznYin01HmTFhGtMVTMcB8lzFgk/k6QqgU4Yhk5pYo=
Message-ID: <47603327.6070307@keyaccess.nl>
Date: Wed, 12 Dec 2007 20:14:47 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Chris Holvenstot <cholvenstot@comcast.net>
Subject: [RESULTS] Port 0x80 I/O speed
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone.

That was a succesful request, thanks to all who responded. This message also 
just now went out with all the respondents in CC but I believe that copy 
isn't making the list, so here's one without...

In total you provided 60 reports which are listed below in increasing order
of time spent for an outb to port 0x0. Let's face it, these things are
competitions, and Chris has won!

Time varies between 0.54 microseconds and 2.50 microseconds, with most
around 1.3/1.4 microseconds. Numbers 58, 59 and 60 (the ones at > 2 us) I
dont completely trust since similar machines are among the fastest as well.

Note also that ISA isn't applicable to those 3...

Most machines need no delays anywhere, and those that do would probably be
served with a udelay(1) as well but I believe this sampling is showing that
a udelay(2) would be the conservative choice.

Thanks again to all those that responded. There's probably a few cut & paste
and/or math errors in the below. The jury can not be held accountable for
any missed prestige!

Congrats to Chris... ;-)

Cheers,
   Rene

1.     0.54     Chris Holvenstot: out 1301, in 1252
                 AMD Athlon(tm) 64 X2 Dual Core Processor 4600+ (2412 MHz)

2.     0.56     Török Edwin: out 1107, in 1067
                 AMD Athlon(tm) 64 Processor 3200+, Asus A9N-E (2000 MHz)
		
3.     0.58     Mike Lampard: out 1342, in 249
                 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ (2300 mhZ)

4.     0.69     Jeremy O'Brien: out 411, in 519
                 Pentium III M 1400Mhz (600Mhz)

5.     0.76     Ville Syrjälä: out 1830, in 1166
                 Intel(R) Core(TM)2 CPU 6600 (2400MHz)

6.     0.78     Maxim Levitsky: out 1650, in 1065
                 Core 2 Duo (ICH8/Intel DG965RY motherboard) (2128 MHz)

7.     0.83     Paolo Ornati: out 1498, in 964
                 Core2 Duo 1.8 GHz (1800 Mhz)

8.     0.88     Ondrej Zary: out 2824, in 1899
                 Pentium 4 3.2GHz, i925X (3200 MHz)

9.     0.90     Dave Young: out 2522, in 1788
                 Intel(R) Pentium(R) D CPU 2.80GHz (2800 MHz)

10.     0.90    Randy Dunlap: out 2702, in 1903
                 Intel(R) Pentium(R) D CPU 3.00GHz (3000 MHz)

11.    1.08     Maxim Levitsky: out 1730, in 1138
                 Core 2 Duo (ICH8/Intel DG965RY motherboard) (1596 MHz)

12.    1.14     Peter Zijlstra: out 1743, in 1737
                 AMD Athlon(tm) MP 1800+ (1533 MHz)

13.    1.16     Peter Zijlstra: out 116, in 47
                 Pentium 133 (100 MHz)

14.    1.17     Ondrej Zary: out 263, in 93
                 Cyrix MII PR300 (225MHz), i430TX

15.    1.18     linux@horizon.com: out 1295, in 1162
                 1100 MHz Athlon, nForce2 chipset, nForce2 ISA bridge

16.    1.20     Ville Syrjälä: out 1925, in 1266
                 Intel(R) Core(TM)2 CPU 6600 (1596 MHz)

17.    1.21     Peter Zijlstra: out 811, in 354
                 Pentium III (Coppermine) (672 MHz)

18.    1.22     Juergen Beisert: out 1215, in 1094
                 Intel(R) Celeron(TM) CPU (1000MHz)

19.    1.23     Ondrej Zary: out 163, in 163
                 Pentium MMX 166MHz @133MHz, VIA VPX (133 Mhz)

20.    1.27     Dave Haywood: out 1183, in 706
                 Pentium III (Coppermine) 930 MHz

21.    1.28     Ondrej Zary: out 2178, in 1651
                 Celeron 1.7GHz (P4-based), i845 (1700 MHz)

22.    1.29     Olivér Pintér: out 4062, in 2502
                 Intel(R) Pentium(R) 4 CPU 3.00GHz (3150 Mhz)

23.    1.30     James Lamanna: out 3902, in 2372
                 Intel(R) Pentium(R) 4 CPU 3.00GHz

24.    1.31     Ville Syrjälä: out 914, in 406
                 Pentium III (Coppermine) 700 Mhz

25.    1.32     linux@horizon.com: out 794, in 348
                 600 MHz PIII (Katmai), 440BX chipset, 82371AB/EB/MB PIIX4:

26.    1.33     Edwin de Caluwé: out 667, in 305
                 Celeron (Coppermine) 500 MHz

27.    1.34     Ville Syrjälä: out 1142, in 475
                 Pentium III (Coppermine) 850 MHz

28.    1.35     Ville Syrjälä: out 607, in 272
                 Pentium II (Deschutes) 450 MHz

29.    1.36     Pádraig Brady: out 4069, in 2507
                 Intel(R) Pentium(R) 4 CPU 3.00GHz:

30.    1.37     Juergen Beisert: out 684, in 280
                 Pentium III (Katmai) 500 MHz

31.    1.37     Nigel Cunningham: out 2472, in 2505
                 AMD 1.8GHz Turion ATI RS480 - Mitac 8350 mobo (1800 MHz)

32.    1.38     Rene Herman: out 553, in 251
                 PII 400 (Intel 440BX) (400 MHz)

33.    1.40     Guennadi Liakhovetski: out 1263, in 1221
                 AMD Duron 900MHz

34.    1.41     John Stoffel: out 774, in 332
                 PIII, Dual 550Mhz Xeon

35.    1.42     Török Edwin: out 2368, in 1783
                 Intel Core Duo T2300 (Dell Inspiron 6400, ICH7) (1667 MHz)

36.    1.43     Luciano Rocha: out 2711, in 1856
                 Intel(R) Pentium(R) 4 CPU 1.90GHz

37.    1.43     Ondrej Zary: out 620, in 305
                 Celeron 433MHz, i440BX

38.    1.44     linux@horizon.com: out 624, in 297
                 433 MHz Celeron (Mendocino), 440 BX chipset

39.    1.44     Pádraig Brady: out 2588, in 2581
                 Dual-Core AMD Opteron(tm) Processor 2210 (1800)

40.    1.46     Pádraig Brady: out 2480, in 1666
                 Intel(R) Pentium(R) M processor 1.70GHz

41.    1.48     Guennadi Liakhovetski: out 1480, in 1409
                 VIA C7 1GHz

42.    1.51     Pádraig Brady: out 905, in 640
                 Intel(R) Pentium(R) M processor 1.70GHz (600 Mhz)

43.    1.51     Alejandro Riveira Fernández: out 3025, in 1653
                 AMD 3800 X2 (2000MHz) ULi M1697

44.    1.52     linux@horizon.com: out 1212, in 388
                 800 MHz Transmeta Crusoe TM5800, Transmeta/ALi M7101

45.    1.53     Nigel Cunningham: out 1231, in 1208
                 AMD 1.8GHz Turion ATI RS480 - Mitac 8350 mobo (800 MHz)

46.    1.56     Alejandro Riveira Fernández: out 1566, in 876
                 AMD 3800 X2 (1000MHz) ULi M1697

47.    1.58     Ondrej Zary: out 3367, in 1959
                 Xeon 3050 2.13GHz, Dell PE860

48.    1.61     Jiri Slaby: out 3217, in 1898
                 Intel(R) Xeon(R) CPU E5335  @ 2.00GHz

49.    1.63     Ondrej Zary: out 2114, in 849
                 Celeron 1.3GHz, i440BX

50.    1.64     Ondrej Zary: out 2631, in 1606
                 Xeon E5310 1.6GHz, Dell PE1950

51.    1.79     Cyrill Gorcunov: out 1428, in 1450
                 AMD Turion(tm) 64 Mobile Technology ML-30 (800 MHz)

52.    1.80     Alistair John Strachan: out 2712, in 2606
                 1.5GHz C7, Via chipset

53.    1.85     Rene Herman: out 2400, in 2400
                 AMD Duron 1300 (AMD756)

54.    1.92     Danny ter Haar: out 4038, in 1707
                 Intel(R) Pentium(R) M processor 2.10GHz

55.    1.97     Ville Syrjälä: out 2562, in 2562
                 AMD Duron(tm) processor 1300

56.    1.98     Danny ter Haar: out 1185, in 537
                 Intel(R) Pentium(R) M processor 2.10GHz (600 MHz)

57.    1.99     Romano Giannetti: out 3446, in 2652
                 CoreDuo T2080/1.73GHz

58.    2.17     Jiri Slaby: out 6500, in 3135
                 Intel(R) Core(TM)2 Duo CPU E6850  @ 3.00GHz

59.    2.23     linux@horizon.com: out 4914, in 4927
                 2200 MHz Athlon 64, K8T890 chipset, VT8237 ISA bridge:

60.    2.50     Jiri Slaby: out 5508, in 5524
                 Dual Core AMD Opteron(tm) Processor 275 (2200 MHz)


