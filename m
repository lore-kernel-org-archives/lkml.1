Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbXLVW1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbXLVW1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 17:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbXLVW1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 17:27:08 -0500
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4798 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbXLVW1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 17:27:07 -0500
Message-ID: <476D8F37.3080009@xs4all.nl>
Date: Sat, 22 Dec 2007 23:27:03 +0100
From: Bauke Jan Douma <bjdouma@xs4all.nl>
Reply-To: bjdouma@xs4all.nl
Organization: a training zoo
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote on 12-12-07 00:31:
> Good day.
> 
> Would some people on x86 (both 32 and 64) be kind enough to compile and 
> run the attached program? This is about testing how long I/O port access 
> to port 0x80 takes. It measures in CPU cycles so CPU speed is crucial in 
> reporting.

Compiled as you wished.
And here are the results from 10 iterations...:

cycles: out 1965, in 1263
cycles: out 1968, in 1251
cycles: out 1957, in 1257
cycles: out 1992, in 1253
cycles: out 1959, in 1248
cycles: out 1965, in 1264
cycles: out 1957, in 1256
cycles: out 1959, in 1248
cycles: out 1962, in 1298
cycles: out 1962, in 1275

Linux skyscraper 2.6.23.11 #1 SMP Sun Dec 16 11:54:12 CET 2007 i686 GNU/Linux

32bits system

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz
stepping        : 7
cpu MHz         : 2400.182
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr s
bogomips        : 4802.73
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz
stepping        : 7
cpu MHz         : 2400.182
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 4
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr s
bogomips        : 10614.49
clflush size    : 64

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz
stepping        : 7
cpu MHz         : 2400.182
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 2
cpu cores       : 4
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr s
bogomips        : 4800.17
clflush size    : 64

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz
stepping        : 7
cpu MHz         : 2400.182
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr s
bogomips        : 4800.17
clflush size    : 64

