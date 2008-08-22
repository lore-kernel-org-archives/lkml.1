Return-Path: <linux-kernel-owner+w=401wt.eu-S1760397AbYHVCP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760397AbYHVCP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYHVCPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:15:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbYHVCPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:15:16 -0400
Date: Thu, 21 Aug 2008 16:15:12 -1000
From: Joshua Hoblitt <josh@hoblitt.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080822021512.GJ23377@hoblitt.com>
References: <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com> <20080821205558.GC23377@hoblitt.com> <86802c440808211451u4483f88ft845cd20c3f23c53a@mail.gmail.com> <20080821233317.GE23377@hoblitt.com> <20080822001047.GF23377@hoblitt.com> <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com> <20080822002952.GG23377@hoblitt.com> <20080822010014.GH23377@hoblitt.com> <20080822011055.GI23377@hoblitt.com> <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 06:55:58PM -0700, Yinghai Lu wrote:
> can you send out /proc/cpuinfo

See below.  I should also add that this kernel correctly sets up the mtrrs
on an amd system.

--
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz
stepping        : 6
cpu MHz         : 2400.000
cache size      : 6144 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
bogomips        : 6386.99
clflush size    : 64
cache_alignment : 64
address sizes   : 38 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz
stepping        : 6
cpu MHz         : 2400.000
cache size      : 6144 KB
physical id     : 1
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 4
initial apicid  : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
bogomips        : 6386.12
clflush size    : 64
cache_alignment : 64
address sizes   : 38 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz
stepping        : 6
cpu MHz         : 2400.000
cache size      : 6144 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 4
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
bogomips        : 6386.09
clflush size    : 64
cache_alignment : 64
address sizes   : 38 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz
stepping        : 6
cpu MHz         : 2400.000
cache size      : 6144 KB
physical id     : 1
siblings        : 4
core id         : 1
cpu cores       : 4
apicid          : 5
initial apicid  : 5
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
bogomips        : 6386.09
clflush size    : 64
cache_alignment : 64
address sizes   : 38 bits physical, 48 bits virtual
power management:

processor       : 4
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz
stepping        : 6
cpu MHz         : 2400.000
cache size      : 6144 KB
physical id     : 0
siblings        : 4
core id         : 2
cpu cores       : 4
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
bogomips        : 6386.09
clflush size    : 64
cache_alignment : 64
address sizes   : 38 bits physical, 48 bits virtual
power management:

processor       : 5
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz
stepping        : 6
cpu MHz         : 2400.000
cache size      : 6144 KB
physical id     : 1
siblings        : 4
core id         : 2
cpu cores       : 4
apicid          : 6
initial apicid  : 6
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
bogomips        : 6386.10
clflush size    : 64
cache_alignment : 64
address sizes   : 38 bits physical, 48 bits virtual
power management:

processor       : 6
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz
stepping        : 6
cpu MHz         : 2400.000
cache size      : 6144 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
bogomips        : 6386.07
clflush size    : 64
cache_alignment : 64
address sizes   : 38 bits physical, 48 bits virtual
power management:

processor       : 7
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz
stepping        : 6
cpu MHz         : 2400.000
cache size      : 6144 KB
physical id     : 1
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 7
initial apicid  : 7
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
bogomips        : 6434.88
clflush size    : 64
cache_alignment : 64
address sizes   : 38 bits physical, 48 bits virtual
power management:
