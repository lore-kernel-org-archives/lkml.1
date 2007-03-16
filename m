Return-Path: <linux-kernel-owner+w=401wt.eu-S965838AbXCPSvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965838AbXCPSvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965831AbXCPSvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:51:38 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:26140 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965838AbXCPSvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:51:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=I85QgUVoRQnawMM+D3LV3AVrtFWNLbsH0zvVceDWkZyN2EbmM89M5WulZ7TqH6vstSjKbb78iGBAyBwvelLIbXEvhtARK4ybkNIO2lEQ1+YBPiQJAODr1zs4oa83sqQ5Pk3rwLamJ7KMU0el8vMpwUQho3i6LDrCdaIYZfoFmsQ=
Message-ID: <c43b2e150703161151i3bf45074v54208542ca2212d3@mail.gmail.com>
Date: Fri, 16 Mar 2007 19:51:36 +0100
From: wixor <wixorpeek@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: System hang on athlon64 cpufreq change
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
I'm not sure if this problem belongs here, I have no other idea where
to post however.

My kernel boots up with performance cpufreq governor, thus setting
frequency to 2hgz. Then I change it to powersave governor, thus
setting frequency to 1ghz just like that:

echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

Everything works well. Then I launch mplayer and in 1/4 - 1/5 cases
system hangs (I mean nothing works, including numlock and sysrq key).
I suspect it's something with video card driver, and here comes my
problem. I use ati's proprietary fglrx driver (i guess they may be
calibrating they own delay loop, or something, and cputfreq change
ruins it), so kernel is tainted, so you are unable to track the
problem down.... eh.... well, but i hope there is some tiny chance
there is something wrong i do, or maybe cpu doesn't like so drastic
freq changes... well, if anybody has some idea, or just experience
like mine, I ask for help. Thanks in advance.

root: ~: cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 47
model name      : AMD Athlon(tm) 64 Processor 3200+
stepping        : 2
cpu MHz         : 1000.000
cache size      : 512 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext
fxsr_opt lm 3dnowext 3dnow pni lahf_lm
bogomips        : 2010.88
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc
