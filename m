Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYJVPUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYJVPUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYJVPT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:19:59 -0400
Received: from bender.cm4all.net ([87.106.27.49]:50461 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYJVPT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:19:57 -0400
Date: Wed, 22 Oct 2008 17:18:46 +0200
From: Max Kellermann <mk@cm4all.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Glauber Costa <glommer@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
Message-ID: <20081022151846.GA9319@rabbit.intern.cm-ag>
References: <20081022140009.GA9639@localhost> <20081022141354.GA26372@elte.hu> <20081022141720.GB9639@localhost> <20081022142312.GC26372@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20081022142312.GC26372@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2008/10/22 16:23, Ingo Molnar <mingo@elte.hu> wrote:
> ah, Compaq - how many CPUs does that box support? If it's 8 or more then 
> perhaps they turned off the real local APIC, fudged some chipset glue to 
> emulate APIC functionality and thus were able to use 8 or more of these 
> chips? The built-in lapic would only go up to 4 CPUs. (or maybe even 
> just up to dual, depending on the model)

No, it's a rather small ProLiant server.  2 physical CPUs, maybe it
supports up to 4, but no more (each with HT).  I have attached its
dmesg.

Max

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: quoted-printable

BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fffa000 (usable)
 BIOS-e820: 000000007fffa000 - 0000000080000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
last_pfn =3D 0x7fffa max_arch_pfn =3D 0x1000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 38000000 @ 7000-c000
DMI 2.3 present.
ACPI: RSDP 000F4F70, 0014 (r0 COMPAQ)
ACPI: RSDT 7FFFA000, 0030 (r1 COMPAQ P29             2   =D2=04     162E)
ACPI: FACP 7FFFA040, 0074 (r1 COMPAQ P29             2   =D2=04     162E)
ACPI: DSDT 7FFFA240, 3E50 (r1 COMPAQ     DSDT        1 MSFT  100000B)
ACPI: FACS 7FFFA0C0, 0040
ACPI: APIC 7FFFA100, 00AC (r1 COMPAQ 00000083        2             0)
ACPI: SPCR 7FFFA1C0, 0050 (r1 COMPAQ SPCRRBSU        1   =D2=04     162E)
1151MB HIGHMEM available.
896MB LOWMEM available.
  mapped low ram: 0 - 38000000
  low ram: 00000000 - 38000000
  bootmap 00009000 - 00010000
(8 early reservations) =3D=3D> bootmem [0000000000 - 0038000000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 00000=
01000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=3D> [0000001000 - 00000=
02000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=3D> [0000006000 - 00000=
07000]
  #3 [0000100000 - 00005e3ff0]    TEXT DATA BSS =3D=3D> [0000100000 - 00005=
e3ff0]
  #4 [00005e4000 - 00005ec000]    INIT_PG_TABLE =3D=3D> [00005e4000 - 00005=
ec000]
  #5 [000009f400 - 0000100000]    BIOS reserved =3D=3D> [000009f400 - 00001=
00000]
  #6 [0000007000 - 0000009000]          PGTABLE =3D=3D> [0000007000 - 00000=
09000]
  #7 [0000009000 - 0000010000]          BOOTMAP =3D=3D> [0000009000 - 00000=
