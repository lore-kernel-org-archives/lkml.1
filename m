Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYB0MBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYB0MBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 07:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYB0MBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 07:01:40 -0500
Received: from atlas.xpertsoft.com ([67.15.226.2]:46615 "EHLO atlas.dri.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbYB0MBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 07:01:39 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2008 07:01:38 EST
Subject: Dell OptiPlex 320 - Core 2 Duo
From: Nuno Tavares <nuno.tavares@dri.pt>
To: linux-kernel@vger.kernel.org
In-Reply-To: <200802260005.02613.rjw@sisk.pl>
References: <20080225093914.GB4375@ics.muni.cz>
	 <20080225220720.GA4523@ics.muni.cz>
	 <20080225230035.GA14503@khazad-dum.debian.net>
	 <200802260005.02613.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Date: Wed, 27 Feb 2008 11:54:25 +0000
Message-Id: <1204113265.6167.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings to all,

I recently stumbled across a Dell OptiPlex 320 which brings a nasty
assembly of hardware. Besides the many issues reported (system/bios time
de-sync, SATA controller detection, etc), this particular model doesn't
seem to correctly recognize the CPU, which I'm not even sure what it is
(I haven't seen anyone else complaining about it). As far as I could
investigate, it looks like a weird P4 1.8Ghz, dual core.
However, /proc/cpuinfo only reports 1 processor, 1.8Ghz. I'm saying that
it's a dual core because I've seen an identical machine running Windows,
showing 2 CPUs. Besides, other tools report it as "dual core".

Below is the output of /proc/cpuinfo and some head lines of dmesg. Here
is the output of Todd Allen's cpuid tool (20060917):
   (multi-processing synth): hyper-threaded (t=2)
   (synth) = Intel Core 2 Duo (Conroe/Allendale) / Core 2 Extreme
Processor (Conroe) / Dual-Core Xeon Processor 5100 (Woodcrest), 65nm

I've tried OpenSuSE 10.3 default kernel, 2.6.22.5, the oSuSE last
update, 2.6.22.17, and a custom-built 2.6.24.2, all 32bit. I just notice
now that I could have tried downgrading...

What I'm looking for is some guidance in how can I trace this for you
and perhaps help you/me somehow. I've digged this mailing-list and lots
of other sources, and no one seems to complain about this, which is
odd...





------------------- /proc/cpuinfo --------------------
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 15
model name : Genuine Intel(R) CPU            2160  @ 1.80GHz
stepping : 2
cpu MHz : 1800.256
cache size : 1024 KB
physical id : 0
siblings : 1
core id : 0
cpu cores : 1
fdiv_bug : no
hlt_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 10
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc up pni monitor ds_cpl est tm2 ssse3 cx16 xtpr lahf_lm
bogomips : 3614.79
clflush size : 64



------------------- dmesg --------------------
Linux version 2.6.22.5-23-default (geeko@buildhost) (gcc version 4.2.1
(SUSE Linux)) #1 SMP 2007/09/18 05:23:45 UTC
BIOS-provided physical RAM map:
BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
BIOS-e820: 0000000000100000 - 000000007de5c800 (usable)
BIOS-e820: 000000007de5c800 - 000000007de5e800 (ACPI NVS)
BIOS-e820: 000000007de5e800 - 000000007de60800 (ACPI data)
BIOS-e820: 000000007de60800 - 000000007e000000 (reserved)
BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
1118MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 515676) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   515676
early_node_map[1] active PFN ranges
    0:        0 ->   515676
On node 0 totalpages: 515676
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2236 pages used for memmap
  HighMem zone: 284064 pages, LIFO batch:31
DMI 2.3 present.
Using APIC driver default
ATI board detected. Disabling timer routing over 8254.
Allocating PCI resources starting at 80000000 (gap: 7e000000:62000000)
Built 1 zonelists.  Total pages: 511648
Kernel command line:
root=/dev/disk/by-id/scsi-SATA_WDC_WD800JD-75M_WD-WMAM9TA95509-part2
apm=off acpi=off mce=off barrier=off ide=nodma idewait=50 i8042.nomux
psmouse.proto=bare irqpoll pci=nommconf   resume=/dev/sda1 splash=silent
Misrouted IRQ fixup and polling support enabled
This may significantly impact system performance
bootsplash: silent mode.
Found and enabled local APIC!
mapped APIC to ffffd000 (fee00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1800.245 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2037048k/2062704k available (1820k kernel code, 24356k reserved,
761k data, 228k init, 1145200k highmem)
virtual kernel memory layout:
    fixmap  : 0xffdf4000 - 0xfffff000   (2092 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc038c000 - 0xc03c5000   ( 228 kB)
      .data : 0xc02c725d - 0xc0385964   ( 761 kB)
      .text : 0xc0100000 - 0xc02c725d   (1820 kB)
Checking if this processor honours the WP bit even in supervisor mode...
Ok.
Calibrating delay using timer specific routine.. 3614.77 BogoMIPS
(lpj=7229554)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000
0000e39d 00000000 00000001
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e39d
00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 12k freed
Unpacking initramfs... done
Freeing initrd memory: 3950k freed
CPU0: Intel Genuine Intel(R) CPU            2160  @ 1.80GHz stepping 02
SMP motherboard not detected.
Brought up 1 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
[...]


-- 
Nuno Tavares
DRI, Consultoria Informática
Telef: +351 936 184 086


