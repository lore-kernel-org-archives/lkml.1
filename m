Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYHZKqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYHZKqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYHZKq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:46:28 -0400
Received: from cpsmtpo-eml03.kpnxchange.com ([213.75.38.152]:32283 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719AbYHZKqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:46:24 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [2.6.27-rc4] sysfs: duplicate filename 'vcs1' can not be created
Date: Tue, 26 Aug 2008 12:46:20 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_979sIX8yhtbk08M"
Message-Id: <200808261246.21206.elendil@planet.nl>
X-OriginalArrivalTime: 26 Aug 2008 10:46:21.0454 (UTC) FILETIME=[FA5382E0:01C90768]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_979sIX8yhtbk08M
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This error seems to happen only in some specific cases as it's the first 
time I've seen it even though I've booted the same kernel before without 
the problem.

WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
sysfs: duplicate filename 'vcs1' can not be created
[...]
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
sysfs: duplicate filename 'vcsa1' can not be created

Same issue has also been reported for Ubuntu with their 2.6.24 kernel:
   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/196409
and is also mentioned in this tread for 2.6.24-rc7-rt2:
   http://fixunix.com/kernel/328116-2-6-24-rc7-rt2.html

Cheers,
FJP


--Boundary-00=_979sIX8yhtbk08M
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg_sysfs_errors"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="dmesg_sysfs_errors"

Linux version 2.6.27-rc4 (root@faramir) (gcc version 4.3.1 (Debian 4.3.1-9) ) #56 SMP Sat Aug 23 05:02:49 CEST 2008
Command line: root=/dev/mapper/main-root ro quiet vga=791
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007e7b0000 (usable)
 BIOS-e820: 000000007e7b0000 - 000000007e7c5400 (reserved)
 BIOS-e820: 000000007e7c5400 - 000000007e7e7fb8 (ACPI NVS)
 BIOS-e820: 000000007e7e7fb8 - 000000007f000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
last_pfn = 0x7e7b0 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
 0000000000 - 007e600000 page 2M
 007e600000 - 007e7b0000 page 4k
kernel direct mapping tables up to 7e7b0000 @ 8000-c000
last_map_addr: 7e7b0000 end: 7e7b0000
RAMDISK: 37aa2000 - 37fefbec
DMI 2.4 present.
ACPI: RSDP 000F7960, 0024 (r2 HP    )
ACPI: XSDT 7E7C81C8, 007C (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: FACP 7E7C8084, 00F4 (r4 HP     30C9            3 HP          1)
ACPI: DSDT 7E7C8538, 13484 (r1 HP       nc2500    10000 MSFT  3000001)
ACPI: FACS 7E7E7D80, 0040
ACPI: SLIC 7E7C8244, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: HPET 7E7C83BC, 0038 (r1 HP     30C9            1 HP          1)
ACPI: APIC 7E7C83F4, 0068 (r1 HP     30C9            1 HP          1)
ACPI: MCFG 7E7C845C, 003C (r1 HP     30C9            1 HP          1)
ACPI: TCPA 7E7C8498, 0032 (r2 HP     30C9            1 HP          1)
ACPI: ASF! 7E7C84CC, 0069 (r16 HP     CHIMAYU         1 HP          0)
ACPI: SSDT 7E7DB9BC, 02BE (r1 HP       HPQPAT        1 MSFT  3000001)
ACPI: SSDT 7E7DC640, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
ACPI: SSDT 7E7DC89F, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
ACPI: SSDT 7E7DC945, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
ACPI: DMI detected: Hewlett-Packard
No NUMA configuration found
Faking a node at 0000000000000000-000000007e7b0000
Bootmem setup node 0 0000000000000000-000000007e7b0000
  NODE_DATA [0000000000001000 - 0000000000004fff]
  bootmap [000000000000a000 -  0000000000019cf7] pages 10
(6 early reservations) ==> bootmem [0000000000 - 007e7b0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 000074c460]    TEXT DATA BSS ==> [0000200000 - 000074c460]
  #3 [0037aa2000 - 0037fefbec]          RAMDISK ==> [0037aa2000 - 0037fefbec]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
 [ffffe20000000000-ffffe20001ffffff] PMD -> [ffff880001200000-ffff8800031fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0007e7b0
On node 0 totalpages: 517967
  DMA zone: 2478 pages, LIFO batch:0
  DMA32 zone: 505937 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 7f000000:7fc00000)
PERCPU: Allocating 47656 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 508415
Policy zone: DMA32
Kernel command line: root=/dev/mapper/main-root ro quiet vga=791
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Detected 1329.998 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2027948k/2072256k available (2279k kernel code, 43920k reserved, 1434k data, 368k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 2659.99 BogoMIPS (lpj=5319992)
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
Using local APIC timer interrupts.
APIC timer calibration result 8312486
Detected 8.312 MHz APIC timer.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2659.99 BogoMIPS (lpj=5319988)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (5319.99 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
net_namespace: 1552 bytes
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: MCFG area at f8000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at f8000000 - fbffffff
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [C003] (0000:00)
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
pci 0000:10:00.0: PME# disabled
PCI: bridge 0000:00:1c.1 32bit mmio: [e0000000, e00fffff]
pci 0000:02:06.0: supports D1
pci 0000:02:06.0: supports D2
pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.0: PME# disabled
pci 0000:02:06.1: supports D1
pci 0000:02:06.1: supports D2
pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.1: PME# disabled
pci 0000:02:06.2: supports D1
pci 0000:02:06.2: supports D2
pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.2: PME# disabled
pci 0000:02:06.3: supports D1
pci 0000:02:06.3: supports D2
pci 0000:02:06.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.3: PME# disabled
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 32bit mmio: [e0100000, e03fffff]
ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
ACPI Exception (pci_link-0189): AE_NOT_FOUND, Evaluating _PRS [20080609]
ACPI: Power Resource [C29F] (on)
ACPI: Power Resource [C1C7] (off)
ACPI: Power Resource [C3AD] (off)
ACPI: Power Resource [C3B0] (off)
ACPI: Power Resource [C3C3] (off)
ACPI: Power Resource [C3C4] (off)
ACPI: Power Resource [C3C5] (off)
ACPI: Power Resource [C3C6] (off)
ACPI: Power Resource [C3C7] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: parse allocated resources
pnp 00:00:   add mem 0x0-0x9ffff flags 0x1
pnp 00:00:   add mem 0xe0000-0xfffff flags 0x0
pnp 00:00:   add mem 0x100000-0x7e7fffff flags 0x1
pnp 00:00: PNP0c01: calling quirk_system_pci_resources+0x0/0x179
pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: parse allocated resources
pnp 00:01:   add io  0xcf8-0xcff flags 0x1
pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:02: parse allocated resources
pnp 00:02:   add io  0x560-0x56f flags 0x1
pnp 00:02:   add io  0x570-0x57f flags 0x1
pnp 00:02:   add mem 0xfed40000-0xfed44fff flags 0x1
pnp 00:02: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
pnp 00:03: parse allocated resources
pnp 00:03:   add io  0xf0-0xff flags 0x1
pnp 00:03:   add irq 13 flags 0x1
pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:04: parse allocated resources
pnp 00:04:   add io  0x0-0xf flags 0x1
pnp 00:04:   add io  0x80-0x8f flags 0x1
pnp 00:04:   add io  0xc0-0xdf flags 0x1
pnp 00:04:   add dma 4 flags 0x2
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: parse allocated resources
pnp 00:05:   add io  0x61-0x61 flags 0x1
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: parse allocated resources
pnp 00:06:   add io  0x70-0x71 flags 0x1
pnp 00:06:   add io  0x72-0x73 flags 0x1
pnp 00:06:   add irq 8 flags 0x1
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: parse allocated resources
pnp 00:07:   add mem 0xfed00000-0xfed003ff flags 0x0
pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:08: parse allocated resources
pnp 00:08:   add io  0x60-0x60 flags 0x1
pnp 00:08:   add io  0x64-0x64 flags 0x1
pnp 00:08:   add irq 1 flags 0x1
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:09: parse allocated resources
pnp 00:09:   add irq 12 flags 0x1
pnp 00:09: Plug and Play ACPI device, IDs SYN0130 SYN0100 SYN0002 PNP0f13 (active)
pnp 00:0a: parse allocated resources
pnp 00:0a:   add io  0x10-0x1f flags 0x1
pnp 00:0a:   add io  0x24-0x3f flags 0x1
pnp 00:0a:   add io  0x4e-0x4f flags 0x1
pnp 00:0a:   add io  0x50-0x53 flags 0x1
pnp 00:0a:   add io  0x63-0x63 flags 0x1
pnp 00:0a:   add io  0x65-0x65 flags 0x1
pnp 00:0a:   add io  0x67-0x67 flags 0x1
pnp 00:0a:   add io  0x74-0x77 flags 0x1
pnp 00:0a:   add io  0x90-0x9f flags 0x1
pnp 00:0a:   add io  0xa4-0xbd flags 0x1
pnp 00:0a:   add io  0x500-0x55f flags 0x1
pnp 00:0a:   add io  0x800-0x80f flags 0x1
pnp 00:0a:   add mem 0xffb00000-0xffbfffff flags 0x0
pnp 00:0a:   add mem 0xfff00000-0xffffffff flags 0x0
pnp 00:0a: PNP0c02: calling quirk_system_pci_resources+0x0/0x179
pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0b: parse allocated resources
pnp 00:0b:   add irq 23 flags 0x1
pnp 00:0b: Plug and Play ACPI device, IDs HPQ0004 (active)
pnp 00:0c: parse allocated resources
pnp 00:0c:   add io  0x4d0-0x4d1 flags 0x1
pnp 00:0c:   add io  0x2f8-0x2ff flags 0x1
pnp 00:0c:   add io  0x3f8-0x3ff flags 0x1
pnp 00:0c:   add io  0x1000-0x107f flags 0x1
pnp 00:0c:   add io  0x1100-0x113f flags 0x1
pnp 00:0c:   add io  0x1200-0x121f flags 0x1
pnp 00:0c:   add mem 0xf8000000-0xfbffffff flags 0x1
pnp 00:0c:   add mem 0xfec00000-0xfec000ff flags 0x1
pnp 00:0c:   add mem 0xfed20000-0xfed3ffff flags 0x1
pnp 00:0c:   add mem 0xfed45000-0xfed8ffff flags 0x1
pnp 00:0c:   add mem 0xfed90000-0xfed99fff flags 0x1
pnp 00:0c: PNP0c02: calling quirk_system_pci_resources+0x0/0x179
pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0d: parse allocated resources
pnp 00:0d:   add mem 0xcee00-0xcffff flags 0x0
pnp 00:0d:   add mem 0xd2000-0xd3fff flags 0x0
pnp 00:0d:   add mem 0xfeda0000-0xfedbffff flags 0x1
pnp 00:0d:   add mem 0xfee00000-0xfee00fff flags 0x1
pnp 00:0d: PNP0c02: calling quirk_system_pci_resources+0x0/0x179
pnp 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
pnp: the driver 'system' has been registered
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7e7fffff could not be reserved
system 00:00: driver attached
system 00:0a: ioport range 0x500-0x55f has been reserved
system 00:0a: ioport range 0x800-0x80f has been reserved
system 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
system 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:0a: driver attached
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0c: ioport range 0x2f8-0x2ff has been reserved
system 00:0c: ioport range 0x3f8-0x3ff has been reserved
system 00:0c: ioport range 0x1000-0x107f has been reserved
system 00:0c: ioport range 0x1100-0x113f has been reserved
system 00:0c: ioport range 0x1200-0x121f has been reserved
system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
system 00:0c: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:0c: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:0c: iomem range 0xfed90000-0xfed99fff could not be reserved
system 00:0c: driver attached
system 00:0d: iomem range 0xcee00-0xcffff has been reserved
system 00:0d: iomem range 0xd2000-0xd3fff has been reserved
system 00:0d: iomem range 0xfeda0000-0xfedbffff could not be reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0d: driver attached
pci 0000:02:06.0: BAR 9 too large: 0x00000000000000-0x00000003ffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:10
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0xe0000000-0xe00fffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
pci 0000:02:06.0:   IO window: 0x003000-0x0030ff
pci 0000:02:06.0:   IO window: 0x003400-0x0034ff
pci 0000:02:06.0:   MEM window: 0x80000000-0x83ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
pci 0000:00:1e.0:   MEM window: 0xe0100000-0xe03fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:02:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 08 index 0 mmio: [0, 0]
bus: 08 index 1 mmio: [0, 0]
bus: 08 index 2 mmio: [0, 0]
bus: 08 index 3 mmio: [0, 0]
bus: 10 index 0 mmio: [0, 0]
bus: 10 index 1 mmio: [e0000000, e00fffff]
bus: 10 index 2 mmio: [0, 0]
bus: 10 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [3000, 3fff]
bus: 02 index 1 mmio: [e0100000, e03fffff]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 io port: [0, ffff]
bus: 02 index 4 mmio: [0, ffffffffffffffff]
bus: 03 index 0 io port: [3000, 30ff]
bus: 03 index 1 io port: [3400, 34ff]
bus: 03 index 2 mmio: [0, 3ffffff]
bus: 03 index 3 mmio: [80000000, 83ffffff]
NET: Registered protocol family 2
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 5430k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1219753830.160:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 3971
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20004a80000, using 3072k, total 7616k
vesafb: mode is 1024x768x16, linelength=2048, pages=3
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
pnp: the driver 'serial' has been registered
serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
0000:00:03.3: ttyS0 at I/O 0x2040 (irq = 17) is a 16550A
brd: module loaded
pnp: the driver 'i8042 kbd' has been registered
i8042 kbd 00:08: driver attached
pnp: the driver 'i8042 aux' has been registered
i8042 aux 00:09: driver attached
PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
pnp: the driver 'rtc_cmos' has been registered
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, hpet irqs
rtc_cmos 00:06: driver attached
cpuidle: using governor ladder
cpuidle: using governor menu
TCP bic registered
NET: Registered protocol family 17
rtc_cmos 00:06: setting system clock to 2008-08-26 12:30:31 UTC (1219753831)
Freeing unused kernel memory: 368k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: Transitioning device [C3B1] to D3
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [C3B1] (off)
ACPI: Transitioning device [C3B2] to D3
fan PNP0C0B:01: registered as cooling_device1
ACPI: Fan [C3B2] (off)
ACPI: Transitioning device [C3C8] to D3
fan PNP0C0B:02: registered as cooling_device2
ACPI: Fan [C3C8] (off)
ACPI: Transitioning device [C3C9] to D3
fan PNP0C0B:03: registered as cooling_device3
ACPI: Fan [C3C9] (off)
ACPI: Transitioning device [C3CA] to D3
fan PNP0C0B:04: registered as cooling_device4
ACPI: Fan [C3CA] (off)
ACPI: Transitioning device [C3CB] to D3
fan PNP0C0B:05: registered as cooling_device5
ACPI: Fan [C3CB] (off)
ACPI: Transitioning device [C3CC] to D3
fan PNP0C0B:06: registered as cooling_device6
ACPI: Fan [C3CC] (off)
ACPI: SSDT 7E7DBD42, 027F (r1 HP      Cpu0Ist     3000 INTL 20060317)
ACPI: SSDT 7E7DC046, 05FA (r1 HP      Cpu0Cst     3001 INTL 20060317)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI0007:00: registered as cooling_device7
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7E7DBC7A, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
ACPI: SSDT 7E7DBFC1, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI0007:01: registered as cooling_device8
ACPI: Processor [CPU1] (supports 8 throttling states)
Marking TSC unstable due to TSC halts in idle
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ6] (25 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [TZ0] (38 C)
thermal LNXTHERM:03: registered as thermal_zone2
ACPI: Thermal Zone [TZ1] (41 C)
thermal LNXTHERM:04: registered as thermal_zone3
ACPI: Thermal Zone [TZ3] (29 C)
thermal LNXTHERM:05: registered as thermal_zone4
ACPI: Thermal Zone [TZ4] (24 C)
thermal LNXTHERM:06: registered as thermal_zone5
ACPI: Thermal Zone [TZ5] (70 C)
No dock devices found.
SCSI subsystem initialized
libata version 3.00 loaded.
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0641000
USB Universal Host Controller Interface driver v3.0
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
Clocksource tsc unstable (delta = -95685428 ns)
e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
e1000e 0000:00:19.0: setting latency timer to 64
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:68:5e:3b:04
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 4, PHY: 6, PBA No: ffffff-0ff
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0648000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00002080
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 17, io base 0x000020a0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 20, io base 0x000020c0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000020e0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002100
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 5-2: new full speed USB device using uhci_hcd and address 2
ricoh-mmc: Ricoh MMC controller found at 0000:02:06.3 [1180:0843] (rev 11)
ricoh-mmc: Controller is now disabled.
sdhci-pci 0000:02:06.2: SDHCI controller found [1180:0822] (rev 21)
sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
mmc0: SDHCI controller on PCI [0000:02:06.2] using PIO
ohci1394 0000:02:06.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
Uniform Multi-Platform E-IDE driver
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2120 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2128 irq 15
usb 5-2: configuration #1 chosen from 1 choice
ata1.00: ATA-7: SAMSUNG HS122JC, GQ100-04, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA 
ata1.01: ATAPI: MATSHITADVD-RAM UJ-852S, 1.02, max MWDMA2
ata1.00: configured for UDMA/100
ata1.01: configured for MWDMA2
ata2: port disabled. ignoring.
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HS122JC  GQ10 PQ: 0 ANSI: 5
scsi 0:0:1:0: CD-ROM            MATSHITA DVD-RAM UJ-852S  1.02 PQ: 0 ANSI: 5
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<4>Driver 'sr' needs updating - please use bus_type methods
 sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 0:0:0:0: [sda] Attached SCSI disk
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 0:0:1:0: Attached scsi generic sg1 type 5
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b249929192210]
PM: Starting manual resume from disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
udevd version 125 started
agpgart-intel 0000:00:00.0: Intel 965GM Chipset
agpgart-intel 0000:00:00.0: detected 7676K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
Bluetooth: Core ver 2.12
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [C2BF]
input: Lid Switch as /class/input/input3
ACPI: Lid Switch [C155]
ACPI: WMI: Mapper loaded
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
ACPI: Battery Slot [C23D] (battery present)
Bluetooth: Generic Bluetooth USB driver ver 0.3
usbcore: registered new interface driver btusb
ACPI: AC Adapter [C23B] (off-line)
Yenta: CardBus bridge found at 0000:02:06.0 [103c:30c9]
yenta_cardbus 0000:02:06.0: CardBus bridge, secondary bus 0000:03
yenta_cardbus 0000:02:06.0:   IO window: 0x003000-0x0030ff
yenta_cardbus 0000:02:06.0:   IO window: 0x003400-0x0034ff
yenta_cardbus 0000:02:06.0:   PREFETCH window: 0x84400000-0x847fffff
yenta_cardbus 0000:02:06.0:   MEM window: 0x80000000-0x83ffffff
pnp: the driver 'tpm_inf_pnp' has been registered
tpm_inf_pnp 00:02: Found C284 with ID IFX0102
tpm_inf_pnp 00:02: TPM found: config base 0x560, data base 0x570, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
tpm_inf_pnp 00:02: driver attached
acpi device:02: registered as cooling_device9
input: Video Bus as /class/input/input4
Yenta: ISA IRQ mask 0x0cb8, PCI irq 18
Socket status: 30000006
ACPI: Video Device [C09A] (multi-head: yes  rom: no  post: no)
Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe03fffff
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
iwlagn: Copyright(c) 2003-2008 Intel Corporation
iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:10:00.0: setting latency timer to 64
iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
iwlagn: Tunable channels: 11 802.11bg, 13 802.11a channels
iwlagn 0000:10:00.0: PCI INT A disabled
phy0: Selected rate control algorithm 'iwl-agn-rs'
input: PS/2 Generic Mouse as /class/input/input5
input: PC Speaker as /class/input/input6
iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04711/0xa00000
input: SynPS/2 Synaptics TouchPad as /class/input/input7
EXT3 FS on dm-1, internal journal
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2097144k swap on /dev/mapper/main-swap.  Priority:-1 extents:1 across:2097144k
iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:10:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
firmware: requesting iwlwifi-4965-2.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
wlan0: authenticate with AP 00:14:c1:38:e5:15
wlan0: authenticated
wlan0: associate with AP 00:14:c1:38:e5:15
wlan0: RX AssocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=1)
wlan0: associated
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Bluetooth: L2CAP ver 2.10
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
sysfs: duplicate filename 'vcs1' can not be created
Modules linked in: rfcomm l2cap ipv6 ext2 coretemp acpi_cpufreq loop joydev snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss arc4 snd_seq_midi ecb snd_rawmidi snd_seq_midi_event pcmcia iwlagn snd_seq iwlcore snd_timer snd_seq_device rfkill video snd tpm_infineon yenta_socket led_class tpm rsrc_nonstatic output mac80211 tpm_bios ac pcspkr btusb soundcore snd_page_alloc pcmcia_core container evdev cfg80211 iTCO_wdt battery wmi psmouse serio_raw button bluetooth intel_agp ext3 jbd mbcache sha256_generic aes_x86_64 aes_generic cbc dm_crypt crypto_blkcipher dm_mirror dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod piix ata_piix ide_pci_generic ide_core ohci1394 sdhci_pci sdhci ieee1394 mmc_core ricoh_mmc e1000e uhci_hcd ata_generic ehci_hcd libata scsi_mod dock thermal processor fan thermal_sys
Pid: 3627, comm: getty Not tainted 2.6.27-rc4 #56

Call Trace:
 [<ffffffff80237429>] warn_slowpath+0xae/0xd7
 [<ffffffff8043690f>] ? _spin_unlock_irq+0x9/0xc
 [<ffffffff80232b83>] ? finish_task_switch+0x38/0x8f
 [<ffffffff80434edb>] ? thread_return+0x9a/0xc8
 [<ffffffff8030a8f2>] ? blk_unplug+0x12/0x14
 [<ffffffff8031d72c>] ? string+0x3d/0xa1
 [<ffffffff803186a9>] ? idr_get_empty_slot+0x153/0x22a
 [<ffffffff802e1530>] ? sysfs_ilookup_test+0x0/0x14
 [<ffffffff802e1530>] ? sysfs_ilookup_test+0x0/0x14
 [<ffffffff80436932>] ? _spin_unlock+0x9/0xb
 [<ffffffff802aac90>] ? ifind+0x59/0x84
 [<ffffffff802e1530>] ? sysfs_ilookup_test+0x0/0x14
 [<ffffffff802e173f>] ? sysfs_find_dirent+0x1c/0x31
 [<ffffffff802e18f2>] sysfs_add_one+0x35/0x3d
 [<ffffffff802e1ebd>] create_dir+0x58/0x87
 [<ffffffff802e1f24>] sysfs_create_dir+0x38/0x4f
 [<ffffffff803194f6>] kobject_add_internal+0xdb/0x199
 [<ffffffff80319680>] kobject_add_varg+0x41/0x4d
 [<ffffffff80319791>] kobject_add+0x89/0x8b
 [<ffffffff802728d5>] ? get_page_from_freelist+0x41e/0x5f1
 [<ffffffff80319395>] ? kobject_get+0x1a/0x22
 [<ffffffff803883bf>] ? get_device+0x17/0x1f
 [<ffffffff80388ca7>] device_add+0xf1/0x651
 [<ffffffff804266ea>] ? klist_init+0x35/0x47
 [<ffffffff80389220>] device_register+0x19/0x1d
 [<ffffffff803892c1>] device_create_vargs+0x9d/0xcb
 [<ffffffff8038933a>] device_create+0x4b/0x4d
 [<ffffffff8022af34>] ? __wake_up+0x43/0x4f
 [<ffffffff80370194>] ? tty_ldisc_enable+0x2b/0x2d
 [<ffffffff8037897f>] ? vc_allocate+0x15/0x15b
 [<ffffffff8024da24>] ? down+0x33/0x3b
 [<ffffffff80372931>] vcs_make_sysfs+0x35/0x66
 [<ffffffff80378b76>] con_open+0xb1/0xc2
 [<ffffffff8036c865>] tty_open+0x1d0/0x30b
 [<ffffffff8029a949>] chrdev_open+0x15a/0x179
 [<ffffffff8029a7ef>] ? chrdev_open+0x0/0x179
 [<ffffffff802968b7>] __dentry_open+0x13a/0x24c
 [<ffffffff80296a7e>] nameidata_to_filp+0x2e/0x40
 [<ffffffff802a1ac7>] do_filp_open+0x3b4/0x7a1
 [<ffffffff8029b1be>] ? cp_new_stat+0xe2/0xef
 [<ffffffff80228f4b>] ? need_resched+0x1e/0x28
 [<ffffffff80434f93>] ? _cond_resched+0x9/0x38
 [<ffffffff80436932>] ? _spin_unlock+0x9/0xb
 [<ffffffff802acad7>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802966b9>] do_sys_open+0x53/0xda
 [<ffffffff80296769>] sys_open+0x1b/0x1d
 [<ffffffff8020c1db>] system_call_fastpath+0x16/0x1b

---[ end trace 449db3636c4575a1 ]---
kobject_add_internal failed for vcs1 with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 3627, comm: getty Tainted: G        W 2.6.27-rc4 #56

Call Trace:
 [<ffffffff8031926d>] ? kobject_put+0x47/0x4b
 [<ffffffff8031959b>] kobject_add_internal+0x180/0x199
 [<ffffffff80319680>] kobject_add_varg+0x41/0x4d
 [<ffffffff80319791>] kobject_add+0x89/0x8b
 [<ffffffff802728d5>] ? get_page_from_freelist+0x41e/0x5f1
 [<ffffffff80319395>] ? kobject_get+0x1a/0x22
 [<ffffffff803883bf>] ? get_device+0x17/0x1f
 [<ffffffff80388ca7>] device_add+0xf1/0x651
 [<ffffffff804266ea>] ? klist_init+0x35/0x47
 [<ffffffff80389220>] device_register+0x19/0x1d
 [<ffffffff803892c1>] device_create_vargs+0x9d/0xcb
 [<ffffffff8038933a>] device_create+0x4b/0x4d
 [<ffffffff8022af34>] ? __wake_up+0x43/0x4f
 [<ffffffff80370194>] ? tty_ldisc_enable+0x2b/0x2d
 [<ffffffff8037897f>] ? vc_allocate+0x15/0x15b
 [<ffffffff8024da24>] ? down+0x33/0x3b
 [<ffffffff80372931>] vcs_make_sysfs+0x35/0x66
 [<ffffffff80378b76>] con_open+0xb1/0xc2
 [<ffffffff8036c865>] tty_open+0x1d0/0x30b
 [<ffffffff8029a949>] chrdev_open+0x15a/0x179
 [<ffffffff8029a7ef>] ? chrdev_open+0x0/0x179
 [<ffffffff802968b7>] __dentry_open+0x13a/0x24c
 [<ffffffff80296a7e>] nameidata_to_filp+0x2e/0x40
 [<ffffffff802a1ac7>] do_filp_open+0x3b4/0x7a1
 [<ffffffff8029b1be>] ? cp_new_stat+0xe2/0xef
 [<ffffffff80228f4b>] ? need_resched+0x1e/0x28
 [<ffffffff80434f93>] ? _cond_resched+0x9/0x38
 [<ffffffff80436932>] ? _spin_unlock+0x9/0xb
 [<ffffffff802acad7>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802966b9>] do_sys_open+0x53/0xda
 [<ffffffff80296769>] sys_open+0x1b/0x1d
 [<ffffffff8020c1db>] system_call_fastpath+0x16/0x1b

------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
sysfs: duplicate filename 'vcsa1' can not be created
Modules linked in: rfcomm l2cap ipv6 ext2 coretemp acpi_cpufreq loop joydev snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss arc4 snd_seq_midi ecb snd_rawmidi snd_seq_midi_event pcmcia iwlagn snd_seq iwlcore snd_timer snd_seq_device rfkill video snd tpm_infineon yenta_socket led_class tpm rsrc_nonstatic output mac80211 tpm_bios ac pcspkr btusb soundcore snd_page_alloc pcmcia_core container evdev cfg80211 iTCO_wdt battery wmi psmouse serio_raw button bluetooth intel_agp ext3 jbd mbcache sha256_generic aes_x86_64 aes_generic cbc dm_crypt crypto_blkcipher dm_mirror dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod piix ata_piix ide_pci_generic ide_core ohci1394 sdhci_pci sdhci ieee1394 mmc_core ricoh_mmc e1000e uhci_hcd ata_generic ehci_hcd libata scsi_mod dock thermal processor fan thermal_sys
Pid: 3627, comm: getty Tainted: G        W 2.6.27-rc4 #56

Call Trace:
 [<ffffffff80237429>] warn_slowpath+0xae/0xd7
 [<ffffffff8024d8cd>] ? down_trylock+0x2d/0x34
 [<ffffffff80436932>] ? _spin_unlock+0x9/0xb
 [<ffffffff8031d72c>] ? string+0x3d/0xa1
 [<ffffffff803186a9>] ? idr_get_empty_slot+0x153/0x22a
 [<ffffffff802e1530>] ? sysfs_ilookup_test+0x0/0x14
 [<ffffffff802e1530>] ? sysfs_ilookup_test+0x0/0x14
 [<ffffffff80436932>] ? _spin_unlock+0x9/0xb
 [<ffffffff802aac90>] ? ifind+0x59/0x84
 [<ffffffff802e1530>] ? sysfs_ilookup_test+0x0/0x14
 [<ffffffff802e173f>] ? sysfs_find_dirent+0x1c/0x31
 [<ffffffff802e18f2>] sysfs_add_one+0x35/0x3d
 [<ffffffff802e1ebd>] create_dir+0x58/0x87
 [<ffffffff802e1f24>] sysfs_create_dir+0x38/0x4f
 [<ffffffff803194f6>] kobject_add_internal+0xdb/0x199
 [<ffffffff80319680>] kobject_add_varg+0x41/0x4d
 [<ffffffff80319791>] kobject_add+0x89/0x8b
 [<ffffffff802728d5>] ? get_page_from_freelist+0x41e/0x5f1
 [<ffffffff80319395>] ? kobject_get+0x1a/0x22
 [<ffffffff803883bf>] ? get_device+0x17/0x1f
 [<ffffffff80388ca7>] device_add+0xf1/0x651
 [<ffffffff804266ea>] ? klist_init+0x35/0x47
 [<ffffffff80389220>] device_register+0x19/0x1d
 [<ffffffff803892c1>] device_create_vargs+0x9d/0xcb
 [<ffffffff8038933a>] device_create+0x4b/0x4d
 [<ffffffff8022af34>] ? __wake_up+0x43/0x4f
 [<ffffffff80370194>] ? tty_ldisc_enable+0x2b/0x2d
 [<ffffffff8037897f>] ? vc_allocate+0x15/0x15b
 [<ffffffff8024da24>] ? down+0x33/0x3b
 [<ffffffff8037295e>] vcs_make_sysfs+0x62/0x66
 [<ffffffff80378b76>] con_open+0xb1/0xc2
 [<ffffffff8036c865>] tty_open+0x1d0/0x30b
 [<ffffffff8029a949>] chrdev_open+0x15a/0x179
 [<ffffffff8029a7ef>] ? chrdev_open+0x0/0x179
 [<ffffffff802968b7>] __dentry_open+0x13a/0x24c
 [<ffffffff80296a7e>] nameidata_to_filp+0x2e/0x40
 [<ffffffff802a1ac7>] do_filp_open+0x3b4/0x7a1
 [<ffffffff8029b1be>] ? cp_new_stat+0xe2/0xef
 [<ffffffff80228f4b>] ? need_resched+0x1e/0x28
 [<ffffffff80434f93>] ? _cond_resched+0x9/0x38
 [<ffffffff80436932>] ? _spin_unlock+0x9/0xb
 [<ffffffff802acad7>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802966b9>] do_sys_open+0x53/0xda
 [<ffffffff80296769>] sys_open+0x1b/0x1d
 [<ffffffff8020c1db>] system_call_fastpath+0x16/0x1b

---[ end trace 449db3636c4575a1 ]---
kobject_add_internal failed for vcsa1 with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 3627, comm: getty Tainted: G        W 2.6.27-rc4 #56

Call Trace:
 [<ffffffff8031926d>] ? kobject_put+0x47/0x4b
 [<ffffffff8031959b>] kobject_add_internal+0x180/0x199
 [<ffffffff80319680>] kobject_add_varg+0x41/0x4d
 [<ffffffff80319791>] kobject_add+0x89/0x8b
 [<ffffffff802728d5>] ? get_page_from_freelist+0x41e/0x5f1
 [<ffffffff80319395>] ? kobject_get+0x1a/0x22
 [<ffffffff803883bf>] ? get_device+0x17/0x1f
 [<ffffffff80388ca7>] device_add+0xf1/0x651
 [<ffffffff804266ea>] ? klist_init+0x35/0x47
 [<ffffffff80389220>] device_register+0x19/0x1d
 [<ffffffff803892c1>] device_create_vargs+0x9d/0xcb
 [<ffffffff8038933a>] device_create+0x4b/0x4d
 [<ffffffff8022af34>] ? __wake_up+0x43/0x4f
 [<ffffffff80370194>] ? tty_ldisc_enable+0x2b/0x2d
 [<ffffffff8037897f>] ? vc_allocate+0x15/0x15b
 [<ffffffff8024da24>] ? down+0x33/0x3b
 [<ffffffff8037295e>] vcs_make_sysfs+0x62/0x66
 [<ffffffff80378b76>] con_open+0xb1/0xc2
 [<ffffffff8036c865>] tty_open+0x1d0/0x30b
 [<ffffffff8029a949>] chrdev_open+0x15a/0x179
 [<ffffffff8029a7ef>] ? chrdev_open+0x0/0x179
 [<ffffffff802968b7>] __dentry_open+0x13a/0x24c
 [<ffffffff80296a7e>] nameidata_to_filp+0x2e/0x40
 [<ffffffff802a1ac7>] do_filp_open+0x3b4/0x7a1
 [<ffffffff8029b1be>] ? cp_new_stat+0xe2/0xef
 [<ffffffff80228f4b>] ? need_resched+0x1e/0x28
 [<ffffffff80434f93>] ? _cond_resched+0x9/0x38
 [<ffffffff80436932>] ? _spin_unlock+0x9/0xb
 [<ffffffff802acad7>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802966b9>] do_sys_open+0x53/0xda
 [<ffffffff80296769>] sys_open+0x1b/0x1d
 [<ffffffff8020c1db>] system_call_fastpath+0x16/0x1b

wlan0: no IPv6 routers present
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level CPU
   groups: 0-1
   domain 2: span 0-1 level NODE
    groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level CPU
   groups: 0-1
   domain 2: span 0-1 level NODE
    groups: 0-1

--Boundary-00=_979sIX8yhtbk08M--
