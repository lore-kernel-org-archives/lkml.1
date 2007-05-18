Return-Path: <linux-kernel-owner+w=401wt.eu-S1762261AbXERRIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762261AbXERRIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756990AbXERRId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:08:33 -0400
Received: from ns.armcci.am ([195.250.88.164]:41705 "EHLO ns.armcci.am"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600AbXERRId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:08:33 -0400
X-Greylist: delayed 1245 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 May 2007 13:08:31 EDT
Date: Fri, 18 May 2007 21:47:36 +0500 (AMST)
From: eugene@ns.armcci.am
To: linux-kernel@vger.kernel.org
Subject: ht CPU flag
Message-ID: <Pine.LNX.4.64.0705182131030.25685@ns.armcci.am>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello dear developers!

Here is my system configuration.

Linux ns 2.6.19-gentoo-r5 #5 SMP Thu May 3 00:45:12 AMST 2007 i686 
Intel(R) Pentium(R) D CPU 3.00GHz GenuineIntel GNU/Linux

Gnu C                  4.1.1
Gnu make               3.81
binutils               2.16.1
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
reiserfsprogs          3.6.19
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.4
udev                   104
Modules Loaded         ipt_ULOG iptable_filter iptable_mangle iptable_nat 
ip_nat ip_tables x_tables rtc nls_iso8859_5 ntfs ip_conntrack_ftp 
ip_conntrack nfnetlink e1000 e100 intelfb i2c_algo_bit intel_agp agpgart 
i2c_i801 i2c_core ehci_hcd pcspkr uhci_hcd usbcore sg
---------------------------------------------------------------------------

I have Pentium D CPU, which many Windows utilities like cpuz, wcpuid, 
everest identify as D 930 (Dual Core, 3GHz). From Intel site I find out 
that it has no HT feature, nor Windows XP identify it as HT.

Why do I have "ht" flag in cpuinfo?
-----------------------------------

cat /proc/cpuinfo
-----------------
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Pentium(R) D CPU 3.00GHz
stepping        : 5
cpu MHz         : 2992.732
cache size      : 2048 KB
physical id     : 0
siblings        : 2
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
constant_tsc pni monitor ds_cpl est cid cx16 xtpr lahf_lm
bogomips        : 5990.31

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Pentium(R) D CPU 3.00GHz
stepping        : 5
cpu MHz         : 2992.732
cache size      : 2048 KB
physical id     : 0
siblings        : 2
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
constant_tsc pni monitor ds_cpl est cid cx16 xtpr lahf_lm
bogomips        : 5985.19
---------------------------------------------------------------------------

So, how must I choose kernel settings like:

number of CPU's?
HT support?

Best regards, Eugene.
