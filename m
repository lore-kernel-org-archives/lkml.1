Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbZAHRlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbZAHRlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZAHRl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:41:28 -0500
Received: from alpha.facton.com ([83.236.152.122]:38359 "EHLO alpha.facton.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbZAHRl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:41:27 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Re: hwinfo problem since 2.6.28
Date: Thu, 8 Jan 2009 18:41:15 +0100
Message-ID: <3C59DB883F7B0B4D8096010D45ACCD13C73EC7@exch.facton.local>
In-Reply-To: <86802c440901080203m221def59qf1cd9fa3d017fd38@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: hwinfo problem since 2.6.28
Thread-Index: AclxeFAAP12qHlCdT0WJr07P7ljZuAAP2bgg
References: <Aclv3DYqPGwhSzk9Qg22IVoJDubF+w==> <3C59DB883F7B0B4D8096010D45ACCD13C73EA2@exch.facton.local> <86802c440901080203m221def59qf1cd9fa3d017fd38@mail.gmail.com>
From: "Beschorner Daniel" <Daniel.Beschorner@facton.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jan 6, 2009 at 12:53 AM, Beschorner Daniel
> <Daniel.Beschorner@facton.com> wrote:
> > Since 2.6.28 my hwinfo tool crashes badly on 2 years old 
> OpenSuSE 10.2
> > x64/SMP.
> > Older kernels run fine, I did a "make oldconfig" and rather used
> > defaults (just skipping low-64k checks).
> > This seems to be the only affected binary as far I can see.
> > Did I miss a new legacy/compat option or is it a bug?
> >
> > Thank you!
> > Daniel
> >
> > hwinfo: Corrupted page table at address 7fd04de3ec00
> > PGD 7dc33067 PUD 3efe067 PMD 27b83067 PTE fffffffffffffbff
> > Bad pagetable: 000d [#9] SMP
> > last sysfs file: 
> /sys/devices/pci0000:00/0000:00:1e.0/0000:06:05.0/class
> > CPU 0
> > Modules linked in:
> > Pid: 13700, comm: hwinfo Tainted: G      D    2.6.28 #7
> > RIP: 0033:[<00007fd04d66f7f2>]  [<00007fd04d66f7f2>] 0x7fd04d66f7f2
> > RSP: 002b:00007fff55ed2c68  EFLAGS: 00010202
> > RAX: 00000000015d1fb0 RBX: 0000000000001000 RCX: fefefefefefefeff
> > RDX: 0000000000000001 RSI: 00007fd04de3ec00 RDI: 00000000015d1fb0
> > RBP: 000000000009fc00 R08: ffffffffff000000 R09: 00007fd04d6fbd60
> > R10: ffffffffffffffff R11: 0000000000000000 R12: 00007fd04d9a72f6
> > R13: 000000000009f000 R14: 0000000000000003 R15: 00000000015b4010
> > FS:  00007fd04dec06f0(0000) GS:ffffffff80619540(0000)
> > knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 00007fd04de3ec00 CR3: 000000007de55000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process hwinfo (pid: 13700, threadinfo ffff88007dff2000, task
> > ffff88007ed934a0)
> >
> > RIP  [<00007fd04d66f7f2>] 0x7fd04d66f7f2
> >  RSP <00007fff55ed2c68>
> > ---[ end trace 742092d3bead57cc ]---
> >
> 
> bootlog with debug in command line?
> 
> YH

BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28 (root@box) (gcc version 4.1.2 20061115 (prerelease)
(SUSE Linux)) #7 SMP Mon Jan 5 14:32:39 CET 2009
Command line: root=/dev/md1 debug
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 000000007ffc0000 (usable)
 BIOS-e820: 000000007ffc0000 - 000000007ffcfc00 (ACPI data)
 BIOS-e820: 000000007ffcfc00 - 000000007ffff000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed13000 - 00000000feda0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x7ffc0 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: 0000000000000000-000000007ffc0000
 0000000000 - 007fe00000 page 2M
 007fe00000 - 007ffc0000 page 4k
kernel direct mapping tables up to 7ffc0000 @ 8000-c000
last_map_addr: 7ffc0000 end: 7ffc0000
ACPI: RSDP 000F9EA0, 0024 (r2 DELL  )
ACPI: XSDT 000F9F14, 0054 (r1 DELL   PE_SC3          1 INTL        1)
ACPI: FACP 000FA004, 00F4 (r3 DELL   PE_SC3          1 INTL        1)
FADT: X_PM1a_EVT_BLK.bit_width (4) does not match PM1_EVT_LEN (4)
ACPI: DSDT 7FFC0000, 1F8A (r1 DELL   PE_SC3          1 INTL 20050624)
ACPI: FACS 7FFCFC00, 0040
ACPI: APIC 000FA0F8, 0084 (r1 DELL   PE_SC3          1 INTL        1)
ACPI: SPCR 000FA17C, 0050 (r1 DELL   PE_SC3          1 INTL        1)
ACPI: HPET 000FA1CC, 0038 (r1 DELL   PE_SC3          1 INTL        1)
ACPI: MCFG 000FA204, 003C (r1 DELL   PE_SC3          1 INTL        1)
ACPI: SLIC 000FA240, 0176 (r1 DELL   PE_SC3          1 INTL        1)
ACPI: Local APIC address 0xfee00000
(5 early reservations) ==> bootmem [0000000000 - 007ffc0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 -
0000008000]
  #2 [0000200000 - 00006bab70]    TEXT DATA BSS ==> [0000200000 -
00006bab70]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 -
0000100000]
  #4 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 -
