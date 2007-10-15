Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbXJOIHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbXJOIHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 04:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXJOIGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 04:06:55 -0400
Received: from lucidpixels.com ([75.144.35.66]:34923 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbXJOIGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 04:06:54 -0400
Date: Mon, 15 Oct 2007 04:06:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
cc: linux-kernel@vger.kernel.org, apiszcz@solarrain.com,
       Hans de Goede <j.w.r.degoede@hhs.nl>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: 2.6.23.1 x86 hardware monitoring bug?
In-Reply-To: <20071015025331.GA3676@jupiter.solarsys.private>
Message-ID: <Pine.LNX.4.64.0710150406220.9867@p34.internal.lan>
References: <Pine.LNX.4.64.0710141526590.3935@p34.internal.lan>
 <20071015025331.GA3676@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1898563921-1192435612=:9867"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1898563921-1192435612=:9867
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 14 Oct 2007, Mark M. Hoffman wrote:

> Hi Justin:
>
> (added some CCs)
>
> * Justin Piszcz <jpiszcz@lucidpixels.com> [2007-10-14 15:30:18 -0400]:
>> As a regular user, I cannot see the sensors on the A-bit board, but I ca=
n
>> see the CPU temperature, how come I can see one but not the other?
>>
>> Kernel: $ uname -a
>> Linux mybox 2.6.23.1 #4 SMP PREEMPT Sun Oct 14 15:20:53 EDT 2007 i686
>> GNU/Linux
>> Distribution: Debian Lenny
>>
>> $ sensors
>> abituguru3-isa-00e0
>> Adapter: ISA adapter
>>
>> coretemp-isa-0000
>> Adapter: ISA adapter
>> temp1:       +35=B0C  (high =3D   +85=B0C)
>>
>> coretemp-isa-0001
>> Adapter: ISA adapter
>> temp1:       +36=B0C  (high =3D   +85=B0C)
>>
>> As root:
>>
>> # sensors
>> abituguru3-isa-00e0
>> Adapter: ISA adapter
>> CPU Core:               +1.35 V  (min  +0.00 V, max  +1.60 V)
>> DDR2:                   +2.02 V  (min  +1.60 V, max  +2.40 V)
>> DDR2 VTT:               +1.01 V  (min  +0.80 V, max  +1.20 V)
>> CPU VTT 1.2V:           +1.22 V  (min  +0.95 V, max  +1.45 V)
>> MCH & PCIE 1.5V:        +1.50 V  (min  +1.20 V, max  +1.80 V)
>> MCH 2.5V:               +2.58 V  (min  +2.00 V, max  +3.00 V)
>> ICH 1.05V:              +1.04 V  (min  +0.85 V, max  +1.25 V)
>> ATX +12V (24-Pin):     +12.18 V  (min  +9.60 V, max +14.40 V)
>> ATX +12V (4-pin):      +12.24 V  (min  +9.60 V, max +14.40 V)
>> ATX +5V:                +5.07 V  (min  +3.99 V, max  +6.00 V)
>> +3.3V:                  +3.40 V  (min  +2.64 V, max  +3.94 V)
>> 5VSB:                   +5.10 V  (min  +3.99 V, max  +6.00 V)
>> CPU:                      +43=B0C  (high =3D   +75=B0C, crit =3D   +85=
=B0C)
>> System :                  +38=B0C  (high =3D   +55=B0C, crit =3D   +65=
=B0C)
>> PWM1:                     +43=B0C  (high =3D   +80=B0C, crit =3D   +90=
=B0C)
>> PWM2:                     +43=B0C  (high =3D   +80=B0C, crit =3D   +90=
=B0C)
>> PWM3:                     +46=B0C  (high =3D   +80=B0C, crit =3D   +90=
=B0C)
>> PWM4:                     +40=B0C  (high =3D   +80=B0C, crit =3D   +90=
=B0C)
>> CPU Fan:               1380 RPM  (min  300 RPM)
>> NB Fan:                   0 RPM  (min  300 RPM)
>> SYS Fan:                  0 RPM  (min  300 RPM)
>> AUX1 Fan:                 0 RPM  (min  300 RPM)
>> AUX2 Fan:                 0 RPM  (min  300 RPM)
>> AUX3 Fan:                 0 RPM  (min  300 RPM)
>> OTES1 Fan:                0 RPM  (min  300 RPM)
>>
>> coretemp-isa-0000
>> Adapter: ISA adapter
>> Core 0:      +39=B0C  (high =3D   +85=B0C)
>>
>> coretemp-isa-0001
>> Adapter: ISA adapter
>> Core 1:      +39=B0C  (high =3D   +85=B0C)
>
> Strange.  What does 'ls -lH /sys/class/hwmon/hwmon*/device' say?
>
> Regards,
>
> --=20
> Mark M. Hoffman
> mhoffman@lightlink.com
>

Output from ls -lH /sys/class/hwmon/hwmon*/device:

/sys/class/hwmon/hwmon0/device:
total 0
lrwxrwxrwx 1 root root    0 2007-10-15 03:59 driver -> ../../../bus/platfor=
m/drivers/abituguru3
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan1_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan1_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan1_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan1_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan1_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan1_min
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan1_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan2_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan2_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan2_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan2_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan2_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan2_min
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan2_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan3_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan3_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan3_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan3_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan3_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan3_min
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan3_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan4_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan4_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan4_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan4_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan4_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan4_min
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan4_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan5_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan5_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan5_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan5_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan5_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan5_min
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan5_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan6_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan6_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan6_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan6_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan6_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan6_min
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan6_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan7_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan7_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan7_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan7_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan7_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 fan7_min
-r--r--r-- 1 root root 4096 2007-10-15 04:06 fan7_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in0_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in0_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in0_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in0_max
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in0_max_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in0_max_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in0_min
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in0_min_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in0_min_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in0_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in10_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in10_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in10_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in10_max
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in10_max_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in10_max_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in10_min
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in10_min_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in10_min_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in10_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in11_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in11_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in11_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in11_max
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in11_max_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in11_max_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in11_min
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in11_min_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in11_min_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in11_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in1_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in1_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in1_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in1_max
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in1_max_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in1_max_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in1_min
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in1_min_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in1_min_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in1_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in2_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in2_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in2_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in2_max
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in2_max_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in2_max_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in2_min
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in2_min_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in2_min_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in2_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in3_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in3_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in3_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in3_max
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in3_max_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in3_max_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in3_min
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in3_min_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in3_min_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in3_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in4_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in4_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in4_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in4_max
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in4_max_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in4_max_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in4_min
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in4_min_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in4_min_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in4_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in5_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in5_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in5_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in5_max
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in5_max_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in5_max_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in5_min
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in5_min_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in5_min_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in5_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in6_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in6_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in6_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in6_max
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in6_max_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in6_max_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in6_min
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in6_min_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in6_min_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in6_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in7_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in7_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in7_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in7_max
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in7_max_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in7_max_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in7_min
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in7_min_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in7_min_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in7_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in8_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in8_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in8_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in8_max
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in8_max_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in8_max_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in8_min
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in8_min_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in8_min_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in8_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in9_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in9_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in9_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in9_max
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in9_max_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in9_max_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in9_min
-r--r--r-- 1 root root 4096 2007-10-15 03:59 in9_min_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in9_min_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 in9_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 04:06 modalias
-r--r--r-- 1 root root 4096 2007-10-15 03:59 name
lrwxrwxrwx 1 root root    0 2007-10-15 03:59 subsystem -> ../../../bus/plat=
form
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp1_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp1_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_crit
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_max
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp1_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp2_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp2_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp2_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp2_crit
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp2_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp2_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp2_max
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp2_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp3_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp3_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp3_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp3_crit
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp3_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp3_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp3_max
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp3_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp4_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp4_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp4_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp4_crit
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp4_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp4_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp4_max
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp4_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp5_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp5_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp5_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp5_crit
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp5_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp5_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp5_max
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp5_shutdown
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp6_alarm
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp6_alarm_enable
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp6_beep
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp6_crit
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp6_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp6_label
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp6_max
-r--r--r-- 1 root root 4096 2007-10-15 04:06 temp6_shutdown
-rw-r--r-- 1 root root 4096 2007-10-14 23:59 uevent

/sys/class/hwmon/hwmon1/device:
total 0
lrwxrwxrwx 1 root root    0 2007-10-15 03:59 driver -> ../../../bus/platfor=
m/drivers/coretemp
-r--r--r-- 1 root root 4096 2007-10-15 04:06 modalias
-r--r--r-- 1 root root 4096 2007-10-15 03:59 name
lrwxrwxrwx 1 root root    0 2007-10-15 03:59 subsystem -> ../../../bus/plat=
form
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_crit
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_crit_alarm
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_label
-rw-r--r-- 1 root root 4096 2007-10-14 23:59 uevent

/sys/class/hwmon/hwmon2/device:
total 0
lrwxrwxrwx 1 root root    0 2007-10-15 03:59 driver -> ../../../bus/platfor=
m/drivers/coretemp
-r--r--r-- 1 root root 4096 2007-10-15 04:06 modalias
-r--r--r-- 1 root root 4096 2007-10-15 03:59 name
lrwxrwxrwx 1 root root    0 2007-10-15 03:59 subsystem -> ../../../bus/plat=
form
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_crit
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_crit_alarm
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_input
-r--r--r-- 1 root root 4096 2007-10-15 03:59 temp1_label
-rw-r--r-- 1 root root 4096 2007-10-14 23:59 uevent
---1463747160-1898563921-1192435612=:9867--
