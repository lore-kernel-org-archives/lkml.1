Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbZLZQu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbZLZQu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 11:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZLZQu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 11:50:58 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:53514 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867AbZLZQu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 11:50:57 -0500
Message-ID: <4B363EEE.8020108@blueyonder.co.uk>
Date: Sat, 26 Dec 2009 16:50:54 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: All kernels after 2.6.32-git10  show only 1 CPU ** Fixed in 2.6.33-rc2
 **
References: <4B324B76.9020901@blueyonder.co.uk> <4B33670C.7050503@blueyonder.co.uk> <4B341149.9010106@blueyonder.co.uk>
In-Reply-To: <4B341149.9010106@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something is weird on the 2P box. Using the openSUSE kernel
2.6.32-3-default and early 2.6.32-git kernels  on the 2P box, I see 2
processors. Same if I boot from the install DVD.
Using 2.6.32-git10, 2.6.32-git15, 2.6.33-rc[12] the box hangs solid at
various places during boot.
When I first booted up 2.6.33-rc2 after using the openSUSE 2.6.32-3
.config as the basis for "make oldconfig", the kernel booted fine with 2
CPU's, second and subsequent reboots, it locks up solid.
Later I shall try to get some output from a serial console.
tindog:/usr/src # uname -r
2.6.32-git1-smp
I shall also progress through the kernels to see exactly which
introduces the problem where a kernel will boot one time and not other
times and why only one CPU shows when those kernels boot.
Regards
Sid.