000000a000]
found SMP MP-table at [ffff8800000fe710] 000fe710
 [ffffe20000000000-ffffe20001bfffff] PMD ->
[ffff880001200000-ffff880002dfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x000000a0
    0: 0x00000100 -> 0x0007ffc0
On node 0 totalpages: 524128
  DMA zone: 56 pages used for memmap
  DMA zone: 1313 pages reserved
  DMA zone: 2631 pages, LIFO batch:0
  DMA32 zone: 7112 pages used for memmap
  DMA32 zone: 513016 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[32])
IOAPIC[1]: apic_id 3, version 0, address 0xfec10000, GSI 32-55
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: HPET id: 0xffffffff base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at 80000000 (gap: 7ffff000:70001000)
PERCPU: Allocating 45056 bytes of per cpu data
NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
515647
Kernel command line: root=/dev/md1 debug
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 2133.207 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
No AGP bridge found
Memory: 2059132k/2096896k available (2894k kernel code, 384k absent,
36816k reserved, 1241k data, 332k init)
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4266.41 BogoMIPS (lpj=8532828)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Freeing SMP alternatives: 25k freed
ACPI: Core revision 20080926
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU            3050  @ 2.13GHz stepping 06
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4266.82 BogoMIPS
(lpj=8533655)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Xeon(R) CPU            3050  @ 2.13GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (8533.24 BogoMIPS).
net_namespace: 912 bytes
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0xbce0-0xbcff]
pci 0000:00:1d.1: reg 20 io port: [0xbcc0-0xbcdf]
pci 0000:00:1d.2: reg 20 io port: [0xbca0-0xbcbf]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfeb00400-0xfeb007ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0880-08bf claimed by ICH6 GPIO
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0xfc00-0xfc0f]
pci 0000:00:1f.2: reg 10 io port: [0xbc98-0xbc9f]
pci 0000:00:1f.2: reg 14 io port: [0xbc90-0xbc93]
pci 0000:00:1f.2: reg 18 io port: [0xbc80-0xbc87]
pci 0000:00:1f.2: reg 1c io port: [0xbc78-0xbc7b]
pci 0000:00:1f.2: reg 20 io port: [0xbc60-0xbc6f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xfeb00000-0xfeb003ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0x8c0-0x8df]
pci 0000:02:00.0: PXH quirk detected; SHPC device MSI disabled
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
pci 0000:04:00.0: reg 10 64bit mmio: [0xfe8f0000-0xfe8fffff]
pci 0000:04:00.0: PME# supported from D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:1c.4: bridge io port: [0xe000-0xefff]
pci 0000:00:1c.4: bridge 32bit mmio: [0xfe800000-0xfe9fffff]
pci 0000:05:00.0: reg 10 64bit mmio: [0xfe6f0000-0xfe6fffff]
pci 0000:05:00.0: PME# supported from D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:00:1c.5: bridge io port: [0xd000-0xdfff]
pci 0000:00:1c.5: bridge 32bit mmio: [0xfe600000-0xfe7fffff]
pci 0000:06:05.0: reg 10 32bit mmio: [0xe8000000-0xefffffff]
pci 0000:06:05.0: reg 14 io port: [0xcc00-0xccff]
pci 0000:06:05.0: reg 18 32bit mmio: [0xfe4f0000-0xfe4fffff]
pci 0000:06:05.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:06:05.0: supports D1 D2
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xfe400000-0xfe5fffff]
pci 0000:00:1e.0: bridge 64bit mmio pref: [0xe8000000-0xefffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PES1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEP0.PXHA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIS._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 9 10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12) *0,
disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 *6 7 9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12) *0,
disabled.
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
system 00:07: ioport range 0x800-0x87f has been reserved
system 00:07: ioport range 0x880-0x8bf has been reserved
system 00:07: ioport range 0x8c0-0x8df has been reserved
system 00:07: ioport range 0x8e0-0x8e3 has been reserved
system 00:07: ioport range 0xc00-0xc0f has been reserved
system 00:07: ioport range 0xc10-0xc1f has been reserved
system 00:07: ioport range 0xca0-0xca7 has been reserved
system 00:07: ioport range 0xca9-0xcab has been reserved
system 00:07: ioport range 0xcad-0xcaf has been reserved
system 00:07: ioport range 0xc20-0xc3f has been reserved
system 00:09: iomem range 0xf0000000-0xf3ffffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:02:00.0: PCI bridge, secondary bus 0000:03
pci 0000:02:00.0:   IO window: disabled
pci 0000:02:00.0:   MEM window: disabled
pci 0000:02:00.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0xfea00000-0xfeafffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.4:   IO window: 0xe000-0xefff
pci 0000:00:1c.4:   MEM window: 0xfe800000-0xfe9fffff
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:05
pci 0000:00:1c.5:   IO window: 0xd000-0xdfff
pci 0000:00:1c.5:   MEM window: 0xfe600000-0xfe7fffff
pci 0000:00:1c.5:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
pci 0000:00:1e.0:   MEM window: 0xfe400000-0xfe5fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000e8000000-0x000000efffffff
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:02:00.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT B -> GSI 22 (level, low) -> IRQ 22
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT C -> GSI 23 (level, low) -> IRQ 23
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 01 index 0 mmio: [0x0-0x0]
bus: 01 index 1 mmio: [0x0-0x0]
bus: 01 index 2 mmio: [0x0-0x0]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 mmio: [0x0-0x0]
bus: 02 index 1 mmio: [0xfea00000-0xfeafffff]
bus: 02 index 2 mmio: [0x0-0x0]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 03 index 0 mmio: [0x0-0x0]
bus: 03 index 1 mmio: [0x0-0x0]
bus: 03 index 2 mmio: [0x0-0x0]
bus: 03 index 3 mmio: [0x0-0x0]
bus: 04 index 0 io port: [0xe000-0xefff]
bus: 04 index 1 mmio: [0xfe800000-0xfe9fffff]
bus: 04 index 2 mmio: [0x0-0x0]
bus: 04 index 3 mmio: [0x0-0x0]
bus: 05 index 0 io port: [0xd000-0xdfff]
bus: 05 index 1 mmio: [0xfe600000-0xfe7fffff]
bus: 05 index 2 mmio: [0x0-0x0]
bus: 05 index 3 mmio: [0x0-0x0]
bus: 06 index 0 io port: [0xc000-0xcfff]
bus: 06 index 1 mmio: [0xfe400000-0xfe5fffff]
bus: 06 index 2 mmio: [0xe8000000-0xefffffff]
bus: 06 index 3 io port: [0x00-0xffff]
bus: 06 index 4 mmio: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
alg: cipher: Test 1 failed on encryption for aes-asm
00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
msgmni has been set to 4022
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:06:05.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pcieport-driver 0000:00:01.0: irq 319 for MSI/MSI-X
pci_express 0000:00:01.0:pcie00: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pcieport-driver 0000:00:1c.0: irq 318 for MSI/MSI-X
pci_express 0000:00:1c.0:pcie00: allocate port service
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pcieport-driver 0000:00:1c.4: found MSI capability
pcieport-driver 0000:00:1c.4: irq 317 for MSI/MSI-X
pci_express 0000:00:1c.4:pcie00: allocate port service
pcieport-driver 0000:00:1c.5: setting latency timer to 64
pcieport-driver 0000:00:1c.5: found MSI capability
pcieport-driver 0000:00:1c.5: irq 316 for MSI/MSI-X
pci_express 0000:00:1c.5:pcie00: allocate port service
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
tg3.c:v3.94 (August 14, 2008)
tg3 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
tg3 0000:04:00.0: setting latency timer to 64
eth0: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express)
10/100/1000Base-T Ethernet 00:15:c5:f5:29:9e
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
tg3 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
tg3 0000:05:00.0: setting latency timer to 64
eth1: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express)
10/100/1000Base-T Ethernet 00:15:c5:f5:29:9f
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[76180000] dma_mask[64-bit]
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x01)
pci 0000:00:1f.1: can't derive routing for PCI INT A
piix 0000:00:1f.1: IDE port disabled
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfc00-0xfc07
Probing IDE interface ide0...
hda: HL-DT-ST DVD-ROM GDR-8084N, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide_generic: please use "probe_mask=0x3f" module parameter for probing
all legacy ISA IDE ports
ide-cd driver 5.00
ide-cd: hda: ATAPI 24X DVD-ROM drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0xbc98 ctl 0xbc90 bmdma 0xbc60 irq 20
ata2: SATA max UDMA/133 cmd 0xbc80 ctl 0xbc78 bmdma 0xbc68 irq 20
ata1.00: ATA-7: WDC WD800JD-75MSA3, 10.01E04, max UDMA/133
ata1.00: 156250000 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2.00: ATA-7: WDC WD800JD-75MSA3, 10.01E04, max UDMA/133
ata2.00: 156250000 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      WDC WD800JD-75MS 10.0 PQ: 0
ANSI: 5
sd 0:0:0:0: [sda] 156250000 512-byte hardware sectors: (80.0 GB/74.5
GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 156250000 512-byte hardware sectors: (80.0 GB/74.5
GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      WDC WD800JD-75MS 10.0 PQ: 0
ANSI: 5
sd 1:0:0:0: [sdb] 156250000 512-byte hardware sectors: (80.0 GB/74.5
GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 1:0:0:0: [sdb] 156250000 512-byte hardware sectors: (80.0 GB/74.5
GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfeb00400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000bce0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x0000bcc0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 22, io base 0x0000bca0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input0
md: raid1 personality registered for level 1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
u32 classifier
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
NET: Registered protocol family 15
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 8 and added 8 devices.
md: autorun ...
md: considering sdb4 ...
md:  adding sdb4 ...
md: sdb3 has different UUID to sdb4
md: sdb2 has different UUID to sdb4
md: sdb1 has different UUID to sdb4
md:  adding sda4 ...
md: sda3 has different UUID to sdb4
md: sda2 has different UUID to sdb4
md: sda1 has different UUID to sdb4
md: created md3
md: bind<sda4>
md: bind<sdb4>
md: running: <sdb4><sda4>
raid1: raid set md3 active with 2 out of 2 mirrors
md: considering sdb3 ...
md:  adding sdb3 ...
md: sdb2 has different UUID to sdb3
md: sdb1 has different UUID to sdb3
md:  adding sda3 ...
md: sda2 has different UUID to sdb3
md: sda1 has different UUID to sdb3
md: created md2
md: bind<sda3>
md: bind<sdb3>
md: running: <sdb3><sda3>
raid1: raid set md2 active with 2 out of 2 mirrors
md: considering sdb2 ...
md:  adding sdb2 ...
md: sdb1 has different UUID to sdb2
md:  adding sda2 ...
md: sda1 has different UUID to sdb2
md: created md1
md: bind<sda2>
md: bind<sdb2>
md: running: <sdb2><sda2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
 md1: unknown partition table
usb 1-3: new high speed USB device using ehci_hcd and address 2
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 332k freed
usb 1-3: configuration #1 chosen from 1 choice
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 4 ports detected
usb 4-1: new low speed USB device using uhci_hcd and address 2
usb 4-1: configuration #1 chosen from 1 choice
input: HID 2101:020f as
/devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input1
generic-usb 0003:2101:020F.0001: input: USB HID v1.01 Keyboard [HID
2101:020f] on usb-0000:00:1d.2-1/input0
input: HID 2101:020f as
/devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.1/input/input2
generic-usb 0003:2101:020F.0002: input: USB HID v1.01 Mouse [HID
2101:020f] on usb-0000:00:1d.2-1/input1
 md0: unknown partition table
Adding 530040k swap on /dev/md0.  Priority:-1 extents:1 across:530040k
EXT3 FS on md1, internal journal
 md3: unknown partition table
 md2: unknown partition table
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
