Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbZBNVsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbZBNVsL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbZBNVrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:47:46 -0500
Received: from rosi.naasa.net ([212.8.0.13]:50781 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbZBNVro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:47:44 -0500
X-Greylist: delayed 1788 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Feb 2009 16:47:44 EST
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: linux-kernel@vger.kernel.org
Subject: cpuinfo shows wrong MHz value
Date: Sat, 14 Feb 2009 22:17:48 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902142217.51655.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running kernel 2.6.28.4 and /proc/cpuinfo and powertop and vmware are 
unable to detect the correct speed (1.6 GHz) of the processor:

cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 1
model name      : Intel(R) Pentium(R) 4 CPU 1.60GHz
stepping        : 2
cpu MHz         : 13000.000
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pebs bts
bogomips        : 3197.21
clflush size    : 64
power management:

According to dmesg the kernel detects the CPU correctly during bootup:

Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 1598.609 MHz processor.

IIRC this behavior started some kernels ago, I can't remember which kernel it 
was. Is it possible that the ACPI information is wrong?

regards,
Jörg
