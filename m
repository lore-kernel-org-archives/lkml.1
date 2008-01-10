Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYAJMgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYAJMgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYAJMga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:36:30 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:57849 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYAJMg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:36:28 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: linux-kernel@vger.kernel.org
Subject: TSC && HPET calibration
Date: Thu, 10 Jan 2008 14:36:12 +0200
Message-Id: <20080110123612.M81049@visp.net.lb>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have same issue, but it's never passed synchronization.

Jan 10 12:59:44 visp-1 Time: tsc clocksource has been installed.
Jan 10 13:41:51 visp-1 ACPI: HPET 000F29CD, 0038 (r1 DELL   PE_SC3          1 
DELL        1)
Jan 10 13:41:51 visp-1 ACPI: HPET id: 0x8086a201 base: 0xfed00000
Jan 10 13:41:51 visp-1 hpet clockevent registered
Jan 10 13:41:51 visp-1 checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Jan 10 13:41:51 visp-1 checking TSC synchronization [CPU#0 -> CPU#2]:
Jan 10 13:41:51 visp-1 Measured 1020 cycles TSC warp between CPUs, turning 
off TSC clock.
Jan 10 13:41:51 visp-1 Marking TSC unstable due to: check_tsc_sync_source 
failed.
Jan 10 13:41:51 visp-1 hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Jan 10 13:41:51 visp-1 hpet0: 3 64-bit timers, 14318180 Hz
Jan 10 13:41:51 visp-1 Time: hpet clocksource has been installed.

grep Measures
Sep 19 14:31:28 visp-1 Measured 1044 cycles TSC warp between CPUs, turning 
off TSC clock.
Sep 19 18:22:46 visp-1 Measured 996 cycles TSC warp between CPUs, turning off 
TSC clock.
Sep 19 18:35:44 visp-1 Measured 1080 cycles TSC warp between CPUs, turning 
off TSC clock.
Sep 19 18:58:48 visp-1 Measured 1068 cycles TSC warp between CPUs, turning 
off TSC clock.
Sep 19 19:16:23 visp-1 Measured 1068 cycles TSC warp between CPUs, turning 
off TSC clock.
Sep 22 03:03:21 visp-1 Measured 912 cycles TSC warp between CPUs, turning off 
TSC clock.
Oct  1 12:06:21 visp-1 Measured 1176 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct  1 12:35:16 visp-1 Measured 984 cycles TSC warp between CPUs, turning off 
TSC clock.
Oct  1 12:53:37 visp-1 Measured 1212 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct  1 13:12:09 visp-1 Measured 1248 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct  1 13:13:45 visp-1 Measured 1116 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct  1 13:15:21 visp-1 Measured 1092 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct  1 13:16:56 visp-1 Measured 1092 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct  1 13:18:32 visp-1 Measured 984 cycles TSC warp between CPUs, turning off 
TSC clock.
Oct  1 13:20:07 visp-1 Measured 1020 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct  1 13:21:43 visp-1 Measured 1116 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct  1 13:23:18 visp-1 Measured 1008 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct  1 13:24:54 visp-1 Measured 1032 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct  1 13:26:29 visp-1 Measured 996 cycles TSC warp between CPUs, turning off 
TSC clock.
Oct  1 13:28:05 visp-1 Measured 1236 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct  1 13:29:40 visp-1 Measured 1332 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct  1 13:34:24 visp-1 Measured 1152 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct 10 02:02:25 visp-1 Measured 1056 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct 10 16:07:34 visp-1 Measured 972 cycles TSC warp between CPUs, turning off 
TSC clock.
Oct 10 16:22:40 visp-1 Measured 1140 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct 10 16:40:09 visp-1 Measured 996 cycles TSC warp between CPUs, turning off 
TSC clock.
Oct 26 16:28:40 visp-1 Measured 1152 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct 26 17:14:13 visp-1 Measured 972 cycles TSC warp between CPUs, turning off 
TSC clock.
Oct 26 17:24:57 visp-1 Measured 900 cycles TSC warp between CPUs, turning off 
TSC clock.
Oct 26 19:00:51 visp-1 Measured 1020 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct 26 22:15:21 visp-1 Measured 1032 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct 26 22:29:35 visp-1 Measured 768 cycles TSC warp between CPUs, turning off 
TSC clock.
Oct 27 10:41:49 visp-1 Measured 1032 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct 27 11:37:30 visp-1 Measured 852 cycles TSC warp between CPUs, turning off 
TSC clock.
Oct 27 11:58:26 visp-1 Measured 1092 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct 27 13:36:39 visp-1 Measured 1044 cycles TSC warp between CPUs, turning 
off TSC clock.
Oct 28 00:34:37 visp-1 Measured 792 cycles TSC warp between CPUs, turning off 
TSC clock.
Nov 18 22:31:00 visp-1 Measured 936 cycles TSC warp between CPUs, turning off 
TSC clock.
Jan 10 13:41:51 visp-1 Measured 1020 cycles TSC warp between CPUs, turning 
off TSC clock.


cpuinfo (it is Dual Xeon with HT PowerEdge)

visp-1 log # cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 4
cpu MHz         : 3192.070
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx cid cx16 xtpr lahf_lm
bogomips        : 6388.02
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 4
cpu MHz         : 3192.070
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx cid cx16 xtpr lahf_lm
bogomips        : 6383.74
clflush size    : 64

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 4
cpu MHz         : 3192.070
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx cid cx16 xtpr lahf_lm
bogomips        : 6383.75
clflush size    : 64

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 4
cpu MHz         : 3192.070
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx cid cx16 xtpr lahf_lm
bogomips        : 6383.74
clflush size    : 64


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

