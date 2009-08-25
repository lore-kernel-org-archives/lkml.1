Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZHYBiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZHYBiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 21:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZHYBiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 21:38:06 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:59957 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbZHYBiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 21:38:03 -0400
Date: Mon, 24 Aug 2009 18:38:01 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, shai@scalex86.org
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825013801.GC6842@localdomain>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <4A932FD7.5030000@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <4A932FD7.5030000@kernel.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 24, 2009 at 05:27:03PM -0700, Yinghai Lu wrote:
>Yinghai Lu wrote:
>> Ravikiran G Thirumalai wrote:
>can you check if this one fix your problem?
>

Nope it doesn't :(


>BTW: what does your /proc/cpuinfo print about apic id and initial apic id?
>

Here's a sample cpuinfo from an older kernel (attached)


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=cpuinfo

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5871.22
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5852.70
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5852.83
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 6
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5852.59
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 4
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 1
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 16
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5853.76
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 5
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 1
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 18
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5853.72
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 6
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 1
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 20
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5856.30
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 7
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 1
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 22
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5856.34
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 8
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 2
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 32
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5865.94
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 9
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 2
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 34
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5866.71
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 10
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 2
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 36
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.00
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 11
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 2
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 38
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5866.25
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 12
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 3
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 48
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.65
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 13
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 3
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 50
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.00
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 14
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 3
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 52
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5869.20
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 15
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 3
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 54
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5868.63
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 16
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 4
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 64
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5866.64
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 17
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 4
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 66
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.55
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 18
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 4
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 68
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.31
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 19
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 4
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 70
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.64
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 20
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 5
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 80
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5868.43
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 21
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 5
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 82
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5869.26
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 22
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 5
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 84
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.89
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 23
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 5
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 86
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5870.31
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 24
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 6
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 96
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.04
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 25
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 6
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 98
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5866.62
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 26
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 6
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 100
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5865.17
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 27
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 6
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 102
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5864.31
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 28
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 7
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 112
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.86
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 29
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 7
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 114
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5868.98
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 30
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 7
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 116
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5869.39
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 31
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 7
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 118
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5866.46
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 32
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 8
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 128
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5868.26
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 33
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 8
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 130
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.83
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 34
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 8
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 132
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5866.41
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 35
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 8
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 134
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5866.10
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 36
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 9
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 144
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.94
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 37
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 9
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 146
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5868.10
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 38
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 9
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 148
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5868.16
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 39
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 9
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 150
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5870.76
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 40
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 10
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 160
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.80
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 41
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 10
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 162
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5868.70
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 42
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 10
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 164
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5868.25
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 43
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 10
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 166
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5866.27
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 44
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 11
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 176
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5869.09
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 45
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 11
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 178
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5869.89
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 46
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 11
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 180
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5871.30
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 47
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 11
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 182
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5869.35
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 48
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 12
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 192
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5868.68
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 49
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 12
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 194
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.43
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 50
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 12
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 196
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5865.60
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 51
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 12
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 198
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5866.01
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 52
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 13
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 208
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5868.82
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 53
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 13
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 210
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5869.69
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 54
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 13
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 212
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5867.73
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 55
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 13
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 214
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5866.55
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 56
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 14
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 224
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5868.81
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 57
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 14
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 226
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5869.90
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 58
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 14
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 228
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5870.19
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 59
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 14
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 230
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5870.07
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 60
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 15
siblings	: 4
core id		: 0
cpu cores	: 4
cpu cores	: 4
apicid		: 240
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5869.63
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 61
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 15
siblings	: 4
core id		: 1
cpu cores	: 4
cpu cores	: 4
apicid		: 242
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5870.38
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 62
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 15
siblings	: 4
core id		: 2
cpu cores	: 4
cpu cores	: 4
apicid		: 244
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5870.10
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 63
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 2926.327
cache size	: 8192 KB
physical id	: 15
siblings	: 4
core id		: 3
cpu cores	: 4
cpu cores	: 4
apicid		: 246
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx rdtscp lm constant_tsc pni ds_cpl vmx est tm2 ssse3 cx16 xtpr dca popcnt lahf_lm
bogomips	: 5870.64
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:


--J2SCkAp4GZ/dPZZf--