10000]
found SMP MP-table at [c00f4fd0] 000f4fd0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00038000
  HighMem  0x00038000 -> 0x0007fffa
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0007fffa
On node 0 totalpages: 524185
free_area_init_node: node 0, pgdat c051e680, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 292602 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x920
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])
IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, GSI 16-31
ACPI: IOAPIC (id[0x04] address[0xfec02000] gsi_base[32])
IOAPIC[2]: apic_id 4, version 17, address 0xfec02000, GSI 32-47
ACPI: IOAPIC (id[0x05] address[0xfec03000] gsi_base[48])
IOAPIC[3]: apic_id 5, version 17, address 0xfec03000, GSI 48-63
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 4 I/O APICs
Using ACPI (MADT) for SMP configuration information
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
mapped IOAPIC to ffff9000 (fec01000)
mapped IOAPIC to ffff8000 (fec02000)
mapped IOAPIC to ffff7000 (fec03000)
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
PERCPU: Allocating 39836 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 8, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520089
Kernel command line: auto BOOT_IMAGE=3DLinux ro root=3D6801
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=3Dc0585000 soft=3Dc057d000
PID hash table entries: 4096 (order: 12, 16384 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 2392.840 MHz processor.
Console: colour VGA+ 80x50
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2073508k/2097128k available (2844k kernel code, 22436k reserved, 14=
51k data, 264k init, 1179624k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff52000 - 0xfffff000   ( 692 kB)
    pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
    vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0538000 - 0xc057a000   ( 264 kB)
      .data : 0xc03c73e3 - 0xc0532150   (1451 kB)
      .text : 0xc0100000 - 0xc03c73e3   (2844 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=3D12, HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D4, =
Nodes=3D1
Calibrating delay loop (skipped), value calculated using timer frequency.. =
4785.68 BogoMIPS (lpj=3D9571360)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 13k freed
ACPI: Core revision 20080609
ENABLING IO-APIC IRQs
=2E.TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
CPU0: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
CPU 1 irqstacks, hard=3Dc0586000 soft=3Dc057e000
Booting processor 1/6 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4786.19 BogoMIPS (lpj=3D95=
72385)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
CPU 2 irqstacks, hard=3Dc0587000 soft=3Dc057f000
Booting processor 2/1 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4786.10 BogoMIPS (lpj=3D95=
72211)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel P4/Xeon Extended MCE MSRs (12) available
CPU2: Thermal monitoring enabled
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
CPU 3 irqstacks, hard=3Dc0588000 soft=3Dc0580000
Booting processor 3/7 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4786.21 BogoMIPS (lpj=3D95=
72434)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel P4/Xeon Extended MCE MSRs (12) available
CPU3: Thermal monitoring enabled
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (19144.19 BogoMIPS).
net_namespace: 596 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
PCI: HP ProLiant DL380 detected, enabling pci=3Dbfsort.
mtrr: your CPUs had inconsistent fixed MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:03.0 reg 10 32bit mmio: [f6000000, f6ffffff]
PCI: 0000:00:03.0 reg 14 io port: [2400, 24ff]
PCI: 0000:00:03.0 reg 18 32bit mmio: [f5ff0000, f5ff0fff]
PCI: 0000:00:03.0 reg 30 32bit mmio: [0, 1ffff]
pci 0000:00:03.0: supports D1
pci 0000:00:03.0: supports D2
PCI: 0000:00:04.0 reg 10 io port: [1800, 18ff]
PCI: 0000:00:04.0 reg 14 32bit mmio: [f5fe0000, f5fe01ff]
PCI: 0000:00:04.2 reg 10 io port: [2800, 28ff]
PCI: 0000:00:04.2 reg 14 32bit mmio: [f5fd0000, f5fd07ff]
PCI: 0000:00:04.2 reg 18 32bit mmio: [f5fc0000, f5fc1fff]
PCI: 0000:00:04.2 reg 1c 32bit mmio: [f5f00000, f5f7ffff]
PCI: 0000:00:04.2 reg 30 32bit mmio: [0, ffff]
pci 0000:00:04.2: PME# supported from D0 D3hot D3cold
pci 0000:00:04.2: PME# disabled
PCI: 0000:00:0f.1 reg 10 io port: [1f0, 1f7]
PCI: 0000:00:0f.1 reg 14 io port: [3f4, 3f7]
PCI: 0000:00:0f.1 reg 18 io port: [170, 177]
PCI: 0000:00:0f.1 reg 1c io port: [374, 377]
PCI: 0000:00:0f.1 reg 20 io port: [2000, 200f]
PCI: 0000:00:0f.2 reg 10 32bit mmio: [f5ef0000, f5ef0fff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:01)
PCI: 0000:01:03.0 reg 10 64bit mmio: [f79c0000, f79fffff]
PCI: 0000:01:03.0 reg 18 io port: [3000, 30ff]
PCI: 0000:01:03.0 reg 1c 32bit mmio: [f78f0000, f78f3fff]
PCI: 0000:01:03.0 reg 30 32bit mmio: [0, 3fff]
pci 0000:01:03.0: supports D1
bus 01 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Root Bridge [PCI2] (0000:02)
PCI: 0000:02:01.0 reg 10 64bit mmio: [f7af0000, f7afffff]
PCI: 0000:02:01.0 reg 30 32bit mmio: [0, ffff]
pci 0000:02:01.0: PME# supported from D3hot D3cold
pci 0000:02:01.0: PME# disabled
PCI: 0000:02:02.0 reg 10 64bit mmio: [f7ae0000, f7aeffff]
PCI: 0000:02:02.0 reg 30 32bit mmio: [0, ffff]
pci 0000:02:02.0: PME# supported from D3hot D3cold
pci 0000:02:02.0: PME# disabled
bus 02 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2._PRT]
ACPI: PCI Root Bridge [PCI3] (0000:03)
bus 03 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI3._PRT]
ACPI: PCI Root Bridge [PCI4] (0000:06)
PCI: 0000:06:1e.0 reg 10 32bit mmio: [f7bf0000, f7bf0fff]
PCI: 0000:07:04.0 reg 10 32bit mmio: [f7ff0000, f7ff0fff]
PCI: 0000:07:04.0 reg 14 io port: [4000, 403f]
PCI: 0000:07:04.0 reg 18 32bit mmio: [f7e00000, f7efffff]
pci 0000:07:04.0: supports D1
pci 0000:07:04.0: supports D2
pci 0000:07:04.0: PME# supported from D0 D1 D2 D3hot
pci 0000:07:04.0: PME# disabled
PCI: 0000:07:05.0 reg 10 32bit mmio: [f7df0000, f7df0fff]
PCI: 0000:07:05.0 reg 14 io port: [4040, 407f]
PCI: 0000:07:05.0 reg 18 32bit mmio: [f7c00000, f7cfffff]
pci 0000:07:05.0: supports D1
pci 0000:07:05.0: supports D2
pci 0000:07:05.0: PME# supported from D0 D1 D2 D3hot
pci 0000:07:05.0: PME# disabled
PCI: bridge 0000:06:01.0 io port: [4000, 4fff]
PCI: bridge 0000:06:01.0 32bit mmio: [f7c00000, f7ffffff]
bus 06 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI4._PRT]
ACPI: PCI Interrupt Link [IUSB] (IRQs 4 5 *7 10 11 15)
ACPI: PCI Interrupt Link [IN16] (IRQs 4 5 7 10 11 15) *3
ACPI: PCI Interrupt Link [IN17] (IRQs 4 *5 7 10 11 15)
ACPI: PCI Interrupt Link [IN18] (IRQs 4 5 7 10 11 *15)
ACPI: PCI Interrupt Link [IN19] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN20] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN21] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN22] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN23] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN24] (IRQs 4 5 7 10 *11 15)
ACPI: PCI Interrupt Link [IN25] (IRQs 4 5 *7 10 11 15)
ACPI: PCI Interrupt Link [IN26] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN27] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN28] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN29] (IRQs 4 5 7 10 *11 15)
ACPI: PCI Interrupt Link [IN30] (IRQs 4 5 7 *10 11 15)
ACPI: PCI Interrupt Link [IN31] (IRQs 4 5 7 10 11 *15)
ACPI: PCI Interrupt Link [IN32] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN33] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN34] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: WMI: Mapper loaded
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
system 00:01: ioport range 0xf50-0xf58 has been reserved
system 00:01: ioport range 0x408-0x40f has been reserved
system 00:01: ioport range 0x900-0x903 has been reserved
system 00:01: ioport range 0x910-0x911 has been reserved
system 00:01: ioport range 0x920-0x923 has been reserved
system 00:01: ioport range 0x930-0x937 has been reserved
system 00:01: ioport range 0x940-0x947 has been reserved
system 00:01: ioport range 0x950-0x957 has been reserved
system 00:01: ioport range 0xc06-0xc08 has been reserved
system 00:01: ioport range 0xc14-0xc14 has been reserved
system 00:01: ioport range 0xc49-0xc4a has been reserved
system 00:01: ioport range 0xc50-0xc52 has been reserved
system 00:01: ioport range 0xc6c-0xc6f has been reserved
system 00:01: ioport range 0x230-0x233 has been reserved
system 00:01: ioport range 0x260-0x267 has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x700-0x70f has been reserved
system 00:01: ioport range 0x800-0x81f has been reserved
system 00:01: ioport range 0xc80-0xc83 has been reserved
system 00:01: ioport range 0xcd4-0xcd7 has been reserved
system 00:01: ioport range 0xcf9-0xcf9 could not be reserved
pci 0000:06:01.0: PCI bridge, secondary bus 0000:07
pci 0000:06:01.0:   IO window: 0x4000-0x4fff
pci 0000:06:01.0:   MEM window: 0xf7c00000-0xf7ffffff
pci 0000:06:01.0:   PREFETCH window: disabled
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 01 index 0 io port: [0, ffff]
bus: 01 index 1 mmio: [0, ffffffffffffffff]
bus: 02 index 0 io port: [0, ffff]
bus: 02 index 1 mmio: [0, ffffffffffffffff]
bus: 03 index 0 io port: [0, ffff]
bus: 03 index 1 mmio: [0, ffffffffffffffff]
bus: 06 index 0 io port: [0, ffff]
bus: 06 index 1 mmio: [0, ffffffffffffffff]
bus: 07 index 0 io port: [4000, 4fff]
bus: 07 index 1 mmio: [f7c00000, f7ffffff]
bus: 07 index 2 mmio: [0, 0]
bus: 07 index 3 mmio: [0, 0]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
SGI XFS with ACLs, security attributes, large block numbers, no debug enabl=
ed
msgmni has been set to 1747
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:03.0: Boot video device
pci 0000:07:04.0: Firmware left e100 interrupts enabled; disabling
pci 0000:07:05.0: Firmware left e100 interrupts enabled; disabling
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
processor ACPI0007:00: registered as cooling_device0
processor ACPI0007:01: registered as cooling_device1
processor ACPI0007:06: registered as cooling_device2
processor ACPI0007:07: registered as cooling_device3
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (8 C)
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
loop: module loaded
HP CISS Driver (v 3.6.20)
cciss 0000:01:03.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
cciss0: <0xb178> at PCI 0000:01:03.0 IRQ 30 using DAC
      blocks=3D 71122560 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D8716

      blocks=3D 71122560 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D8716

 cciss/c0d0: p1 p2 p3 p4 < p5 p6 p7 p8 p9 >
      blocks=3D 142253280 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D17433

      blocks=3D 142253280 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D17433

 cciss/c0d1: p1
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Loading iSCSI transport class v2.0-870.
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
scsi0 : pata_serverworks
scsi1 : pata_serverworks
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2000 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2008 irq 15
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 0

--J2SCkAp4GZ/dPZZf--
