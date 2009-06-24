Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZFXWEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZFXWEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZFXWEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:04:45 -0400
Received: from fmailhost01.isp.att.net ([204.127.217.101]:42206 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZFXWEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:04:42 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A42A2FD.1060401@lwfinger.net>
Date: Wed, 24 Jun 2009 17:04:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
References: <1245845787.3093.3.camel@localhost.localdomain>	 <1245861219.3216.15.camel@localhost.localdomain>	 <20090624094411.08fc66e6@jbarnes-g45>	 <20090624175513.GE7239@us.ibm.com>	 <20090624112849.55b38fff@jbarnes-g45>	 <alpine.LFD.2.00.0906242043230.2767@localhost.localdomain>	 <20090624194839.GG7239@us.ibm.com> <4A4286F8.9020501@lwfinger.net>	 <86802c440906241432l6d601f76sf2a413d6e19079e6@mail.gmail.com>	 <4A429DAA.3010303@lwfinger.net> <86802c440906241444g1aabcc5rb2d189dca0965e36@mail.gmail.com>
In-Reply-To: <86802c440906241444g1aabcc5rb2d189dca0965e36@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Jun 24, 2009 at 2:42 PM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
>> Yinghai Lu wrote:
>>> please fix the whole boot log with debug.
>>>
>>> need to make sure how many HT chain in your system.
>> Do you mean the output of dmesg? I'm not sure what you mean by "debug".
>>
> put debug in your boot line of grub.conf

I hope this is what you wanted.
===============================

Linux version 2.6.30-Linus-08503-g4e8a237-dirty (finger@larrylap) (gcc
version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #155 SMP
Wed Jun 24 16:50:16 CDT 2009
Command line:
root=/dev/disk/by-id/scsi-SATA_TOSHIBA_MK2546G_18C2P0KCT-part8
resume=/dev/disk/by-id/ata-TOSHIBA_MK2546GSX_18C2P0KCT-part5
splash=silent vga=0x317 debug
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e000 (usable)
 BIOS-e820: 000000000009e000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bbf50000 (usable)
 BIOS-e820: 00000000bbf50000 - 00000000bbf65000 (ACPI data)
 BIOS-e820: 00000000bbf65000 - 00000000bbf66000 (ACPI NVS)
 BIOS-e820: 00000000bbf66000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
DMI present.
last_pfn = 0xbbf50 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-D3FFF write-protect
  D4000-DBFFF uncachable
  DC000-DFFFF write-protect
  E0000-E3FFF uncachable
  E4000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 base 0080000000 mask FFC0000000 write-back
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 0000000000001000 - 0000000000006000 (usable) ==>
(reserved)
Scanning 1 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000001000 (usable)
 modified: 0000000000001000 - 0000000000006000 (reserved)
 modified: 0000000000006000 - 000000000009e000 (usable)
 modified: 000000000009e000 - 00000000000a0000 (reserved)
 modified: 00000000000d2000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 00000000bbf50000 (usable)
 modified: 00000000bbf50000 - 00000000bbf65000 (ACPI data)
 modified: 00000000bbf65000 - 00000000bbf66000 (ACPI NVS)
 modified: 00000000bbf66000 - 00000000c0000000 (reserved)
 modified: 00000000e0000000 - 00000000f0000000 (reserved)
 modified: 00000000fec00000 - 00000000fec10000 (reserved)
 modified: 00000000fee00000 - 00000000fee01000 (reserved)
 modified: 00000000fff80000 - 0000000100000000 (reserved)
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000bbf50000
 0000000000 - 00bbe00000 page 2M
 00bbe00000 - 00bbf50000 page 4k
kernel direct mapping tables up to bbf50000 @ 8000-d000
RAMDISK: 37539000 - 37fef403
ACPI: RSDP 00000000000f80c0 00024 (v03 HPQOEM)
ACPI: XSDT 00000000bbf5d343 0006C (v01 HPQOEM SLIC-MPC 06040000  LTP
00000000)
ACPI: FACP 00000000bbf64874 000F4 (v03 HPQOEM SLIC-MPC 06040000 PTL_
000F4240)
ACPI: DSDT 00000000bbf5d3af 074C5 (v01 HPQOEM SLIC-MPC 06040000 MSFT
03000000)
ACPI: FACS 00000000bbf65fc0 00040
ACPI: SLIC 00000000bbf649dc 00176 (v01 HPQOEM SLIC-MPC 06040000 HPQ
00000001)
ACPI: WDAT 00000000bbf64b52 00104 (v01 PTLTD  WDATTBL  06040000  LTP
00000001)
ACPI: SRAT 00000000bbf64c56 000A0 (v01 AMD    HAMMER   06040000 AMD
00000001)
ACPI: MCFG 00000000bbf64cf6 0003C (v01 HPQOEM SLIC-MPC 06040000  LTP
00000000)
ACPI: HPET 00000000bbf64d32 00038 (v01 HPQOEM SLIC-MPC 06040000  LTP
00000001)
ACPI: APIC 00000000bbf64d6a 00068 (v01 HPQOEM SLIC-MPC 06040000  LTP
00000000)
ACPI: BOOT 00000000bbf64dd2 00028 (v01 HPQOEM SLIC-MPC 06040000  LTP
00000001)
ACPI: SSDT 00000000bbf64dfa 00206 (v01 HPQOEM SLIC-MPC 06040000  LTP
00000001)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-c0000000
NUMA: Allocated memnodemap from b000 - c840
NUMA: Using 20 for the hash shift.
Bootmem setup node 0 0000000000000000-00000000bbf50000
  NODE_DATA [000000000000c840 - 000000000001183f]
  bootmap [0000000000012000 -  00000000000297ef] pages 18
(8 early reservations) ==> bootmem [0000000000 - 00bbf50000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 -
0000008000]
  #2 [0001000000 - 000209ed60]    TEXT DATA BSS ==> [0001000000 -
000209ed60]
  #3 [0037539000 - 0037fef403]          RAMDISK ==> [0037539000 -
0037fef403]
  #4 [000009e000 - 0000100000]    BIOS reserved ==> [000009e000 -