On 25/12/09 01:11, Sid Boyce wrote:
> Just made some changes to .config, shall try building on the 2P box with
> old .config to see if it's a config problem -- doubt so as the configs
> were fine with earlier kernels.
> Attaching the .config diff.
> slipstream:~ # uname -r
> 2.6.33-rc2-smp
> slipstream:~ # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 16
> model           : 4
> model name      : AMD Phenom(tm) II X4 940 Processor
> stepping        : 2
> cpu MHz         : 3013.988
> cache size      : 512 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 4
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
> wdt
> 
> 
> bogomips        : 6027.96
> 
> 
> 
> TLB size        : 1024 4K pages
> 
> 
> 
> clflush size    : 64
> 
> 
> 
> cache_alignment : 64
> 
> 
> 
> address sizes   : 48 bits physical, 48 bits virtual
> 
> 
> 
> power management: ts ttp tm stc 100mhzsteps hwpstate
> 
> 
> 
> 
> processor       : 1
> vendor_id       : AuthenticAMD
> cpu family      : 16
> model           : 4
> model name      : AMD Phenom(tm) II X4 940 Processor
> stepping        : 2
> cpu MHz         : 3013.988
> cache size      : 512 KB
> 
> 
> 
> physical id     : 0
> 
> 
> 
> siblings        : 4
> 
> 
> 
> core id         : 1
> 
> 
> 
> cpu cores       : 4
> 
> 
> 
> apicid          : 1
> 
> 
> 
> initial apicid  : 1
> 
> 
> 
> fpu             : yes
> 
> 
> 
> fpu_exception   : yes
> 
> 
> 
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
> bogomips        : 6027.27
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate
> 
> processor       : 2
> vendor_id       : AuthenticAMD
> cpu family      : 16
> model           : 4
> model name      : AMD Phenom(tm) II X4 940 Processor
> stepping        : 2
> cpu MHz         : 3013.988
> cache size      : 512 KB
> physical id     : 0
> siblings        : 4
> core id         : 2
> cpu cores       : 4
> apicid          : 2
> initial apicid  : 2
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
> bogomips        : 6027.27
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate
> 
> processor       : 3
> vendor_id       : AuthenticAMD
> cpu family      : 16
> model           : 4
> model name      : AMD Phenom(tm) II X4 940 Processor
> stepping        : 2
> cpu MHz         : 3013.988
> cache size      : 512 KB
> physical id     : 0
> siblings        : 4
> core id         : 3
> cpu cores       : 4
> apicid          : 3
> initial apicid  : 3
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
> bogomips        : 6027.27
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate
> Regards
> Sid.
> 
> On 24/12/09 13:05, Sid Boyce wrote:
>> On 23/12/09 16:55, Sid Boyce wrote:
>>> On the 4P box, 2.6.32-git10 boots and shows 4 CPU's, 2.6.32-git12 boots
>>> and shows 1 CPU, 2.6.32-git15 to 2.6.33-rc1-git3 1 CPU and lots of oops,
>>> continues with something like "Sending NMI interrupts to CPU's",
>>> [udev] unexpectedly returned with status 0x0100
>>> [udev] failed while handling /devices/pci000:00 -----etc--- same for
>>> other devices.
>>> Unable to capture via serial console as USB doesn't come ready.
>>>
>>> On 2P laptop, up to 2.6.33-rc1 boots, 1 CPU and boot option "acpi=noirq"
>>> needed, without it boot hangs, I think from 2.6.32-git15.
>>>  Building kernels, I have used the .config from previous kernel and
>>> "make oldconfig".
>>>
>>> # uname -r
>>> 2.6.32-git12-smp
>>> slipstream:~ # cat /proc/cpuinfo
>>> processor       : 0
>>> vendor_id       : AuthenticAMD
>>> cpu family      : 16
>>> model           : 4
>>> model name      : AMD Phenom(tm) II X4 940 Processor
>>> stepping        : 2
>>> cpu MHz         : 3013.597
>>> cache size      : 512 KB
>>> physical id     : 0
>>> siblings        : 1
>>> core id         : 0
>>> cpu cores       : 1
>>> apicid          : 0
>>> initial apicid  : 0
>>> fpu             : yes
>>> fpu_exception   : yes
>>> cpuid level     : 5
>>> wp              : yes
>>> flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
>>> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
>>> pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc up rep_good nonstop_tsc
>>> pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm
>>> sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
>>> bogomips        : 6027.18
>>> TLB size        : 1024 4K pages
>>> clflush size    : 64
>>> cache_alignment : 64
>>> address sizes   : 48 bits physical, 48 bits virtual
>>> power management: ts ttp tm stc 100mhzsteps hwpstate
>>>
>>> # uname -r
>>> 2.6.32-git10-smp
>>>
>>> # cat /proc/cpuinfo
>>> processor       : 0
>>> vendor_id       : AuthenticAMD
>>> cpu family      : 16
>>> model           : 4
>>> model name      : AMD Phenom(tm) II X4 940 Processor
>>> stepping        : 2
>>> cpu MHz         : 3013.774
>>> cache size      : 512 KB
>>> physical id     : 0
>>> siblings        : 4
>>> core id         : 0
>>> cpu cores       : 4
>>> apicid          : 0
>>> initial apicid  : 0
>>> fpu             : yes
>>> fpu_exception   : yes
>>> cpuid level     : 5
>>> wp              : yes
>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>>> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
>>> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
>>> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
>>> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
>>> bogomips        : 6027.53
>>> TLB size        : 1024 4K pages
>>> clflush size    : 64
>>> cache_alignment : 64
>>> address sizes   : 48 bits physical, 48 bits virtual
>>> power management: ts ttp tm stc 100mhzsteps hwpstate
>>>
>>> processor       : 1
>>> vendor_id       : AuthenticAMD
>>> cpu family      : 16
>>> model           : 4
>>> model name      : AMD Phenom(tm) II X4 940 Processor
>>> stepping        : 2
>>> cpu MHz         : 3013.774
>>> cache size      : 512 KB
>>> physical id     : 0
>>> siblings        : 4
>>> core id         : 1
>>> cpu cores       : 4
>>> apicid          : 1
>>> initial apicid  : 1
>>> fpu             : yes
>>> fpu_exception   : yes
>>> cpuid level     : 5
>>> wp              : yes
>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>>> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
>>> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
>>> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
>>> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
>>> bogomips        : 6027.27
>>> TLB size        : 1024 4K pages
>>> clflush size    : 64
>>> cache_alignment : 64
>>> address sizes   : 48 bits physical, 48 bits virtual
>>> power management: ts ttp tm stc 100mhzsteps hwpstate
>>>
>>> etc., up to processor 4.
>>>
>>> On the 2P box
>>> ===============
>>> tindog:~ # uname -r
>>> 2.6.33-rc1-smp
>>>
>>> tindog:~ # cat /proc/cpuinfo
>>> processor       : 0
>>> vendor_id       : AuthenticAMD
>>> cpu family      : 15
>>> model           : 67
>>> model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
>>> stepping        : 3
>>> cpu MHz         : 1000.000
>>> cache size      : 1024 KB
>>> physical id     : 0
>>> siblings        : 1
>>> core id         : 0
>>> cpu cores       : 1
>>> apicid          : 0
>>> initial apicid  : 0
>>> fpu             : yes
>>> fpu_exception   : yes
>>> cpuid level     : 1
>>> wp              : yes
>>> flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
>>> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
>>> rdtscp lm 3dnowext 3dnow up rep_good pni cx16 lahf_lm cmp_legacy svm
>>> extapic cr8_legacy
>>> bogomips        : 2009.33
>>> TLB size        : 1024 4K pages
>>> clflush size    : 64
>>> cache_alignment : 64
>>> address sizes   : 40 bits physical, 48 bits virtual
>>> power management: ts fid vid ttp tm stc
>>>
>>> The .config for the 4P and 2.6.33-rc1-git3 attached.
>>> Regards
>>> Sid.
>>>
>>
> 
> 


-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

