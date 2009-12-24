Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbZLXNF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbZLXNF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 08:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZLXNFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 08:05:25 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:57736 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbZLXNFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 08:05:23 -0500
Message-ID: <4B33670C.7050503@blueyonder.co.uk>
Date: Thu, 24 Dec 2009 13:05:16 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: All kernels after 2.6.32-git10  show only 1 CPU
References: <4B324B76.9020901@blueyonder.co.uk>
In-Reply-To: <4B324B76.9020901@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/12/09 16:55, Sid Boyce wrote:
> On the 4P box, 2.6.32-git10 boots and shows 4 CPU's, 2.6.32-git12 boots
> and shows 1 CPU, 2.6.32-git15 to 2.6.33-rc1-git3 1 CPU and lots of oops,
> continues with something like "Sending NMI interrupts to CPU's",
> [udev] unexpectedly returned with status 0x0100
> [udev] failed while handling /devices/pci000:00 -----etc--- same for
> other devices.
> Unable to capture via serial console as USB doesn't come ready.
> 
> On 2P laptop, up to 2.6.33-rc1 boots, 1 CPU and boot option "acpi=noirq"
> needed, without it boot hangs, I think from 2.6.32-git15.
>  Building kernels, I have used the .config from previous kernel and
> "make oldconfig".
> 
> # uname -r
> 2.6.32-git12-smp
> slipstream:~ # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 16
> model           : 4
> model name      : AMD Phenom(tm) II X4 940 Processor
> stepping        : 2
> cpu MHz         : 3013.597
> cache size      : 512 KB
> physical id     : 0
> siblings        : 1
> core id         : 0
> cpu cores       : 1
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc up rep_good nonstop_tsc
> pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm
> sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
> bogomips        : 6027.18
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate
> 
> # uname -r
> 2.6.32-git10-smp
> 
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 16
> model           : 4
> model name      : AMD Phenom(tm) II X4 940 Processor
> stepping        : 2
> cpu MHz         : 3013.774
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
> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
> bogomips        : 6027.53
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate
> 
> processor       : 1
> vendor_id       : AuthenticAMD
> cpu family      : 16
> model           : 4
> model name      : AMD Phenom(tm) II X4 940 Processor
> stepping        : 2
> cpu MHz         : 3013.774
> cache size      : 512 KB
> physical id     : 0
> siblings        : 4
> core id         : 1
> cpu cores       : 4
> apicid          : 1
> initial apicid  : 1
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
> etc., up to processor 4.
> 
> On a 2P laptop
> ===============
> tindog:~ # uname -r
> 2.6.33-rc1-smp
> 
> tindog:~ # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 67
> model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
> stepping        : 3
> cpu MHz         : 1000.000
> cache size      : 1024 KB
> physical id     : 0
> siblings        : 1
> core id         : 0
> cpu cores       : 1
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> rdtscp lm 3dnowext 3dnow up rep_good pni cx16 lahf_lm cmp_legacy svm
> extapic cr8_legacy
> bogomips        : 2009.33
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 40 bits physical, 48 bits virtual
> power management: ts fid vid ttp tm stc
> 
> The .config for the 4P and 2.6.33-rc1-git3 attached.
> Regards
> Sid.
> 

Same problem with linux-next 20091224, only one penguin showing during boot.
To get linux-next to boot I had to use kernel command line "acpi=off",
without, it shows the failures noted above.
When booted /proc/cpuinfo shows only 1 of the 4 CPU's.
lancelot@slipstream:~/ftp/dec09> gcc -v
Using built-in specs.
Target: x86_64-suse-linux
Configured with: ../configure --prefix=/usr --infodir=/usr/share/info
--mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64
--enable-languages=c,c++,objc,fortran,obj-c++,java,ada
--enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.4
--enable-ssp --disable-libssp --with-bugurl=http://bugs.opensuse.org/
--with-pkgversion='SUSE Linux' --disable-libgcj --disable-libmudflap
--with-slibdir=/lib64 --with-system-zlib --enable-__cxa_atexit
--enable-libstdcxx-allocator=new --disable-libstdcxx-pch
--enable-version-specific-runtime-libs --program-suffix=-4.4
--enable-linux-futex --without-system-libunwind --with-arch-32=i586
--with-tune=generic --build=x86_64-suse-linux
Thread model: posix
gcc version 4.4.2 [gcc-4_4-branch revision 154496] (SUSE Linux)

Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

