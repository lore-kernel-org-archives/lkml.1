Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbZDJINR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbZDJINR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 04:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbZDJIMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 04:12:53 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:25761 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbZDJIMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 04:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qRr2xzlVeZST0cwrzLSuUcpOGQsHh4NMA9sVnuKZnBpBvZQ7SbpceCM+cC0CfqjNQ2
         Bu+r4RD4Ye9Xe6QeVLj000cRKGq0u6+Wnp31/RhAthV9sbnoPR67FfCny3uNGAzab99L
         us96yYVGSatxhmivhisVNzCBaLVnImfl58tRo=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
	 <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
Date: Fri, 10 Apr 2009 17:12:47 +0900
Message-ID: <49b7c2350904100112h1abde05cuc906e0a158f9b4c8@mail.gmail.com>
Subject: Re: [Announce] 2.6.29.1-rt6
From: GeunSik Lim <leemgs1@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thomas

Thank you for your notice about new rt patch.
I am running linux-2.6.29.1-rt6  on Q9300 with fedora 9 distribution
normally like belows. So I changed version from linux-2.6.29-rt2 to
linux-2.6.29.1-rt6.
I will test about  a various case with linux-2.6.29.1-rt6 version.

[invain@fedora9 invain]$ uname -a
Linux fedora9 2.6.29.1-rt6-lgs #1 SMP PREEMPT RT Fri Apr 10 10:02:20
KST 2009 i686 i686 i386 GNU/Linux
[invain@fedora9 invain]$ cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz
stepping	: 7
cpu MHz		: 2494.087
cache size	: 3072 KB
physical id	: 0
siblings	: 1
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi
flexpriority
bogomips	: 4988.17
clflush size	: 64
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz
stepping	: 7
cpu MHz		: 2494.087
cache size	: 3072 KB
physical id	: 0
siblings	: 1
core id		: 1
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi
flexpriority
bogomips	: 4987.23
clflush size	: 64
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz
stepping	: 7
cpu MHz		: 2494.087
cache size	: 3072 KB
physical id	: 0
siblings	: 1
core id		: 2
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi
flexpriority
bogomips	: 4987.24
clflush size	: 64
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz
stepping	: 7
cpu MHz		: 2494.087
cache size	: 3072 KB
physical id	: 0
siblings	: 1
core id		: 3
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi
flexpriority
bogomips	: 4987.28
clflush size	: 64
power management:

[invain@fedora9 invain]$ cat /proc/meminfo
MemTotal:        3075816 kB
MemFree:          904416 kB
Buffers:          196168 kB
Cached:          1573864 kB
SwapCached:            0 kB
Active:          1079948 kB
Inactive:         990804 kB
Active(anon):     313180 kB
Inactive(anon):        0 kB
Active(file):     766768 kB
Inactive(file):   990804 kB
Unevictable:        2468 kB
Mlocked:            2468 kB
HighTotal:       2222408 kB
HighFree:         327460 kB
LowTotal:         853408 kB
LowFree:          576956 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:               300 kB
Writeback:             0 kB
AnonPages:        303200 kB
Mapped:            86460 kB
Slab:              65668 kB
SReclaimable:      51816 kB
SUnreclaim:        13852 kB
PageTables:         4568 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1537908 kB
Committed_AS:     719312 kB
VmallocTotal:     122880 kB
VmallocUsed:       45324 kB
VmallocChunk:      50164 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       81912 kB
DirectMap4M:      823296 kB
[invain@fedora9 invain]$ sudo lspci
[sudo] password for invain:
00:00.0 Host bridge: Intel Corporation 82Q35 Express DRAM Controller (rev 02)
00:01.0 PCI bridge: Intel Corporation 82Q35 Express PCI Express Root
Port (rev 02)
00:03.0 Communication controller: Intel Corporation 82Q35 Express MEI
Controller (rev 02)
00:03.2 IDE interface: Intel Corporation 82Q35 Express PT IDER
Controller (rev 02)
00:03.3 Serial controller: Intel Corporation 82Q35 Express Serial KT
Controller (rev 02)
00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit
Network Connection (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #5 (rev 02)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #6 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation 82801IO (ICH9DO) LPC Interface
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 4
port SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
00:1f.5 IDE interface: Intel Corporation 82801I (ICH9 Family) 2 port
SATA IDE Controller (rev 02)
01:00.0 VGA compatible controller: nVidia Corporation GeForce 8500 GT (rev a1)
11:07.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet
Pro 100 (rev 10)
[invain@fedora9 invain]$
[invain@fedora9 invain]$
[invain@fedora9 tracing]$

[invain@fedora9 tracing]$ cd /
[invain@fedora9 /]$ ls /debug/tracing/ -al
합계 0
drwxr-xr-x 6 root root 0 2009-04-10 15:09 .
drwxr-xr-x 8 root root 0 2009-04-10 15:09 ..
-rw-r--r-- 1 root root 0 2009-04-10 15:09 README
-r--r--r-- 1 root root 0 2009-04-10 15:09 available_events
-r--r--r-- 1 root root 0 2009-04-10 15:09 available_filter_functions
-r--r--r-- 1 root root 0 2009-04-10 15:09 available_tracers
-rw-r--r-- 1 root root 0 2009-04-10 15:09 buffer_size_kb
-r--r--r-- 1 root root 0 2009-04-10 15:09 current_tracer
-r--r--r-- 1 root root 0 2009-04-10 15:09 dyn_ftrace_total_info
drwxr-xr-x 5 root root 0 2009-04-10 15:09 events
-r--r--r-- 1 root root 0 2009-04-10 15:09 failures
drwxr-xr-x 2 root root 0 2009-04-10 15:09 options
drwxr-xr-x 6 root root 0 2009-04-10 15:09 per_cpu
-r--r--r-- 1 root root 0 2009-04-10 15:09 printk_formats
-rw-r--r-- 1 root root 0 2009-04-10 15:09 set_event
-rw-r--r-- 1 root root 0 2009-04-10 15:09 set_ftrace_filter
-rw-r--r-- 1 root root 0 2009-04-10 15:09 set_ftrace_notrace
-rw-r--r-- 1 root root 0 2009-04-10 15:09 set_ftrace_pid
-r--r--r-- 1 root root 0 2009-04-10 15:09 set_graph_function
-rw-r--r-- 1 root root 0 2009-04-10 15:09 stack_max_size
-r--r--r-- 1 root root 0 2009-04-10 15:09 stack_trace
-rw-r--r-- 1 root root 0 2009-04-10 15:09 sysprof_sample_period
-rw-r--r-- 1 root root 0 2009-04-10 15:09 trace
--w--w---- 1 root root 0 2009-04-10 15:09 trace_marker
-rw-r--r-- 1 root root 0 2009-04-10 15:09 trace_options
-r--r--r-- 1 root root 0 2009-04-10 15:09 trace_pipe
drwxr-xr-x 2 root root 0 2009-04-10 15:09 trace_stat
-rw-r--r-- 1 root root 0 2009-04-10 15:09 tracing_cpumask
-rw-r--r-- 1 root root 0 2009-04-10 15:09 tracing_enabled
-rw-r--r-- 1 root root 0 2009-04-10 15:09 tracing_max_latency
-rw-r--r-- 1 root root 0 2009-04-10 15:09 tracing_on
-rw-r--r-- 1 root root 0 2009-04-10 15:09 tracing_thresh
[invain@fedora9 /]$
[invain@fedora9 /]$
[invain@fedora9 /]$ cat /debug/tracing/available_tracers
syscall blk kmemtrace power branch function_graph mmiotrace wakeup_rt
wakeup irqsoff function sched_switch initcall nop
[invain@fedora9 /]$
[invain@fedora9 tracing]$
[invain@fedora9 tracing]$
[invain@fedora9 tracing]$
[invain@fedora9 tracing]$ sudo cyclictest  -t 10 -b 1000000 --context -D 10
could not set latency_hist/wakeup_latency/reset to 1
0.16 0.20 0.20 1/331 4338

T: 0 ( 4328) P: 0 I:1000 C:   8984 Min:     17 Act:13017 Avg: 8675 Max:   13498
T: 1 ( 4329) P: 0 I:1500 C:   5994 Min:     17 Act: 6048 Avg: 3982 Max:    6190
T: 2 ( 4330) P: 0 I:2000 C:   4498 Min:     17 Act: 2028 Avg: 1196 Max:    2759
T: 3 ( 4331) P: 0 I:2500 C:   3598 Min:     17 Act: 2517 Avg: 1494 Max:    2786
T: 4 ( 4332) P: 0 I:3000 C:   2999 Min:     17 Act:   18 Avg:   25 Max:     514
T: 5 ( 4333) P: 0 I:3500 C:   2571 Min:     17 Act:   18 Avg:   22 Max:     654
T: 6 ( 4334) P: 0 I:4000 C:   2249 Min:     17 Act:   25 Avg:   23 Max:     466
T: 7 ( 4335) P: 0 I:4500 C:   1993 Min:     17 Act:31521 Avg:19809 Max:   33231
T: 8 ( 4336) P: 0 I:5000 C:   1800 Min:     17 Act:   36 Avg:   29 Max:    1095
T: 9 ( 4337) P: 0 I:5500 C:   1636 Min:     17 Act:   29 Avg:   21 Max:     385
[invain@fedora9 tracing]$ tail trace
           gedit-4093  [003] 4154503193.109679:   4093:120:D ==> [003]
 3003:120:R Xorg
            Xorg-3003  [003] 4154503193.109728:   3003:120:D ==> [003]
    0:140:R <idle>
          <idle>-0     [003] 4154503193.110171:      0:140:R   + [003]
 4327:120:D cyclictest
          <idle>-0     [003] 4154503193.110176:      0:140:R ==> [003]
 4327:120:R cyclictest
          <idle>-0     [002] 4154503193.110217:      0:140:R   + [002]
   32: 49:D sirq-timer/2
          <idle>-0     [002] 4154503193.110222:      0:140:R ==> [002]
   32: 49:R sirq-timer/2
    sirq-timer/2-32    [002] 4154503193.110230:     32: 49:D ==> [002]
    0:140:R <idle>
      cyclictest-4327  [003] 4154503193.110344:   4327:120:R   + [003]
   45: 49:D sirq-timer/3
      cyclictest-4327  [003] 4154503193.110349:   4327:120:R ==> [003]
   45: 49:R sirq-timer/3
    sirq-timer/3-45    [003] 4154503193.110355:     45: 49:D ==> [003]
 4327:120:R cyclictest
[invain@fedora9 tracing]$


Regards,
GeunSik Lim.

2009/4/10 Thomas Gleixner <tglx@linutronix.de>:
> We are pleased to announce the next update to our new preempt-rt
> series.
>
>        - rt locks fixes (Jan Blunck, tglx)
>        - kvm vs. -rt fixes (Jan Blunck)
>        - hpet interrupt fix (tglx, reported and tested by Hans Peter Bock)
>
> Download locations:
>
>     http://rt.et.redhat.com/download/
>     http://www.kernel.org/pub/linux/kernel/projects/rt/
>
> Information on the RT patch can be found at:
>
>     http://rt.wiki.kernel.org/index.php/Main_Page
>
> to build the 2.6.29.1-rt6 tree, the following patches should be
> applied:
>
>     http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.1.tar.bz2
>     http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29.1-rt6.bz2
>
> The broken out patches are also available at the same download
> locations.
>
> Enjoy !
>
>       tglx
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
