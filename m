Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbXESIeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbXESIeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 04:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbXESIeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 04:34:10 -0400
Received: from ns.armcci.am ([195.250.88.164]:55284 "EHLO ns.armcci.am"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbXESIeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 04:34:08 -0400
Date: Sat, 19 May 2007 13:33:56 +0500 (AMST)
From: eugene@ns.armcci.am
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: ht CPU flag
In-Reply-To: <464E96A1.60808@zytor.com>
Message-ID: <Pine.LNX.4.64.0705191328090.31481@ns.armcci.am>
References: <Pine.LNX.4.64.0705182131030.25685@ns.armcci.am>
 <464DFBE0.5060904@redhat.com> <Pine.LNX.4.64.0705190023420.25685@ns.armcci.am>
 <464E03C5.6040507@redhat.com> <Pine.LNX.4.64.0705190858590.29910@ns.armcci.am>
 <464E96A1.60808@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 May 2007, H. Peter Anvin wrote:

> eugene@ns.armcci.am wrote:
>> As I already told, there is no stepping 4 for Xeons on Intel site! So
>> /proc/cpuinfo, dmidecode, x86info are all wrong.
>> Moreover, x86info is too old and can't work with /sys fs.
>>
>> Also Linux is poor on giving FSB and Memory frequency, which I need to
>> be sure that memory timing is correct (SPD gives slower parameters then
>> are on SDRAM labels :( ).
>
> Linux doesn't give a hoot.  Setting up the memory is the BIOS' job.
>
> I'm sure the authors of the tools can use a hand in updating them if
> they are out of date.
>
> 	-hpa
>

To authors of /proc/cpuinfo:

Plz, fix stepping identification:

cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) XEON(TM) CPU 2.00GHz
stepping        : 4
cpu MHz         : 2000.062
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
bogomips        : 4006.39

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) XEON(TM) CPU 2.00GHz
stepping        : 4
cpu MHz         : 2000.062
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
bogomips        : 3999.80

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) XEON(TM) CPU 2.00GHz
stepping        : 4
cpu MHz         : 2000.062
cache size      : 512 KB
physical id     : 3
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
bogomips        : 3999.98

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) XEON(TM) CPU 2.00GHz
stepping        : 4
cpu MHz         : 2000.062
cache size      : 512 KB
physical id     : 3
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
bogomips        : 4000.08

---------------------------------------------------------------------------
uname -a
Linux rau 2.6.15-gentoo-r1 #5 SMP PREEMPT Sat Jan 20 10:13:08 AMT 2007 
i686 Intel(R) XEON(TM) CPU 2.00GHz GenuineIntel GNU/Linux

---------------------------------------------------------------------------

There is NO "stepping 4" for XEON, as Intel site states!

Thank you in advance.
