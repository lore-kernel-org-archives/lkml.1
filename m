Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbZF0Jpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbZF0Jpd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 05:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbZF0JpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 05:45:25 -0400
Received: from aun.it.uu.se ([130.238.12.36]:63738 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZF0JpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 05:45:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19013.59956.144640.331854@pilspetsen.it.uu.se>
Date: Sat, 27 Jun 2009 11:45:24 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
In-Reply-To: <4A45A5C1.5080701@zytor.com>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>
	<19013.29264.623540.275538@pilspetsen.it.uu.se>
	<4A45A5C1.5080701@zytor.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:
 > Can you send me /proc/cpuinfo and /proc/iomem from this box?

This is from 2.6.31-rc1 with the commit commented out.

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
stepping	: 6
cpu MHz		: 1596.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips	: 4799.81
clflush size	: 64
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
stepping	: 6
cpu MHz		: 1596.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow
bogomips	: 4800.01
clflush size	: 64
power management:

00000000-0009ebff : System RAM
0009ec00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e4000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7ff8ffff : System RAM
  00100000-002e022e : Kernel code
  002e022f-0038baf7 : Kernel data
  003d8000-003fc9f3 : Kernel bss
7ff90000-7ff9dfff : ACPI Tables
7ff9e000-7ffdffff : ACPI Non-volatile Storage
7ffe0000-7fffffff : reserved
80000000-800000ff : 0000:00:1f.3
bff00000-dfefffff : PCI Bus 0000:01
  c0000000-cfffffff : 0000:01:00.0
e0000000-efffffff : PCI MMCONFIG 0 [00-ff]
  e0000000-efffffff : pnp 00:0e
febfe000-febfec00 : pnp 00:09
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : pnp 00:0b
fed00000-fed003ff : HPET 0
fed14000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:09
fed20000-fed8ffff : pnp 00:09
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:0b
ff800000-ff8fffff : PCI Bus 0000:01
  ff8c0000-ff8dffff : 0000:01:00.0
  ff8e0000-ff8effff : 0000:01:00.1
  ff8f0000-ff8fffff : 0000:01:00.0
ff900000-ff9fffff : PCI Bus 0000:02
  ff9ffc00-ff9ffcff : 0000:02:02.0
    ff9ffc00-ff9ffcff : 8139too
ffaf8000-ffafbfff : 0000:00:1b.0
  ffaf8000-ffafbfff : ICH HD audio
ffaff000-ffaff3ff : 0000:00:1d.7
  ffaff000-ffaff3ff : ehci_hcd
ffaff400-ffaff7ff : 0000:00:1a.7
  ffaff400-ffaff7ff : ehci_hcd
ffaff800-ffafffff : 0000:00:1f.2
  ffaff800-ffafffff : ahci
ffb00000-ffffffff : reserved
  ffb00000-ffbfffff : pnp 00:09
  fff00000-fffffffe : pnp 00:09
100000000-1ffffffff : System RAM
200000000-ffffffffffffffff : RAM buffer

With 2.6.30 things look similar, except 2.6.30 does not show the
last "200000000-ffffffffffffffff : RAM buffer" line.
