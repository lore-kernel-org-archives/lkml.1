Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbZHVM52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbZHVM52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 08:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZHVM51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 08:57:27 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:33752 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZHVM50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 08:57:26 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_KUA7amAvG+nmvDScd80j8w)"
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression: Linux 2.6.31-rc7 lost sensors on asus mobo
Date: Sat, 22 Aug 2009 08:56:46 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5; KDE/4.2.4; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
 <200908212309.31505.gene.heskett@verizon.net>
 <alpine.LFD.2.01.0908212041130.3158@localhost.localdomain>
In-reply-to: <alpine.LFD.2.01.0908212041130.3158@localhost.localdomain>
Message-id: <200908220856.46141.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Boundary_(ID_KUA7amAvG+nmvDScd80j8w)
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline

On Friday 21 August 2009, Linus Torvalds wrote:
>On Fri, 21 Aug 2009, Gene Heskett wrote:
>> From messages when I attempt to access the it87:
>
>So what was the last kernel that worked ok for you?
>
>> Aug 21 22:59:37 coyote kernel: [  572.507928] it87: Found IT8716F chip at
>> 0x290, revision 1 Aug 21 22:59:37 coyote kernel: [  572.507937] it87: in3
>> is VCC (+5V) Aug 21 22:59:37 coyote kernel: [  572.507939] it87: in7 is
>> VCCH (+5V Stand-By) Aug 21 22:59:37 coyote kernel: [  572.508232] ACPI:
>> I/O resource it87 [0x295-0x296] conflicts with ACPI region IP__
>> [0x295-0x296] Aug 21 22:59:37 coyote kernel: [  572.508234] ACPI: Device
>> needs an ACPI driver
>
>There haven't been any changes to the it87 driver since 2.6.30, nor do I
>see any ACPI changes that would be relevant. Of course, if you used to
>build without any ACPI support at all, that region conflict wouldn't have
>shown up, so it _could_ be config-dependent, but that sounds unliklely
>too.
>
>			Linus

I rebooted a few times this morning, and the loss actually takes place 
between -rc5 and -rc6.  At rc6 and rc7, any attempt to load the it87 module 
gets a message advising the resources are busy and it refuses to load.

I'd get a sample of the error but I'm booted to -rc5 atm and its working.

I also noted that the output of sensors, when it works, contains more temps 
than gkrellm displays, except for THRM, the rest are all displayed as 32F in 
gkrellm.

Attached is a log of sorts, consisting of the output of uname -a, followed by 
the output of sensors during that boot, and the sensors modules loaded and 
linked during that boot.

Thank you.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Anyone can make an omelet with eggs.  The trick is to make one with none.


--Boundary_(ID_KUA7amAvG+nmvDScd80j8w)
Content-type: text/plain; charset=UTF-8; name=sensors-testing
Content-transfer-encoding: 8BIT
Content-disposition: attachment; filename=sensors-testing

Linux coyote.coyote.den 2.6.27.25-170.2.72.fc10.i686.PAE #1 SMP Sun Jun 21 18:51:33 EDT 2009 i686 athlon i386 GNU/Linux
it8716-isa-0290
Adapter: ISA adapter
VCore:       +1.14 V  (min =  +0.00 V, max =  +4.08 V)   
VDDR:        +3.22 V  (min =  +0.00 V, max =  +4.08 V)   
+3.3V:       +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
+5V:         +4.78 V  (min =  +0.00 V, max =  +6.85 V)   
+12V:       +11.46 V  (min =  +0.00 V, max = +16.32 V)   
in5:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
in6:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
5VSB:        +4.81 V  (min =  +0.00 V, max =  +6.85 V)   
VBat:        +2.96 V
fan1:       4090 RPM  (min =   65 RPM)
fan2:          0 RPM  (min =    0 RPM)
fan3:          0 RPM  (min =   10 RPM)  ALARM
temp1:       +45.0°C  (low  =  -1.0°C, high = +127.0°C)  sensor = thermal diode
temp2:       +40.0°C  (low  =  -5.0°C, high = +127.0°C)  sensor = transistor
temp3:       +11.0°C  (low  =  -1.0°C, high = +127.0°C)  sensor = transistor
cpu0_vid:   +0.613 V

lsmod|grep it87
it87                   21904  0 
hwmon_vid               6528  1 it87
hwmon                   6300  1 it87
Linux coyote.coyote.den 2.6.30.3 #1 SMP PREEMPT Mon Jul 27 03:30:41 EDT 2009 i686 athlon i386 GNU/Linux
it8716-isa-0290
Adapter: ISA adapter
VCore:       +1.14 V  (min =  +0.00 V, max =  +4.08 V)   
VDDR:        +3.22 V  (min =  +0.00 V, max =  +4.08 V)   
+3.3V:       +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
+5V:         +4.78 V  (min =  +0.00 V, max =  +6.85 V)   
+12V:       +11.46 V  (min =  +0.00 V, max = +16.32 V)   
in5:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
in6:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
5VSB:        +4.81 V  (min =  +0.00 V, max =  +6.85 V)   
VBat:        +2.96 V
fan1:       3901 RPM  (min =   65 RPM)
fan2:          0 RPM  (min =    0 RPM)
fan3:          0 RPM  (min =   10 RPM)  ALARM
temp1:       +44.0°C  (low  =  -1.0°C, high = +127.0°C)  sensor = thermal diode
temp2:       +40.0°C  (low  =  -5.0°C, high = +127.0°C)  sensor = thermistor
temp3:       +10.0°C  (low  =  -1.0°C, high = +127.0°C)  sensor = thermistor
cpu0_vid:   +0.613 V

