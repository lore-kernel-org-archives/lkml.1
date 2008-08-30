Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYH3Pgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYH3Pgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 11:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYH3Pgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 11:36:38 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:12307 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbYH3Pge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 11:36:34 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [regression] usb: sometimes dead keyboard after boot (with debug log)
Date: Sat, 30 Aug 2008 17:36:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0808261626140.2139-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808261626140.2139-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7jWuI8r9hNYpVO6"
Message-Id: <200808301736.27377.elendil@planet.nl>
X-OriginalArrivalTime: 30 Aug 2008 15:36:29.0980 (UTC) FILETIME=[2C44C5C0:01C90AB6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_7jWuI8r9hNYpVO6
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 26 August 2008, Alan Stern wrote:
> > Attached a full diff between dmesg from two consecutive boots: first
> > without keyboard; after reboot the keyboard is detected. The actual
> > difference is fairly small and clearly shows that usb 3-1 is not
> > handed off correctly, probably due to a small difference in timing.
> >
> > Note that I've never seen this problem with earlier kernels.
>
> I can't tell exactly what's going on because your usbcore module wasn't
> built with CONFIG_USB_DEBUG enabled.

I got lucky on the second boot with -rc5 and USB_DEBUG enabled.
Attached the output of dmesg. After this boot the keyboard was dead and 
the telltale "reset low speed USB device" message is present.

Cheers,
FJP


--Boundary-00=_7jWuI8r9hNYpVO6
Content-Type: text/plain;
  charset="iso 8859-15";
  name="dmesg_no-keyboard_debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_no-keyboard_debug"

Linux version 2.6.27-rc5 (root@faramir) (gcc version 4.3.1 (Debian 4.3.1-9) ) #69 SMP Sat Aug 30 16:44:17 CEST 2008
Command line: root=/dev/mapper/main-root ro vga=791 quiet
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f674000 (usable)
 BIOS-e820: 000000007f674000 - 000000007f6e9000 (ACPI NVS)
 BIOS-e820: 000000007f6e9000 - 000000007f6ec000 (usable)
 BIOS-e820: 000000007f6ec000 - 000000007f6ff000 (ACPI data)
 BIOS-e820: 000000007f6ff000 - 000000007f700000 (usable)
last_pfn = 0x7f700 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
 0000000000 - 007f600000 page 2M
 007f600000 - 007f700000 page 4k
kernel direct mapping tables up to 7f700000 @ 8000-c000
last_map_addr: 7f700000 end: 7f700000
RAMDISK: 37d18000 - 37fefa92
DMI 2.3 present.
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT 7F6FDE48, 0058 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
ACPI: FACP 7F6FCF10, 0074 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
ACPI: DSDT 7F6F7010, 4348 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
ACPI: FACS 7F6E2C40, 0040
ACPI: APIC 7F6FCE10, 0078 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
ACPI: WDDT 7F6F6F90, 0040 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
ACPI: MCFG 7F6F6F10, 003C (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
ACPI: ASF! 7F6FCD10, 00A6 (r32 INTEL  D945GCZ       FF9 MSFT  1000013)
ACPI: HPET 7F6F6E90, 0038 (r1 INTEL  D945GCZ       FF9 MSFT  1000013)
ACPI: SSDT 7F6FDC10, 01BC (r1 INTEL     CpuPm      FF9 MSFT  1000013)
ACPI: SSDT 7F6FDA10, 0175 (r1 INTEL   Cpu0Ist      FF9 MSFT  1000013)
ACPI: SSDT 7F6FD810, 0175 (r1 INTEL   Cpu1Ist      FF9 MSFT  1000013)
ACPI: SSDT 7F6FD610, 0175 (r1 INTEL   Cpu2Ist      FF9 MSFT  1000013)
ACPI: SSDT 7F6FD410, 0175 (r1 INTEL   Cpu3Ist      FF9 MSFT  1000013)
ACPI: SSDT 7F6F6E10, 002F (r1 INTEL  SetupVar      FF9 MSFT  1000013)
ACPI: TCPA 7F6E4D90, 0032 (r1 INTEL  TIANO           2 MSFT  1000013)
No NUMA configuration found
Faking a node at 0000000000000000-000000007f700000
Bootmem setup node 0 0000000000000000-000000007f700000
  NODE_DATA [0000000000001000 - 0000000000004fff]
  bootmap [000000000000a000 -  0000000000019edf] pages 10
(6 early reservations) ==> bootmem [0000000000 - 007f700000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 000074e4e0]    TEXT DATA BSS ==> [0000200000 - 000074e4e0]
  #3 [0037d18000 - 0037fefa92]          RAMDISK ==> [0037d18000 - 0037fefa92]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
found SMP MP-table at [ffff8800000fe680] 000fe680
 [ffffe20000000000-ffffe20001ffffff] PMD -> [ffff880001200000-ffff8800031fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0007f674
    0: 0x0007f6e9 -> 0x0007f6ec
    0: 0x0007f6ff -> 0x0007f700
On node 0 totalpages: 521751
  DMA zone: 2474 pages, LIFO batch:0
  DMA32 zone: 509660 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 000000007f674000 - 000000007f6e9000
PM: Registered nosave memory: 000000007f6ec000 - 000000007f6ff000
Allocating PCI resources starting at 80000000 (gap: 7f700000:80900000)
PERCPU: Allocating 47648 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 512134
Policy zone: DMA32
Kernel command line: root=/dev/mapper/main-root ro vga=791 quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Detected 3199.878 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2045500k/2087936k available (2287k kernel code, 41504k reserved, 1439k data, 368k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 6399.75 BogoMIPS (lpj=12799512)
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0:               Intel(R) Pentium(R) D CPU 3.20GHz stepping 07
Using local APIC timer interrupts.
APIC timer calibration result 12499515
Detected 12.499 MHz APIC timer.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6399.97 BogoMIPS (lpj=12799952)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1:               Intel(R) Pentium(R) D CPU 3.20GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (12799.73 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
net_namespace: 1552 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub without MMCONFIG support.
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:01:00.3: PME# supported from D0 D3hot D3cold
pci 0000:01:00.3: PME# disabled
pci 0000:01:00.4: PME# supported from D0 D3hot D3cold
pci 0000:01:00.4: PME# disabled
PCI: bridge 0000:00:1c.0 io port: [1000, 1fff]
PCI: bridge 0000:00:1c.0 32bit mmio: [90000000, 901fffff]
PCI: bridge 0000:00:1c.2 32bit mmio: [90300000, 903fffff]
PCI: bridge 0000:00:1c.3 32bit mmio: [90400000, 904fffff]
PCI: bridge 0000:00:1c.4 32bit mmio: [90500000, 905fffff]
PCI: bridge 0000:00:1c.5 32bit mmio: [90600000, 906fffff]
pci 0000:00:1e.0: transparent bridge
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 *9 10 11 12)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: parse allocated resources
pnp 00:00:   add io  0xcf8-0xcff flags 0x1
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: parse allocated resources
pnp 00:01:   add mem 0xf0000000-0xf3ffffff flags 0x0
pnp 00:01:   add mem 0xfed13000-0xfed13fff flags 0x0
pnp 00:01:   add mem 0xfed14000-0xfed17fff flags 0x0
pnp 00:01:   add mem 0xfed18000-0xfed18fff flags 0x0
pnp 00:01:   add mem 0xfed19000-0xfed19fff flags 0x0
pnp 00:01:   add mem 0xfed1c000-0xfed1ffff flags 0x0
pnp 00:01:   add mem 0xfed20000-0xfed3ffff flags 0x0
pnp 00:01:   add mem 0xfed45000-0xfed99fff flags 0x0
pnp 00:01:   add mem 0xc0000-0xdffff flags 0x0
pnp 00:01:   add mem 0xe0000-0xfffff flags 0x0
pnp 00:01: PNP0c02: calling quirk_system_pci_resources+0x0/0x179
pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: parse allocated resources
pnp 00:02:   add io  0x0-0xf flags 0x1
pnp 00:02:   add io  0x81-0x83 flags 0x1
pnp 00:02:   add io  0x87-0x87 flags 0x1
pnp 00:02:   add io  0x89-0x8b flags 0x1
pnp 00:02:   add io  0x8f-0x8f flags 0x1
pnp 00:02:   add io  0xc0-0xdf flags 0x1
pnp 00:02:   add dma 4 flags 0x0
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: parse allocated resources
pnp 00:03:   add io  0x70-0x71 flags 0x1
pnp 00:03:   add io  0x74-0x77 flags 0x1
pnp 00:03:   add irq 8 flags 0x1
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: parse allocated resources
pnp 00:04:   add io  0xf0-0xf0 flags 0x1
pnp 00:04:   add irq 13 flags 0x1
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: parse allocated resources
pnp 00:05:   add io  0x61-0x61 flags 0x1
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: parse allocated resources
pnp 00:06:   add io  0x500-0x53f flags 0x1
pnp 00:06:   add io  0x400-0x47f flags 0x1
pnp 00:06:   add io  0x92-0x92 flags 0x1
pnp 00:06:   add io  0x680-0x6ff flags 0x1
pnp 00:06:   add io  0x10-0x1f flags 0x1
pnp 00:06:   add io  0x72-0x73 flags 0x1
pnp 00:06:   add io  0x80-0x80 flags 0x1
pnp 00:06:   add io  0x84-0x86 flags 0x1
pnp 00:06:   add io  0x88-0x88 flags 0x1
pnp 00:06:   add io  0x8c-0x8e flags 0x1
pnp 00:06:   add io  0x90-0x9f flags 0x1
pnp 00:06: PNP0c02: calling quirk_system_pci_resources+0x0/0x179
pnp 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:07: parse allocated resources
pnp 00:07:   add mem 0xfed40000-0xfed44fff flags 0x0
pnp 00:07: PNP0c02: calling quirk_system_pci_resources+0x0/0x179
pnp 00:07: Plug and Play ACPI device, IDs PNP0c31 PNP0c02 (active)
pnp 00:08: parse allocated resources
pnp 00:08:   add io  0x60-0x60 flags 0x1
pnp 00:08:   add io  0x64-0x64 flags 0x1
pnp 00:08: PNP0c02: calling quirk_system_pci_resources+0x0/0x179
pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:09: parse allocated resources
pnp 00:09:   add io  0x3f0-0x3f5 flags 0x1
pnp 00:09:   add io  0x3f0-0x3f0 flags 0x1
pnp 00:09:   add irq 6 flags 0x1
pnp 00:09:   add dma 2 flags 0x0
pnp 00:09: parse resource options
pnp 00:09:   dependent set 0 (preferred) io  min 0x3f0 max 0x3f0 align 1 size 6 flags 0x1
pnp 00:09:   dependent set 0 (preferred) io  min 0x3f7 max 0x3f7 align 1 size 1 flags 0x1
pnp 00:09:   dependent set 0 (preferred) irq 6 flags 0x1
pnp 00:09:   dependent set 0 (preferred) dma 2 (bitmask 0x4) flags 0x0
pnp 00:09: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:0a: parse allocated resources
pnp 00:0a:   add io  0x378-0x37f flags 0x1
pnp 00:0a:   add io  0x778-0x77f flags 0x1
pnp 00:0a:   add irq 7 flags 0x1
pnp 00:0a:   add dma 0 flags 0x10000000
pnp 00:0a: parse resource options
pnp 00:0a:   dependent set 0 (preferred) io  min 0x378 max 0x378 align 1 size 8 flags 0x1
pnp 00:0a:   dependent set 0 (preferred) io  min 0x778 max 0x778 align 1 size 8 flags 0x1
pnp 00:0a:   dependent set 0 (preferred) irq 5 7 flags 0x1
pnp 00:0a:   dependent set 0 (preferred) dma 1 3 (bitmask 0xa) flags 0x0
pnp 00:0a:   dependent set 1 (preferred) io  min 0x278 max 0x278 align 1 size 8 flags 0x1
pnp 00:0a:   dependent set 1 (preferred) io  min 0x678 max 0x678 align 1 size 8 flags 0x1
pnp 00:0a:   dependent set 1 (preferred) irq 5 7 flags 0x1
pnp 00:0a:   dependent set 1 (preferred) dma 1 3 (bitmask 0xa) flags 0x0
pnp 00:0a:   dependent set 2 (preferred) io  min 0x3bc max 0x3bc align 1 size 4 flags 0x1
pnp 00:0a:   dependent set 2 (preferred) io  min 0x7bc max 0x7bc align 1 size 4 flags 0x1
pnp 00:0a:   dependent set 2 (preferred) irq 5 7 flags 0x1
pnp 00:0a:   dependent set 2 (preferred) dma 1 3 (bitmask 0xa) flags 0x0
pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (active)
pnp 00:0b: parse allocated resources
pnp 00:0b:   add io  0x3f8-0x3ff flags 0x1
pnp 00:0b:   add irq 4 flags 0x1
pnp 00:0b: parse resource options
pnp 00:0b:   dependent set 0 (preferred) io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
pnp 00:0b:   dependent set 0 (preferred) irq 4 flags 0x1
pnp 00:0b:   dependent set 1 (preferred) io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1
pnp 00:0b:   dependent set 1 (preferred) irq 4 flags 0x1
pnp 00:0b:   dependent set 2 (preferred) io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1
pnp 00:0b:   dependent set 2 (preferred) irq 3 flags 0x1
pnp 00:0b:   dependent set 3 (preferred) io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1
pnp 00:0b:   dependent set 3 (preferred) irq 3 flags 0x1
pnp 00:0b:   dependent set 4 (functional) io  min 0x100 max 0x3f8 align 8 size 8 flags 0x1
pnp 00:0b:   dependent set 4 (functional) irq 1 3 4 5 6 7 8 10 11 12 13 14 15 flags 0x1
pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0c: parse allocated resources
pnp 00:0c:   add mem 0xfec00000-0xfec000ff flags 0x0
pnp 00:0c: Plug and Play ACPI device, IDs PNP0003 (active)
pnp 00:0d: parse allocated resources
pnp 00:0d:   add mem 0xfed00000-0xfed003ff flags 0x0
pnp 00:0d: Plug and Play ACPI device, IDs PNP0103 (active)
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
system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
system 00:01: iomem range 0xc0000-0xdffff has been reserved
system 00:01: iomem range 0xe0000-0xfffff could not be reserved
system 00:01: driver attached
system 00:06: ioport range 0x500-0x53f has been reserved
system 00:06: ioport range 0x400-0x47f has been reserved
system 00:06: ioport range 0x680-0x6ff has been reserved
system 00:06: driver attached
system 00:07: iomem range 0xfed40000-0xfed44fff has been reserved
system 00:07: driver attached
system 00:08: driver attached
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
pci 0000:00:1c.0:   MEM window: 0x90000000-0x901fffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.2:   IO window: disabled
pci 0000:00:1c.2:   MEM window: 0x90300000-0x903fffff
pci 0000:00:1c.2:   PREFETCH window: disabled
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.3:   IO window: disabled
pci 0000:00:1c.3:   MEM window: 0x90400000-0x904fffff
pci 0000:00:1c.3:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.4:   IO window: disabled
pci 0000:00:1c.4:   MEM window: 0x90500000-0x905fffff
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:05
pci 0000:00:1c.5:   IO window: disabled
pci 0000:00:1c.5:   MEM window: 0x90600000-0x906fffff
pci 0000:00:1c.5:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: disabled
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 01 index 0 io port: [1000, 1fff]
bus: 01 index 1 mmio: [90000000, 901fffff]
bus: 01 index 2 mmio: [0, 0]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 mmio: [0, 0]
bus: 02 index 1 mmio: [90300000, 903fffff]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 mmio: [0, 0]
bus: 03 index 1 mmio: [90400000, 904fffff]
bus: 03 index 2 mmio: [0, 0]
bus: 03 index 3 mmio: [0, 0]
bus: 04 index 0 mmio: [0, 0]
bus: 04 index 1 mmio: [90500000, 905fffff]
bus: 04 index 2 mmio: [0, 0]
bus: 04 index 3 mmio: [0, 0]
bus: 05 index 0 mmio: [0, 0]
bus: 05 index 1 mmio: [90600000, 906fffff]
bus: 05 index 2 mmio: [0, 0]
bus: 05 index 3 mmio: [0, 0]
bus: 06 index 0 mmio: [0, 0]
bus: 06 index 1 mmio: [0, 0]
bus: 06 index 2 mmio: [0, 0]
bus: 06 index 3 io port: [0, ffff]
bus: 06 index 4 mmio: [0, ffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
Freeing initrd memory: 2910k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1220109416.516:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 4000
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f10
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.2: Performing full reset
pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.3: Performing full reset
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pcieport-driver 0000:00:1c.3: setting latency timer to 64
pcieport-driver 0000:00:1c.3: found MSI capability
pci_express 0000:00:1c.3:pcie00: allocate port service
pci_express 0000:00:1c.3:pcie02: allocate port service
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pcieport-driver 0000:00:1c.4: found MSI capability
pci_express 0000:00:1c.4:pcie00: allocate port service
pci_express 0000:00:1c.4:pcie02: allocate port service
pcieport-driver 0000:00:1c.5: setting latency timer to 64
pcieport-driver 0000:00:1c.5: found MSI capability
pci_express 0000:00:1c.5:pcie00: allocate port service
pci_express 0000:00:1c.5:pcie02: allocate port service
vesafb: framebuffer at 0x80000000, mapped to 0xffffc20000a00000, using 3072k, total 7872k
vesafb: mode is 1024x768x16, linelength=2048, pages=4
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
pnp: the driver 'serial' has been registered
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial 00:0b: driver attached
serial 0000:01:00.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
0000:01:00.3: ttyS1 at I/O 0x1020 (irq = 18) is a 16550A
brd: module loaded
pnp: the driver 'i8042 kbd' has been registered
pnp: the driver 'i8042 aux' has been registered
pnp: the driver 'i8042 kbd' has been unregistered
pnp: the driver 'i8042 aux' has been unregistered
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
pnp: the driver 'rtc_cmos' has been registered
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, hpet irqs
rtc_cmos 00:03: driver attached
cpuidle: using governor ladder
cpuidle: using governor menu
TCP bic registered
NET: Registered protocol family 17
rtc_cmos 00:03: setting system clock to 2008-08-30 15:16:57 UTC (1220109417)
Freeing unused kernel memory: 368k freed
No dock devices found.
SCSI subsystem initialized
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0x902c4000 port 0x902c4100 irq 506
ata2: SATA max UDMA/133 abar m1024@0x902c4000 port 0x902c4180 irq 506
ata3: SATA max UDMA/133 abar m1024@0x902c4000 port 0x902c4200 irq 506
ata4: SATA max UDMA/133 abar m1024@0x902c4000 port 0x902c4280 irq 506
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
ata1.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATAPI: Optiarc DVD RW AD-7170S, 1.00, max UDMA/66
ata3.00: configured for UDMA/66
ata4: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
scsi 2:0:0:0: CD-ROM            Optiarc  DVD RW AD-7170S  1.00 PQ: 0 ANSI: 5
processor ACPI0007:00: registered as cooling_device0
processor ACPI0007:01: registered as cooling_device1
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 > sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
udevd version 125 started
Uniform Multi-Platform E-IDE driver
input: PC Speaker as /class/input/input0
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 2ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
Floppy drive(s): fd0 is 1.44M
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
FDC 0 is a post-1991 82077
input: Power Button (FF) as /class/input/input1
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27-rc5 uhci_hcd
usb usb1: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input2
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
ACPI: Sleep Button (CM) [SLPB]
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27-rc5 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.1
agpgart-intel 0000:00:00.0: Intel 945G Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 2:0:0:0: Attached scsi generic sg1 type 5
pnp: the driver 'parport_pc' has been registered
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
uhci_hcd 0000:00:1d.2: port 1 portsc 01ab,00
hub 3-0:1.0: port 1: status 0301 change 0003
parport0: Printer, HEWLETT-PACKARD PHOTOSMART P1100
parport_pc 00:0a: driver attached
drivers/usb/core/inode.c: creating file '001'
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27-rc5 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.2
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.3: Performing full reset
uhci_hcd 0000:00:1d.3: supports USB remote wakeup
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002020
usb usb4: default language 0x0409
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
hub 3-0:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
uhci_hcd 0000:00:1d.3: port 1 portsc 01ab,00
hub 4-0:1.0: port 1: status 0301 change 0003
usb 3-1: new low speed USB device using uhci_hcd and address 2
drivers/usb/core/inode.c: creating file '001'
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27-rc5 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.3
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
usb 3-1: skipped 1 descriptor after interface
usb 3-1: skipped 1 descriptor after interface
usb 3-1: default language 0x0409
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file '005'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 23, io mem 0x902c4400
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
usb 3-1: uevent
usb 3-1: usb_probe_device
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: uhci_result_common: failed with status 440000
usb 3-1: can't set config #1, error -71
drivers/usb/core/inode.c: creating file '002'
usb 3-1: New USB device found, idVendor=05a4, idProduct=9841
usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 3-1: Product: USB Compliant Keyboard
hub 4-0:1.0: state 7 ports 2 chg 0002 evt 0000
uhci_hcd 0000:00:1d.3: port 1 portsc 0082,00
hub 4-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: default language 0x0409
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
usb 5-0:1.0: uevent
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 20ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001403 POWER sig=k CSC CONNECT
hub 5-0:1.0: port 5: status 0501 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port 7 status 001403 POWER sig=k CSC CONNECT
hub 5-0:1.0: port 7: status 0501 change 0001
hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
drivers/usb/core/inode.c: creating file '001'
usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: EHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27-rc5 ehci_hcd
usb usb5: SerialNumber: 0000:00:1d.7
e1000e 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:01:00.0: setting latency timer to 64
piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x01)
PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
piix 0000:00:1f.1: IDE port disabled
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x20b0-0x20b7
Probing IDE interface ide0...
hub 5-0:1.0: state 7 ports 8 chg 00a0 evt 0000
hub 5-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1d.7: port 5 low speed --> companion
e1000e 0000:01:00.0: Warning: detected DSPD enabled in EEPROM
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
hub 5-0:1.0: port 7, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1d.7: port 7 low speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 7 status 003002 POWER OWNER sig=se0 CSC
hub 5-0:1.0: state 7 ports 8 chg 0000 evt fe80
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:1d.2: port 1 portsc 01ab,00
hub 3-0:1.0: port 1, status 0301, change 0003, 1.5 Mb/s
0000:01:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:76:04:ff:09
0000:01:00.0: eth0: Intel(R) PRO/1000 Network Connection
0000:01:00.0: eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
usb usb1: suspend_rh (auto-stop)
usb usb2: suspend_rh (auto-stop)
usb 3-1: reset low speed USB device using uhci_hcd and address 2
hda: LITE-ON DVD SOHD-16P9SV, ATAPI CD/DVD-ROM drive
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:1d.3: port 1 portsc 01a3,00
hub 4-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
usb 4-1: new low speed USB device using uhci_hcd and address 2
usb 4-1: skipped 1 descriptor after interface
usb 4-1: default language 0x0409
usb 4-1: uevent
usb 4-1: usb_probe_device
usb 4-1: configuration #1 chosen from 1 choice
usb 4-1: adding 4-1:1.0 (config #1, interface 0)
usb 4-1:1.0: uevent
drivers/usb/core/inode.c: creating file '002'
usb 4-1: New USB device found, idVendor=046d, idProduct=c50d
usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-1: Product: USB Receiver
usb 4-1: Manufacturer: Logitech
usbcore: registered new interface driver hiddev
usbhid 4-1:1.0: usb_probe_interface
usbhid 4-1:1.0: usb_probe_interface - got id
input: Logitech USB Receiver as /class/input/input3
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.3-1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
usb usb1: suspend_rh
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
usb usb2: suspend_rh
hda: ATAPI 48X DVD-ROM drive, 254kB Cache
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
Adding 979924k swap on /dev/sda6.  Priority:-1 extents:1 across:979924k
EXT3 FS on dm-0, internal journal
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
i2c-adapter i2c-0: lm85: Detected SMSC chip
i2c-adapter i2c-0: lm85: Unrecognized version/stepping 0x68 Defaulting to Generic LM85.
fuse init (API version 7.9)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Bridge firewalling registered
br0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
device eth0 entered promiscuous mode
ADDRCONF(NETDEV_UP): eth0: link is not ready
0000:01:00.0: eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
0000:01:00.0: eth0: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
br0: port 1(eth0) entering learning state
br0: topology change detected, propagating
br0: port 1(eth0) entering forwarding state
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
br0: no IPv6 routers present
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
eth0: no IPv6 routers present
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
device vbox0 entered promiscuous mode
br0: port 2(vbox0) entering learning state
br0: topology change detected, propagating
br0: port 2(vbox0) entering forwarding state
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
uhci_hcd 0000:00:1d.3: release dev 2 ep81-INT, period 8, phase 4, 118 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
vbox0: no IPv6 routers present

--Boundary-00=_7jWuI8r9hNYpVO6--