0000100000]
  #5 [000209f000 - 000209f188]              BRK ==> [000209f000 -
000209f188]
  #6 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 -
000000b000]
  #7 [000000b000 - 000000c840]       MEMNODEMAP ==> [000000b000 -
000000c840]
found SMP MP-table at [ffff8800000f8090] f8090
 [ffffea0000000000-ffffea00041fffff] PMD ->
[ffff880002600000-ffff8800067fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x00000001
    0: 0x00000006 -> 0x0000009e
    0: 0x00000100 -> 0x000bbf50
On node 0 totalpages: 769769
  DMA zone: 88 pages used for memmap
  DMA zone: 105 pages reserved
  DMA zone: 3800 pages, LIFO batch:0
  DMA32 zone: 16453 pages used for memmap
  DMA32 zone: 749323 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10de8201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 24 pages at ffff8800020e4000, static data 69344 bytes
Built 1 zonelists in Node order, mobility grouping on.  Total pages:
753123
Policy zone: DMA32
Kernel command line:
root=/dev/disk/by-id/scsi-SATA_TOSHIBA_MK2546G_18C2P0KCT-part8
resume=/dev/disk/by-id/ata-TOSHIBA_MK2546GSX_18C2P0KCT-part5
splash=silent vga=0x317 debug
PID hash table entries: 4096 (order: 12, 32768 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Node 0: aperture @ 7000000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Memory: 2982916k/3079488k available (2417k kernel code, 412k absent,
96160k reserved, 1789k data, 540k init)
NR_IRQS:4352
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 2000.016 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour dummy device 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 5695 kB
 per task-struct memory footprint: 1920 bytes
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4000.03 BogoMIPS (lpj=8000064)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0x0 -> Node 0
tseg: 00bbf80000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
using C1E aware idle routine
ACPI: Core revision 20090521
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Turion(tm) 64 X2 TL-60 stepping 02
lockdep: fixing up alternatives.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4000.38 BogoMIPS
(lpj=8000763)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 5 MCE banks
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: AMD Turion(tm) 64 X2 TL-60 stepping 02
Brought up 2 CPUs
Total of 2 processors activated (8000.41 BogoMIPS).
System has AMD C1E enabled
Switch to broadcast mode on CPU1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
Switch to broadcast mode on CPU0
NET: Registered protocol family 16
node 0 link 0: io port [1000, fffff]
TOM: 00000000c0000000 aka 3072M
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [c0000000, dfffffff]
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [f0000000, fe0bffff]
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [a0000, bffff]
bus: 00 index 2 mmio: [c0000000, fcffffffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 9
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - e09fffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Enabling special treatment for EC from MSI.
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x2a, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.1: reg 10 io port: [0x3080-0x30bf]
pci 0000:00:01.1: reg 20 io port: [0x3040-0x307f]
pci 0000:00:01.1: reg 24 io port: [0x3000-0x303f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:01.3: reg 10 32bit mmio: [0xfc200000-0xfc27ffff]
pci 0000:00:02.0: reg 10 32bit mmio: [0xfc486000-0xfc486fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10 32bit mmio: [0xfc489000-0xfc4890ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:04.0: reg 10 32bit mmio: [0xfc487000-0xfc487fff]
pci 0000:00:04.0: supports D1 D2
pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:04.1: reg 10 32bit mmio: [0xfc489400-0xfc4894ff]
pci 0000:00:04.1: supports D1 D2
pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:04.1: PME# disabled
pci 0000:00:06.0: reg 20 io port: [0x30c0-0x30cf]
pci 0000:00:07.0: reg 10 32bit mmio: [0xfc480000-0xfc483fff]
pci 0000:00:07.0: PME# supported from D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:09.0: reg 10 io port: [0x30f0-0x30f7]
pci 0000:00:09.0: reg 14 io port: [0x30e4-0x30e7]
pci 0000:00:09.0: reg 18 io port: [0x30e8-0x30ef]
pci 0000:00:09.0: reg 1c io port: [0x30e0-0x30e3]
pci 0000:00:09.0: reg 20 io port: [0x30d0-0x30df]
pci 0000:00:09.0: reg 24 32bit mmio: [0xfc484000-0xfc485fff]
pci 0000:00:0a.0: reg 10 32bit mmio: [0xfc488000-0xfc488fff]
pci 0000:00:0a.0: reg 14 io port: [0x30f8-0x30ff]
pci 0000:00:0a.0: reg 18 32bit mmio: [0xfc489c00-0xfc489cff]
pci 0000:00:0a.0: reg 1c 32bit mmio: [0xfc489800-0xfc48980f]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:12.0: reg 10 32bit mmio: [0xf4000000-0xf4ffffff]
pci 0000:00:12.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
pci 0000:00:12.0: reg 1c 64bit mmio: [0xf0000000-0xf0ffffff]
pci 0000:00:12.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:09.0: reg 10 32bit mmio: [0x000000-0x0007ff]
pci 0000:01:09.0: supports D1 D2
pci 0000:01:09.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:09.0: PME# disabled
pci 0000:01:09.1: reg 10 32bit mmio: [0xfc100800-0xfc1008ff]
pci 0000:01:09.1: supports D1 D2
pci 0000:01:09.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:09.1: PME# disabled
pci 0000:01:09.2: reg 10 32bit mmio: [0xfc100c00-0xfc100cff]
pci 0000:01:09.2: supports D1 D2
pci 0000:01:09.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:09.2: PME# disabled
pci 0000:01:09.3: reg 10 32bit mmio: [0xfc101000-0xfc1010ff]
pci 0000:01:09.3: supports D1 D2
pci 0000:01:09.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:09.3: PME# disabled
pci 0000:01:09.4: reg 10 32bit mmio: [0xfc101400-0xfc1014ff]
pci 0000:01:09.4: supports D1 D2
pci 0000:01:09.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:09.4: PME# disabled
pci 0000:00:08.0: transparent bridge
pci 0000:00:08.0: bridge 32bit mmio: [0xfc100000-0xfc1fffff]
pci 0000:00:0c.0: bridge io port: [0x4000-0x4fff]
pci 0000:00:0c.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
pci 0000:04:00.0: reg 10 32bit mmio: [0xfc000000-0xfc003fff]
pci 0000:04:00.0: supports D1 D2
pci 0000:00:0d.0: bridge 32bit mmio: [0xfc000000-0xfc0fffff]
PCI: Failed to allocate 0xd0000-0xd3fff from PCI mem for PCI Bus 0000:00
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LK1E] (IRQs 19 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LK2E] (IRQs 19 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LK3E] (IRQs 19 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LK4E] (IRQs 19 20 21 22 23) *10
ACPI: PCI Interrupt Link [LSMB] (IRQs 18) *10
ACPI: PCI Interrupt Link [LUS0] (IRQs 17) *11
ACPI: PCI Interrupt Link [LUS2] (IRQs 17) *7
ACPI: PCI Interrupt Link [LMAC] (IRQs 19 20 21 22 23) *11
ACPI: PCI Interrupt Link [LAZA] (IRQs 19 20 21 22 23) *10
ACPI: PCI Interrupt Link [LGPU] (IRQs 19 20 21 22 23) *10
ACPI: PCI Interrupt Link [LPID] (IRQs 19 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LSI0] (IRQs 19 20 21 22 23) *5
ACPI: PCI Interrupt Link [Z012] (IRQs 16) *10
ACPI: PCI Interrupt Link [Z013] (IRQs 16) *11
ACPI: PCI Interrupt Link [LPMU] (IRQs 18) *11
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 comparators, 32-bit 25.000000 MHz counter
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:00: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:00: iomem range 0xfec80000-0xfec80fff has been reserved
system 00:00: iomem range 0xfef00000-0xfef00fff has been reserved
system 00:03: iomem range 0xe0000000-0xefffffff has been reserved
system 00:04: ioport range 0x360-0x361 has been reserved
system 00:04: ioport range 0x4d0-0x4d1 has been reserved
system 00:0b: ioport range 0x1000-0x107f has been reserved
system 00:0b: ioport range 0x1080-0x10ff has been reserved
system 00:0b: ioport range 0x1400-0x147f has been reserved
system 00:0b: ioport range 0x1480-0x14ff has been reserved
system 00:0b: ioport range 0x1800-0x187f has been reserved
system 00:0b: ioport range 0x1880-0x18ff has been reserved
pci 0000:00:08.0: PCI bridge, secondary bus 0000:01
pci 0000:00:08.0:   IO window: disabled
pci 0000:00:08.0:   MEM window: 0xfc100000-0xfc1fffff
pci 0000:00:08.0:   PREFETCH window: disabled
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:06
pci 0000:00:0c.0:   IO window: 0x4000-0x4fff
pci 0000:00:0c.0:   MEM window: 0xf8000000-0xfbffffff
pci 0000:00:0c.0:   PREFETCH window: disabled
pci 0000:00:0d.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0d.0:   IO window: disabled
pci 0000:00:0d.0:   MEM window: 0xfc000000-0xfc0fffff
pci 0000:00:0d.0:   PREFETCH window: disabled
pci 0000:00:08.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xcf7]
pci_bus 0000:00: resource 1 io:  [0xd00-0xffff]
pci_bus 0000:00: resource 2 mem: [0x0a0000-0x0bffff]
pci_bus 0000:00: resource 3 mem: [0x0c0000-0x0c3fff]
pci_bus 0000:00: resource 4 mem: [0x0c4000-0x0c7fff]
pci_bus 0000:00: resource 5 mem: [0x0c8000-0x0cbfff]
pci_bus 0000:00: resource 6 mem: [0x0cc000-0x0cffff]
pci_bus 0000:00: resource 7 mem: [0x0d4000-0x0d7fff]
pci_bus 0000:00: resource 8 mem: [0x0d8000-0x0dbfff]
pci_bus 0000:00: resource 9 mem: [0x0dc000-0x0dffff]
pci_bus 0000:00: resource 10 mem: [0x0e0000-0x0e3fff]
pci_bus 0000:00: resource 11 mem: [0x0e4000-0x0e7fff]
pci_bus 0000:00: resource 12 mem: [0x0e8000-0x0ebfff]
pci_bus 0000:00: resource 13 mem: [0x0ec000-0x0effff]
pci_bus 0000:00: resource 14 mem: [0x0f0000-0x0fffff]
pci_bus 0000:00: resource 15 mem: [0xc0000000-0xfebfffff]
pci_bus 0000:01: resource 1 mem: [0xfc100000-0xfc1fffff]
pci_bus 0000:01: resource 3 io:  [0x00-0xcf7]
pci_bus 0000:01: resource 4 io:  [0xd00-0xffff]
pci_bus 0000:01: resource 5 mem: [0x0a0000-0x0bffff]
pci_bus 0000:01: resource 6 mem: [0x0c0000-0x0c3fff]
pci_bus 0000:01: resource 7 mem: [0x0c4000-0x0c7fff]
pci_bus 0000:01: resource 8 mem: [0x0c8000-0x0cbfff]
pci_bus 0000:01: resource 9 mem: [0x0cc000-0x0cffff]
pci_bus 0000:01: resource 10 mem: [0x0d4000-0x0d7fff]
pci_bus 0000:01: resource 11 mem: [0x0d8000-0x0dbfff]
pci_bus 0000:01: resource 12 mem: [0x0dc000-0x0dffff]
pci_bus 0000:01: resource 13 mem: [0x0e0000-0x0e3fff]
pci_bus 0000:01: resource 14 mem: [0x0e4000-0x0e7fff]
pci_bus 0000:01: resource 15 mem: [0x0e8000-0x0ebfff]
pci_bus 0000:01: resource 16 mem: [0x0ec000-0x0effff]
pci_bus 0000:01: resource 17 mem: [0x0f0000-0x0fffff]
pci_bus 0000:01: resource 18 mem: [0xc0000000-0xfebfffff]
pci_bus 0000:06: resource 0 io:  [0x4000-0x4fff]
pci_bus 0000:06: resource 1 mem: [0xf8000000-0xfbffffff]
pci_bus 0000:04: resource 1 mem: [0xfc000000-0xfc0fffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs...
Freeing initrd memory: 10969k freed
Simple Boot Flag at 0x36 set to 0x1
Scanning for low memory corruption every 60 seconds
audit: initializing netlink socket (disabled)
type=2000 audit(1245862627.848:1): initialized
msgmni has been set to 5847
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:12.0: Boot video device
pcieport-driver 0000:00:0c.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:0c.0: setting latency timer to 64
pcieport-driver 0000:00:0d.0: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:0d.0: setting latency timer to 64
vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90001d80000, using
3072k, total 65536k
vesafb: mode is 1024x768x16, linelength=2048, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Platform driver 'serial8250' needs updating - please use dev_pm_ops
PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Platform driver 'i8042' needs updating - please use dev_pm_ops
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
Platform driver 'pcspkr' needs updating - please use dev_pm_ops
input: PC Speaker as /class/input/input0
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos: dev (254:0)
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
registered taskstats version 1
rtc_cmos 00:07: setting system clock to 2009-06-24 16:57:08 UTC
(1245862628)
Freeing unused kernel memory: 540k freed
ACPI: processor limited to max C-state 1
processor ACPI_CPU:00: registered as cooling_device0
processor ACPI_CPU:01: registered as cooling_device1
input: AT Translated Set 2 keyboard as /class/input/input1
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZS0] (75 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [TZS1] (76 C)
SCSI subsystem initialized
libata version 3.00 loaded.
ahci 0000:00:09.0: version 3.0
ACPI: PCI Interrupt Link [LSI0] enabled at IRQ 23
ahci 0000:00:09.0: PCI INT A -> Link[LSI0] -> GSI 23 (level, low) ->
IRQ 23
ahci 0000:00:09.0: irq 26 for MSI/MSI-X
ahci 0000:00:09.0: controller can do NCQ, turning on CAP_NCQ
ahci 0000:00:09.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl IDE
mode
ahci 0000:00:09.0: flags: 64bit ncq sntf led clo pmp pio
ahci 0000:00:09.0: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m8192@0xfc484000 port 0xfc484100 irq 26
ata2: SATA max UDMA/133 abar m8192@0xfc484000 port 0xfc484180 irq 26
ata3: SATA max UDMA/133 abar m8192@0xfc484000 port 0xfc484200 irq 26
ata4: SATA max UDMA/133 abar m8192@0xfc484000 port 0xfc484280 irq 26
input: PS/2 Mouse as /class/input/input2
input: AlpsPS/2 ALPS GlidePoint as /class/input/input3
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: TOSHIBA MK2546GSX, LB014C, max UDMA/100
ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK2546GS LB01 PQ: 0
ANSI: 5
Uniform Multi-Platform E-IDE driver
amd74xx 0000:00:06.0: UDMA133 controller
amd74xx 0000:00:06.0: IDE controller (0x10de:0x0560 rev 0xa1)
amd74xx 0000:00:06.0: IDE port disabled
amd74xx 0000:00:06.0: BIOS didn't set cable bits correctly. Enabling
workaround.
amd74xx 0000:00:06.0: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x30c0-0x30c7
Probing IDE interface ide0...
hda: Optiarc DVD RW AD-7561A, ATAPI CD/DVD-ROM drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 17
ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUS2] -> GSI 17 (level, low)
-> IRQ 17
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
ehci_hcd 0000:00:02.1: irq 17, io mem 0xfc489000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ACPI: PCI Interrupt Link [Z013] enabled at IRQ 16
ehci_hcd 0000:00:04.1: PCI INT B -> Link[Z013] -> GSI 16 (level, low)
-> IRQ 16
ehci_hcd 0000:00:04.1: setting latency timer to 64
ehci_hcd 0000:00:04.1: EHCI Host Controller
ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:04.1: debug port 1
ehci_hcd 0000:00:04.1: cache line size of 64 is not supported
ehci_hcd 0000:00:04.1: irq 16, io mem 0xfc489400
ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 5 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 17
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUS0] -> GSI 17 (level, low)
-> IRQ 17
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.0: irq 17, io mem 0xfc486000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 5 ports detected
ACPI: PCI Interrupt Link [Z012] enabled at IRQ 16
ohci_hcd 0000:00:04.0: PCI INT A -> Link[Z012] -> GSI 16 (level, low)
-> IRQ 16
ohci_hcd 0000:00:04.0: setting latency timer to 64
ohci_hcd 0000:00:04.0: OHCI Host Controller
ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:04.0: irq 16, io mem 0xfc487000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 5 ports detected
udevd version 128 started
usb 1-4: new high speed USB device using ehci_hcd and address 2
usb 1-4: configuration #1 chosen from 1 choice
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 > sda4
sd 0:0:0:0: [sda] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
udevd version 128 started
input: Power Button as /class/input/input4
ACPI: Power Button [PWRF]
input: Lid Switch as /class/input/input5
ACPI: Lid Switch [LID0]
input: Sleep Button as /class/input/input6
ACPI: Sleep Button [SLPB]
input: Power Button as /class/input/input7
ACPI: Power Button [PWRB]
sd 0:0:0:0: Attached scsi generic sg0 type 0
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 22
forcedeth 0000:00:0a.0: PCI INT A -> Link[LMAC] -> GSI 22 (level, low)
-> IRQ 22
forcedeth 0000:00:0a.0: setting latency timer to 64
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr
00:1d:72:4c:a5:52
forcedeth 0000:00:0a.0: highdma pwrctl mgmt lnktim msi desc-v3
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x3040
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x3000
ACPI: PCI Interrupt Link [LK4E] enabled at IRQ 21
b43-pci-bridge 0000:04:00.0: PCI INT A -> Link[LK4E] -> GSI 21 (level,
low) -> IRQ 21
b43-pci-bridge 0000:04:00.0: setting latency timer to 64
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x11, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0A, vendor 0x4243)
ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x03, vendor 0x4243)
ssb: Core 3 found: PCI-E (cc 0x820, rev 0x01, vendor 0x4243)
ssb: SPROM revision 2 detected.
ssb: Sonics Silicon Backplane found on PCI device 0000:04:00.0
k8temp 0000:00:18.3: Temperature readouts might be wrong - check
erratum #141
ide-cd driver 5.00
ide-cd: hda: ATAPI 24X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ACPI: Battery Slot [BAT0] (battery present)
ACPI: AC Adapter [ADP1] (on-line)
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
        (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 20
HDA Intel 0000:00:07.0: PCI INT A -> Link[LAZA] -> GSI 20 (level, low)
-> IRQ 20
HDA Intel 0000:00:07.0: setting latency timer to 64
cfg80211: Regulatory domain changed to country: US
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
        (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 1700 mBm)
        (5250000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
        (5490000 KHz - 5710000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
        (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
b43-phy0: Broadcom 4311 WLAN found (core revision 10)
b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 8
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
phy0: Selected rate control algorithm 'minstrel'
Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
udev: renamed network interface wlan0 to eth1
Adding 2104444k swap on /dev/sda5.  Priority:-1 extents:1 across:2104444k
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:
dm-devel@redhat.com
loop: module loaded
EXT4-fs (sda1): barriers enabled
kjournald2 starting: pid 2150, dev sda1:8, commit interval 5 seconds
EXT4-fs (sda1): internal journal on sda1:8
EXT4-fs (sda1): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (sda1): mounted filesystem with ordered data mode
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
fuse init (API version 7.11)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
powernow-k8: Found 1 AMD Turion(tm) 64 X2 TL-60 processors (2 cpu
cores) (version 2.20.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x11
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x12
powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x13
powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x1e
Clocksource tsc unstable (delta = -68224792 ns)
vboxdrv: Trying to deactivate the NMI watchdog permanently...
vboxdrv: Successfully done.
vboxdrv: Found 2 processor cores.
VBoxDrv: dbg - g_abExecMemory=ffffffffa039a480
vboxdrv: fAsync=1 offMin=0x10ec88 offMax=0x10ec88
vboxdrv: TSC mode is 'asynchronous', kernel timer mode is 'normal'.
vboxdrv: Successfully loaded version 2.2.4 (interface 0x000a0009).
VBoxNetFlt: dbg - g_abExecMemory=ffffffffa05381c0
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
forcedeth 0000:00:0a.0: irq 27 for MSI/MSI-X
eth0: no link during initialization.
b43 ssb0:0: firmware: requesting b43/ucode5.fw
b43 ssb0:0: firmware: requesting b43/pcm5.fw
b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 32-bit DMA initialized
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
Registered led device: b43-phy0::radio
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2
b43-phy0: Radio turned on by software
NET: Registered protocol family 17
eth1: authenticate with AP 00:1a:70:46:ba:b1
eth1: authenticated
eth1: associate with AP 00:1a:70:46:ba:b1
eth1: RX AssocResp from 00:1a:70:46:ba:b1 (capab=0x431 status=0 aid=1)
eth1: associated
b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac:
00:1a:70:46:ba:b1
b43-phy0 debug: Using hardware based encryption for keyidx: 2, mac:
ff:ff:ff:ff:ff:ff