lsmod|grep it87
it87                   20900  0 
hwmon_vid               2772  1 it87
hwmon                   2256  2 it87,asus_atk0110
Linux coyote.coyote.den 2.6.31-rc3 #3 SMP PREEMPT Wed Jul 29 13:07:57 EDT 2009 i686 athlon i386 GNU/Linux
it8716-isa-0290
Adapter: ISA adapter
VCore:       +1.14 V  (min =  +0.00 V, max =  +4.08 V)   
VDDR:        +3.20 V  (min =  +0.00 V, max =  +4.08 V)   
+3.3V:       +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
+5V:         +4.76 V  (min =  +0.00 V, max =  +6.85 V)   
+12V:       +11.46 V  (min =  +0.00 V, max = +16.32 V)   
in5:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
in6:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
5VSB:        +4.81 V  (min =  +0.00 V, max =  +6.85 V)   
VBat:        +2.96 V
fan1:       4017 RPM  (min =   65 RPM)
fan2:          0 RPM  (min =    0 RPM)
fan3:          0 RPM  (min =   10 RPM)  ALARM
temp1:       +44.0°C  (low  =  -1.0°C, high = +127.0°C)  sensor = thermal diode
temp2:       +40.0°C  (low  =  -5.0°C, high = +127.0°C)  sensor = thermistor
temp3:       +14.0°C  (low  =  -1.0°C, high = +127.0°C)  sensor = thermistor
cpu0_vid:   +0.613 V

lsmod|grep it87
it87                   20908  0 
hwmon_vid               2780  1 it87
hwmon                   2552  2 it87,asus_atk0110
Linux coyote.coyote.den 2.6.31-rc4 #12 SMP PREEMPT Wed Jul 29 13:56:40 EDT 2009 i686 athlon i386 GNU/Linux
it8716-isa-0290
Adapter: ISA adapter
VCore:       +1.14 V  (min =  +0.00 V, max =  +4.08 V)   
VDDR:        +3.22 V  (min =  +0.00 V, max =  +4.08 V)   
+3.3V:       +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
+5V:         +4.78 V  (min =  +0.00 V, max =  +6.85 V)   
+12V:       +11.46 V  (min =  +0.00 V, max = +16.32 V)   
in5:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
in6:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
5VSB:        +4.81 V  (min =  +0.00 V, max =  +6.85 V)   
VBat:        +2.96 V
fan1:       3994 RPM  (min =   65 RPM)
fan2:          0 RPM  (min =    0 RPM)
fan3:          0 RPM  (min =   10 RPM)  ALARM
temp1:       +46.0°C  (low  =  -1.0°C, high = +127.0°C)  sensor = thermal diode
temp2:       +40.0°C  (low  =  -5.0°C, high = +127.0°C)  sensor = thermistor
temp3:       +15.0°C  (low  =  -1.0°C, high = +127.0°C)  sensor = thermistor
cpu0_vid:   +0.613 V

lsmod|grep it87
it87                   20908  0 
hwmon_vid               2780  1 it87
hwmon                   2552  2 it87,asus_atk0110
Linux coyote.coyote.den 2.6.31-rc5 #3 SMP PREEMPT Tue Aug 4 22:43:36 EDT 2009 i686 athlon i386 GNU/Linux
it8716-isa-0290
Adapter: ISA adapter
VCore:       +1.14 V  (min =  +0.00 V, max =  +4.08 V)   
VDDR:        +3.22 V  (min =  +0.00 V, max =  +4.08 V)   
+3.3V:       +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
+5V:         +4.76 V  (min =  +0.00 V, max =  +6.85 V)   
+12V:       +11.46 V  (min =  +0.00 V, max = +16.32 V)   
in5:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
in6:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
5VSB:        +4.81 V  (min =  +0.00 V, max =  +6.85 V)   
VBat:        +2.96 V
fan1:       4166 RPM  (min =   65 RPM)
fan2:          0 RPM  (min =    0 RPM)
fan3:          0 RPM  (min =   10 RPM)  ALARM
temp1:       +46.0°C  (low  =  -1.0°C, high = +127.0°C)  sensor = thermal diode
temp2:       +40.0°C  (low  =  -5.0°C, high = +127.0°C)  sensor = thermistor
temp3:       +15.0°C  (low  =  -1.0°C, high = +127.0°C)  sensor = thermistor
cpu0_vid:   +0.613 V

lsmod|grep it87
it87                   20908  0 
hwmon_vid               2780  1 it87
hwmon                   2552  2 it87,asus_atk0110
Linux coyote.coyote.den 2.6.31-rc6 #3 SMP PREEMPT Fri Aug 21 12:18:57 EDT 2009 i686 athlon i386 GNU/Linux
lsmod|grep it87

And it is no longer possible to load the it87.ko module,
an lsmod says hwmon_vid and hwmon is loaded, but it87
claims the resources are busy and refuses to load.

So this is some change between -rc5 and -rc6.


--Boundary_(ID_KUA7amAvG+nmvDScd80j8w)--
