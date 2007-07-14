Return-Path: <linux-kernel-owner+w=401wt.eu-S1765635AbXGNWaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765635AbXGNWaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 18:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbXGNWaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 18:30:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:51832 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762102AbXGNWaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 18:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:organization:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=BCiqbgdMBBC+oOFDlCFpIwxlafvEEm53lBXz3i5oMWjtYLeZf3t2uPEp2VX7e26lbSD+dblZf8Fu4DYp1BywPEp2Lt13QWgUg8i5FwDxtGU+2gkug12wpjpmWIZ0MKIgcoex5R7JiXfSiKlMC8kqZ6HZNQ7p8APLpbDqgjOw2EQ=
Message-ID: <46994E5E.2000207@gmail.com>
Date: Sun, 15 Jul 2007 00:29:50 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.4 (X11/20070619)
MIME-Version: 1.0
To: "Kernel, " <linux-kernel@vger.kernel.org>
Subject: ACPI cpufreq broken on 2.6.22 for core2 duo
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With linux 2.6.21 and 22 i cannot get cpufreq working anymore while it
worked in previous versions

ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is
not present [20070126]
ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is
not present [20070126]

i'm in 64bit profile.
Bios updated to latest version.

CC me as i'm not subscribed.


cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping        : 6
cpu MHz         : 1866.667
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
nx lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 3735.47
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping        : 6
cpu MHz         : 1866.667
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
nx lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 3733.31
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


