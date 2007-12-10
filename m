Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbXLJCBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbXLJCBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXLJCA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:00:56 -0500
Received: from mx03.nsgroup.net ([195.84.17.43]:59641 "EHLO mx03.nsgroup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbXLJCA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:00:56 -0500
X-Greylist: delayed 812 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2007 21:00:55 EST
Message-ID: <475C9B06.9000901@nerdmail.nu>
Date: Mon, 10 Dec 2007 02:48:54 +0100
From: Alexander Rajula <chris@nerdmail.nu>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: /proc/cpuinfo reports erroneous CPU frequency. (2.6.23 &
 2.6.22)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-velocity-MailScanner-Information: Please contact the ISP for more information
X-velocity-MailScanner: Found to be clean
X-velocity-MailScanner-From: chris@nerdmail.nu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While using 2.6.23 and 2.6.22 (earlier kernels have not been tested) /proc/cpuinfo reports the wrong CPU frequency:


While overclocking an AMD Athlon X2 (2GHz) CPU /proc/cpuinfo reports the wrong CPU frequency.
I am quite puzzled by this.
Is this an error in the kernel, or is there something strange going on?


Output from /proc/cpuinfo (processor at 3.0GHz in BIOS):

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 75
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping        : 2
cpu MHz         : 2300.043
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips        : 4602.12
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 75
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping        : 2
cpu MHz         : 2300.043
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips        : 4599.31
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm st



Output from scripts/ver_linux:

Linux dubbelmacka 2.6.23-gentoo-r3 #3 SMP PREEMPT Mon Dec 10 00:46:09 CET 2007 x
86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ AuthenticAMD GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               Binutils
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
reiserfsprogs          3.6.19
reiser4progs           1.0.5
PPP                    2.4.4
Linux C Library        2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.9
udev                   115
Modules Loaded         nvidia

