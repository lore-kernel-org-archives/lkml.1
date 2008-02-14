Return-Path: <linux-kernel-owner+w=401wt.eu-S1763963AbYBNUit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763963AbYBNUit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYBNUil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:38:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:46749 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754395AbYBNUii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:38:38 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/ceIRPsWzcdOIAMGNETFW1SbeGwlj5Rnh3yxa9f/
	ebZixrYCd3aMJ6
Date: Thu, 14 Feb 2008 21:38:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [ACPI X86_64] 2.6.24 doesn't boot on a Core 2 Duo
Message-ID: <Pine.LNX.4.64.0802142121040.7981@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

2.6.24.2 fails to boot on the above system with an Intel DQ35JO 
motherboard, as do Debian install kernels - both stock etch amd64 and 
updated image from Kenshi Muto (kmuto.jp). The only way to boot was with 
"acpi=off". Whereas ubuntu 7.10 amd64 2.6.22-based boot-CD boots without 
problems. Below is ubuntu's dmesg with a place marked where Debian and 
self-compiled vanilla 2.6.24.2 kernels hang. Tried "pci=noacpi", 
"acpi=noirq", "noapic", "nolapic", "pci=routeirq" with no success.

Thanks
Guennadi
---
Guennadi Liakhovetski


[    0.000000] Linux version 2.6.22-14-generic (buildd@crested) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Sun Oct 14 21:45:15 GMT 2007 (Ubuntu 2.6.22-14.46-generic)
[    0.000000] Command line: BOOT_IMAGE=/casper/vmlinuz file=/cdrom/preseed/ubuntu.seed boot=casper initrd=/casper/initrd.gz quiet splash --
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007c0fa000 (usable)
[    0.000000]  BIOS-e820: 000000007c0fa000 - 000000007c191000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c191000 - 000000007d1a3000 (usable)
[    0.000000]  BIOS-e820: 000000007d1a3000 - 000000007d1a5000 (reserved)
[    0.000000]  BIOS-e820: 000000007d1a5000 - 000000007d27b000 (usable)
[    0.000000]  BIOS-e820: 000000007d27b000 - 000000007d2ce000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007d2ce000 - 000000007d2de000 (usable)
[    0.000000]  BIOS-e820: 000000007d2de000 - 000000007d2e5000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007d2e5000 - 000000007d2e7000 (usable)
[    0.000000]  BIOS-e820: 000000007d2e7000 - 000000007d2f2000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007d2f2000 - 000000007d2f3000 (usable)
[    0.000000]  BIOS-e820: 000000007d2f3000 - 000000007d2ff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007d2ff000 - 000000007d300000 (usable)
[    0.000000]  BIOS-e820: 000000007d300000 - 000000007e000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 508154) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 508305, 512419) 2 entries of 3200 used
[    0.000000] Entering add_active_range(0, 512421, 512635) 3 entries of 3200 used
[    0.000000] Entering add_active_range(0, 512718, 512734) 4 entries of 3200 used
[    0.000000] Entering add_active_range(0, 512741, 512743) 5 entries of 3200 used
[    0.000000] Entering add_active_range(0, 512754, 512755) 6 entries of 3200 used
[    0.000000] Entering add_active_range(0, 512767, 512768) 7 entries of 3200 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP signature @ 0xFFFF8100000FE020 checksum 0
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT 7D2FD038, 006C (r1 INTEL  DQ3510J       2F5       1000013)
[    0.000000] ACPI: FACP 7D2FC000, 0074 (r1 INTEL  DQ3510J       2F5 MSFT  1000013)
[    0.000000] ACPI: DSDT 7D2F8000, 3D3A (r1 INTEL  DQ3510J       2F5 MSFT  1000013)
[    0.000000] ACPI: FACS 7D287000, 0040
[    0.000000] ACPI: APIC 7D2F7000, 0078 (r1 INTEL  DQ3510J       2F5 MSFT  1000013)
[    0.000000] ACPI: WDDT 7D2F6000, 0040 (r1 INTEL  DQ3510J       2F5 MSFT  1000013)
[    0.000000] ACPI: MCFG 7D2F5000, 003C (r1 INTEL  DQ3510J       2F5 MSFT  1000013)
[    0.000000] ACPI: ASF! 7D2F4000, 00A6 (r32 INTEL  DQ3510J       2F5 MSFT  1000013)
[    0.000000] ACPI: HPET 7D2F3000, 0038 (r1 INTEL  DQ3510J       2F5 MSFT  1000013)
[    0.000000] ACPI: ASPT 7D2F1000, 002C (r1 INTEL  DQ3510J       2F5 MSFT  1000013)
[    0.000000] ACPI: WDTT 7D2F0000, 02CC (r1 INTEL  DQ3510J       2F5 MSFT  1000013)
[    0.000000] ACPI: SSDT 7D2EF000, 0204 (r1 INTEL     CpuPm      2F5 MSFT  1000013)
[    0.000000] ACPI: SSDT 7D2EE000, 0175 (r1 INTEL   Cpu0Ist      2F5 MSFT  1000013)
[    0.000000] ACPI: SSDT 7D2ED000, 0175 (r1 INTEL   Cpu1Ist      2F5 MSFT  1000013)
[    0.000000] ACPI: SSDT 7D2EC000, 0175 (r1 INTEL   Cpu2Ist      2F5 MSFT  1000013)
[    0.000000] ACPI: SSDT 7D2EB000, 0175 (r1 INTEL   Cpu3Ist      2F5 MSFT  1000013)
[    0.000000] ACPI: SSDT 7D2EA000, 00DD (r1 INTEL   Cpu0Cst      2F5 MSFT  1000013)
[    0.000000] ACPI: SSDT 7D2E9000, 00DD (r1 INTEL   Cpu1Cst      2F5 MSFT  1000013)
[    0.000000] ACPI: SSDT 7D2E8000, 00DD (r1 INTEL   Cpu2Cst      2F5 MSFT  1000013)
[    0.000000] ACPI: SSDT 7D2E7000, 00DD (r1 INTEL   Cpu3Cst      2F5 MSFT  1000013)
[    0.000000] ACPI: TCPA 7D27B000, 0032 (r2 INTEL  TIANO           2 MSFT  1000013)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007d300000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 508154) 1 entries of 3200 used
[    0.000000] Entering add_active_range(0, 508305, 512419) 2 entries of 3200 used
[    0.000000] Entering add_active_range(0, 512421, 512635) 3 entries of 3200 used
[    0.000000] Entering add_active_range(0, 512718, 512734) 4 entries of 3200 used
[    0.000000] Entering add_active_range(0, 512741, 512743) 5 entries of 3200 used
[    0.000000] Entering add_active_range(0, 512754, 512755) 6 entries of 3200 used
[    0.000000] Entering add_active_range(0, 512767, 512768) 7 entries of 3200 used
[    0.000000] Bootmem setup node 0 0000000000000000-000000007d300000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   508154
[    0.000000]     0:   508305 ->   512419
[    0.000000]     0:   512421 ->   512635
[    0.000000]     0:   512718 ->   512734
[    0.000000]     0:   512741 ->   512743
[    0.000000]     0:   512754 ->   512755
[    0.000000]     0:   512767 ->   512768
[    0.000000] On node 0 totalpages: 512405
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1125 pages reserved
[    0.000000]   DMA zone: 2818 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6954 pages used for memmap
[    0.000000]   DMA32 zone: 501452 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
[    0.000000] swsusp: Registered nosave memory region: 000000007c0fa000 - 000000007c191000
[    0.000000] swsusp: Registered nosave memory region: 000000007d1a3000 - 000000007d1a5000
[    0.000000] swsusp: Registered nosave memory region: 000000007d27b000 - 000000007d2ce000
[    0.000000] swsusp: Registered nosave memory region: 000000007d2de000 - 000000007d2e5000
[    0.000000] swsusp: Registered nosave memory region: 000000007d2e7000 - 000000007d2f2000
[    0.000000] swsusp: Registered nosave memory region: 000000007d2f3000 - 000000007d2ff000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7e000000:72000000)
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PERCPU: Allocating 34696 bytes of per cpu data
[    0.000000] Built 1 zonelists.  Total pages: 504270
[    0.000000] Kernel command line: BOOT_IMAGE=/casper/vmlinuz file=/cdrom/preseed/ubuntu.seed boot=casper initrd=/casper/initrd.gz quiet splash --
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   63.535504] time.c: Detected 2657.326 MHz processor.
[   63.536503] Console: colour VGA+ 80x25
[   63.536521] Checking aperture...
[   63.536528] Calgary: detecting Calgary via BIOS EBDA area
[   63.536534] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[   63.552514] Memory: 2009108k/2051072k available (2274k kernel code, 40512k reserved, 1181k data, 296k init)
[   63.552546] SLUB: Genslabs=23, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
[   63.629788] Calibrating delay using timer specific routine.. 5318.16 BogoMIPS (lpj=10636328)
[   63.629811] Security Framework v1.0.0 initialized
[   63.629817] SELinux:  Disabled at boot.
[   63.629950] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   63.630951] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   63.631451] Mount-cache hash table entries: 256
[   63.631553] CPU: L1 I cache: 32K, L1 D cache: 32K
[   63.631556] CPU: L2 cache: 4096K
[   63.631557] CPU 0/0 -> Node 0
[   63.631559] using mwait in idle threads.
[   63.631560] CPU: Physical Processor ID: 0
[   63.631561] CPU: Processor Core ID: 0
[   63.631566] CPU0: Thermal monitoring enabled (TM2)
[   63.631573] SMP alternatives: switching to UP code
[   63.631764] Early unpacking initramfs... done
[   63.892884] ACPI: Core revision 20070126
[   63.892913] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
[   63.935659] Using local APIC timer interrupts.
[   63.973259] result 20760346
[   63.973260] Detected 20.760 MHz APIC timer.
[   63.973513] SMP alternatives: switching to SMP code
[   63.973572] Booting processor 1/2 APIC 0x1
[   63.983924] Initializing CPU#1
[   64.061393] Calibrating delay using timer specific routine.. 5314.75 BogoMIPS (lpj=10629504)
[   64.061398] CPU: L1 I cache: 32K, L1 D cache: 32K
[   64.061400] CPU: L2 cache: 4096K
[   64.061401] CPU 1/1 -> Node 0
[   64.061403] CPU: Physical Processor ID: 0
[   64.061403] CPU: Processor Core ID: 1
[   64.061408] CPU1: Thermal monitoring enabled (TM2)
[   64.061786] Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz stepping 0b
[   64.061791] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   64.085382] Brought up 2 CPUs
[   64.220348] migration_cost=11
[   64.220477] NET: Registered protocol family 16
[   64.220535] ACPI: bus type pci registered
[   64.220540] PCI: Using configuration type 1
[   64.221560] ACPI: EC: Look up EC in DSDT
[   64.222989] ACPI: Interpreter enabled
[   64.222992] ACPI: (supports S0 S1 S3 S4 S5)
[   64.223003] ACPI: Using IOAPIC for interrupt routing
[   64.226153] ACPI: PCI Root Bridge [PCI0] (0000:00)

<=== Stock 2.6.24 hangs here ===>

[   64.226167] PCI: Probing PCI hardware (bus 00)
[   64.227359] PCI: Transparent bridge - 0000:00:1e.0
[   64.227413] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   64.227684] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[   64.227869] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[   64.227949] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[   64.228026] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[   64.228102] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[   64.228179] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[   64.232317] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[   64.232383] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[   64.232448] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12)
[   64.232510] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[   64.232574] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12)
[   64.232636] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 *9 10 11 12)
[   64.232701] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 *10 11 12)
[   64.232764] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[   64.232829] Linux Plug and Play Support v0.97 (c) Adam Belay
[   64.232837] pnp: PnP ACPI init
[   64.232842] ACPI: bus type pnp registered
[   64.234403] pnp: PnP ACPI: found 12 devices
[   64.234405] ACPI: ACPI bus type pnp unregistered
[   64.234438] PCI: Using ACPI for IRQ routing
[   64.234440] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   64.234509] NET: Registered protocol family 8
[   64.234511] NET: Registered protocol family 20
[   64.234523] PCI-GART: No AMD northbridge found.
[   64.234527] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[   64.234530] hpet0: 4 64-bit timers, 14318180 Hz
[   64.235561] pnp: 00:01: iomem range 0xf0000000-0xf7ffffff could not be reserved
[   64.235563] pnp: 00:01: iomem range 0xfeb00000-0xfeb03fff has been reserved
[   64.235565] pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
[   64.235567] pnp: 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[   64.235571] pnp: 00:06: ioport range 0x500-0x53f has been reserved
[   64.235573] pnp: 00:06: ioport range 0x400-0x47f has been reserved
[   64.235575] pnp: 00:06: ioport range 0x680-0x6ff has been reserved
[   64.235770] PCI: Bridge: 0000:00:1c.0
[   64.235771]   IO window: disabled.
[   64.235774]   MEM window: disabled.
[   64.235776]   PREFETCH window: disabled.
[   64.235779] PCI: Bridge: 0000:00:1c.1
[   64.235780]   IO window: disabled.
[   64.235783]   MEM window: disabled.
[   64.235786]   PREFETCH window: disabled.
[   64.235789] PCI: Bridge: 0000:00:1c.2
[   64.235791]   IO window: 1000-1fff
[   64.235794]   MEM window: 90100000-901fffff
[   64.235797]   PREFETCH window: disabled.
[   64.235800] PCI: Bridge: 0000:00:1c.3
[   64.235801]   IO window: disabled.
[   64.235804]   MEM window: disabled.
[   64.235806]   PREFETCH window: disabled.
[   64.235809] PCI: Bridge: 0000:00:1c.4
[   64.235810]   IO window: disabled.
[   64.235813]   MEM window: disabled.
[   64.235816]   PREFETCH window: disabled.
[   64.235819] PCI: Bridge: 0000:00:1e.0
[   64.235820]   IO window: disabled.
[   64.235823]   MEM window: 90000000-900fffff
[   64.235826]   PREFETCH window: disabled.
[   64.235841] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
[   64.235846] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   64.235858] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 20 (level, low) -> IRQ 20
[   64.235862] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   64.235874] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[   64.235878] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   64.235890] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[   64.235894] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   64.235905] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17
[   64.235909] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   64.235917] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   64.235923] NET: Registered protocol family 2
[   64.237236] Time: tsc clocksource has been installed.
[   64.273355] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[   64.273811] TCP established hash table entries: 262144 (order: 10, 6291456 bytes)
[   64.275927] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   64.276377] TCP: Hash tables configured (established 262144 bind 65536)
[   64.276379] TCP reno registered
[   64.289449] checking if image is initramfs... it is
[   64.807858] Freeing initrd memory: 7706k freed
[   64.810374] audit: initializing netlink socket (disabled)
[   64.810389] audit(1203023724.228:1): initialized
[   64.811749] VFS: Disk quotas dquot_6.5.1
[   64.811781] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   64.811840] io scheduler noop registered
[   64.811841] io scheduler anticipatory registered
[   64.811842] io scheduler deadline registered
[   64.811902] io scheduler cfq registered (default)
[   64.811912] Boot video device is 0000:00:02.0
[   64.815048] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   64.815078] assign_interrupt_mode Found MSI capability
[   64.815080] Allocate Port Service[0000:00:1c.0:pcie00]
[   64.815104] Allocate Port Service[0000:00:1c.0:pcie02]
[   64.815160] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   64.815189] assign_interrupt_mode Found MSI capability
[   64.815191] Allocate Port Service[0000:00:1c.1:pcie00]
[   64.815208] Allocate Port Service[0000:00:1c.1:pcie02]
[   64.815259] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   64.815288] assign_interrupt_mode Found MSI capability
[   64.815290] Allocate Port Service[0000:00:1c.2:pcie00]
[   64.815309] Allocate Port Service[0000:00:1c.2:pcie02]
[   64.815362] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   64.815390] assign_interrupt_mode Found MSI capability
[   64.815392] Allocate Port Service[0000:00:1c.3:pcie00]
[   64.815412] Allocate Port Service[0000:00:1c.3:pcie02]
[   64.815464] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   64.815493] assign_interrupt_mode Found MSI capability
[   64.815495] Allocate Port Service[0000:00:1c.4:pcie00]
[   64.815513] Allocate Port Service[0000:00:1c.4:pcie02]
[   64.828288] Real Time Clock Driver v1.12ac
[   64.828366] hpet_resources: 0xfed00000 is busy
[   64.828376] Linux agpgart interface v0.102 (c) Dave Jones
[   64.828378] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   64.828460] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   64.828820] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   64.829204] ACPI: PCI Interrupt 0000:00:03.3[B] -> GSI 17 (level, low) -> IRQ 17
[   64.829251] 0000:00:03.3: ttyS1 at I/O 0x2470 (irq = 17) is a 16550A
[   64.829622] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   64.829706] input: Macintosh mouse button emulation as /class/input/input0
[   64.829779] PNP: No PS/2 controller found. Probing ports directly.
[   64.832588] serio: i8042 KBD port at 0x60,0x64 irq 1
[   64.832591] serio: i8042 AUX port at 0x60,0x64 irq 12
[   64.832690] mice: PS/2 mouse device common for all mice
[   64.832773] TCP cubic registered
[   64.832813] NET: Registered protocol family 1
[   64.832957] /build/buildd/linux-source-2.6.22-2.6.22/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   64.832962] Freeing unused kernel memory: 296k freed
[   65.948496] AppArmor: AppArmor initialized<5>audit(1203023725.368:2):  type=1505 info="AppArmor initialized" pid=1245
[   65.956214] fuse init (API version 7.8)
[   65.962969] Failure registering capabilities with primary security module.
[   65.984606] Monitor-Mwait will be used to enter C-1 state
[   65.984609] ACPI: Processor [CPU0] (supports 8 throttling states)
[   65.984711] ACPI: Processor [CPU1] (supports 8 throttling states)
[   65.984719] ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
[   65.984727] ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
[   66.229197] usbcore: registered new interface driver usbfs
[   66.229213] usbcore: registered new interface driver hub
[   66.229227] usbcore: registered new device driver usb
[   66.229660] USB Universal Host Controller Interface driver v3.0
[   66.229726] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 18 (level, low) -> IRQ 18
[   66.229735] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[   66.229737] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   66.229826] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   66.229848] uhci_hcd 0000:00:1a.0: irq 18, io base 0x000020c0
[   66.229917] usb usb1: configuration #1 chosen from 1 choice
[   66.229934] hub 1-0:1.0: USB hub found
[   66.229937] hub 1-0:1.0: 2 ports detected
[   66.232742] SCSI subsystem initialized
[   66.235552] libata version 2.21 loaded.
[   66.332282] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[   66.332294] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[   66.332297] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   66.332321] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[   66.332352] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000020a0
[   66.332414] usb usb2: configuration #1 chosen from 1 choice
[   66.332431] hub 2-0:1.0: USB hub found
[   66.332435] hub 2-0:1.0: 2 ports detected
[   66.436673] ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 17 (level, low) -> IRQ 17
[   66.436679] PCI: Setting latency timer of device 0000:00:1a.2 to 64
[   66.436681] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   66.436697] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[   66.436719] uhci_hcd 0000:00:1a.2: irq 17, io base 0x00002080
[   66.436793] usb usb3: configuration #1 chosen from 1 choice
[   66.436808] hub 3-0:1.0: USB hub found
[   66.436811] hub 3-0:1.0: 2 ports detected
[   66.541116] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[   66.541122] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   66.541125] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   66.541143] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[   66.541164] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002060
[   66.541238] usb usb4: configuration #1 chosen from 1 choice
[   66.541251] hub 4-0:1.0: USB hub found
[   66.541254] hub 4-0:1.0: 2 ports detected
[   66.645555] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   66.645560] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   66.645563] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   66.645578] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[   66.645599] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002040
[   66.645675] usb usb5: configuration #1 chosen from 1 choice
[   66.645689] hub 5-0:1.0: USB hub found
[   66.645693] hub 5-0:1.0: 2 ports detected
[   66.749999] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[   66.750005] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   66.750008] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   66.750022] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[   66.750041] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002020
[   66.750117] usb usb6: configuration #1 chosen from 1 choice
[   66.750133] hub 6-0:1.0: USB hub found
[   66.750136] hub 6-0:1.0: 2 ports detected
[   66.854576] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 17 (level, low) -> IRQ 17
[   66.855319] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[   66.855324] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   66.855369] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
[   66.855393] ehci_hcd 0000:00:1a.7: debug port 1
[   66.855398] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[   66.855403] ehci_hcd 0000:00:1a.7: irq 17, io mem 0x90426400
[   66.859284] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   66.859359] usb usb7: configuration #1 chosen from 1 choice
[   66.859376] hub 7-0:1.0: USB hub found
[   66.859381] hub 7-0:1.0: 6 ports detected
[   66.966653] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[   66.967424] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   66.967429] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   66.967469] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[   66.967497] ehci_hcd 0000:00:1d.7: debug port 1
[   66.967502] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   66.967508] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x90426000
[   66.990573] usb 5-1: new low speed USB device using uhci_hcd and address 2
[   66.990584] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   66.990657] usb usb8: configuration #1 chosen from 1 choice
[   66.990681] hub 8-0:1.0: USB hub found
[   66.990686] hub 8-0:1.0: 6 ports detected
[   67.090979] ACPI: PCI Interrupt 0000:06:03.0[A] -> GSI 19 (level, low) -> IRQ 19
[   67.143077] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[90000000-900007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[   67.150154] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[   67.150176] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   67.150338] scsi0 : pata_marvell
[   67.150368] scsi1 : pata_marvell
[   67.150383] ata1: PATA max UDMA/100 cmd 0x0000000000011018 ctl 0x0000000000011026 bmdma 0x0000000000011000 irq 18
[   67.150385] ata2: DUMMY
[   67.151057] BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:01 0D:00 0E:00 0F:00 
[   67.516171] usb 5-1: new low speed USB device using uhci_hcd and address 3
[   67.629158] ata1.00: ATAPI: ATAPI   CDRW 52X32, Y.BS, max UDMA/33
[   67.678760] usb 5-1: configuration #1 chosen from 1 choice
[   67.686901] usbcore: registered new interface driver hiddev
[   67.699952] input: HID 1267:0103 as /class/input/input1
[   67.699958] input: USB HID v1.10 Keyboard [HID 1267:0103] on usb-0000:00:1d.1-1
[   67.721706] input: HID 1267:0103 as /class/input/input2
[   67.721711] input: USB HID v1.10 Device [HID 1267:0103] on usb-0000:00:1d.1-1
[   67.721718] usbcore: registered new interface driver usbhid
[   67.721721] /build/buildd/linux-source-2.6.22-2.6.22/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   67.801998] ata1.00: configured for UDMA/33
[   67.802659] scsi 0:0:0:0: CD-ROM            ATAPI    CDRW 52X32       Y.BS PQ: 0 ANSI: 5
[   67.802782] ata_piix 0000:00:1f.2: version 2.11
[   67.802787] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   67.802807] ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 21 (level, low) -> IRQ 21
[   67.802831] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   67.802965] scsi2 : ata_piix
[   67.803001] scsi3 : ata_piix
[   67.803063] ata3: SATA max UDMA/133 cmd 0x0000000000012468 ctl 0x000000000001249e bmdma 0x0000000000012430 irq 21
[   67.803066] ata4: SATA max UDMA/133 cmd 0x0000000000012460 ctl 0x000000000001249a bmdma 0x0000000000012438 irq 21
[   67.810031] sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray
[   67.810034] Uniform CD-ROM driver Revision: 3.20
[   67.810179] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   67.812114] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   67.973582] ata3.00: ATA-7: WDC WD1600AAJS-08PSA0, 05.06H05, max UDMA/133
[   67.973586] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   67.986685] ata3.00: configured for UDMA/133
[   68.153193] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600AAJS-0 05.0 PQ: 0 ANSI: 5
[   68.153231] scsi 2:0:0:0: Attached scsi generic sg1 type 0
[   68.153251] ata_piix 0000:00:1f.5: MAP [ P0 P2 P1 P3 ]
[   68.153268] ACPI: PCI Interrupt 0000:00:1f.5[A] -> GSI 21 (level, low) -> IRQ 21
[   68.153286] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[   68.155219] scsi4 : ata_piix
[   68.155246] scsi5 : ata_piix
[   68.155295] ata5: SATA max UDMA/133 cmd 0x0000000000012458 ctl 0x0000000000012496 bmdma 0x0000000000012410 irq 21
[   68.155297] ata6: SATA max UDMA/133 cmd 0x0000000000012450 ctl 0x0000000000012492 bmdma 0x0000000000012418 irq 21
[   68.337458] ISO 9660 Extensions: Microsoft Joliet Level 3
[   68.358680] ISO 9660 Extensions: RRIP_1991A
[   68.427886] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0090270001f0396a]
[   68.494021] sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   68.494029] sd 2:0:0:0: [sda] Write Protect is off
[   68.494030] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   68.494039] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   68.494066] sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   68.494071] sd 2:0:0:0: [sda] Write Protect is off
[   68.494073] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   68.494081] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   68.494084]  sda: sda1 sda2 sda3 sda4 < sda5 >
[   68.520171] sd 2:0:0:0: [sda] Attached SCSI disk
[   68.580358] Registering unionfs 1.4
[   68.580361] unionfs: debugging is not enabled
[   68.588337] loop: module loaded
[   68.939797] squashfs: version 3.2-UBUNTU (2007/07/26) Phillip Lougher
[  107.853345] agpgart: Detected an Intel Q35 Chipset.
[  107.854735] agpgart: Detected 7164K stolen memory.
[  107.866197] agpgart: AGP aperture is 256M @ 0x80000000
[  107.937033] heci: Intel(R) AMT Management Interface - version 3.1.0.31
[  107.937035] heci: Copyright (c) 2003 - 2007 Intel Corporation.
[  107.937354] ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 16 (level, low) -> IRQ 16
[  107.937358] PCI: Setting latency timer of device 0000:00:03.0 to 64
[  107.939764] heci: link layer has been established.
[  108.038787] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[  108.052920] heci: heci driver initialization successful.
[  108.105278] Intel(R) PRO/1000 Network Driver - version 7.6.5-NAPI
[  108.105280] Copyright (c) 1999-2007 Intel Corporation.
[  108.105601] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[  108.105611] PCI: Setting latency timer of device 0000:00:19.0 to 64
[  108.154376] e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:1c:c0:09:4b:5f
[  108.223712] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[  108.444776] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[  108.479953] input: PC Speaker as /class/input/input3
[  108.676281] usbcore: registered new interface driver xpad
[  108.676287] /build/buildd/linux-source-2.6.22-2.6.22/drivers/input/joystick/xpad.c: driver for Xbox controllers v0.1.6
[  109.163666] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[  109.164416] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[  111.165845] Adding 979956k swap on /dev/sda3.  Priority:-1 extents:1 across:979956k
[  112.393389] No dock devices found.
[  112.418893] input: Power Button (FF) as /class/input/input4
[  112.418906] ACPI: Power Button (FF) [PWRF]
[  112.418934] input: Sleep Button (CM) as /class/input/input5
[  112.418945] ACPI: Sleep Button (CM) [SLPB]
[  116.266343] lp: driver loaded but no devices found
[  116.615950] ppdev: user-space parallel port driver
[  118.464920] Failure registering capabilities with primary security module.
[  119.100753] Bluetooth: Core ver 2.11
[  119.100800] NET: Registered protocol family 31
[  119.100801] Bluetooth: HCI device and connection manager initialized
[  119.100805] Bluetooth: HCI socket layer initialized
[  119.129342] Bluetooth: L2CAP ver 2.8
[  119.129345] Bluetooth: L2CAP socket layer initialized
[  119.406117] Bluetooth: RFCOMM socket layer initialized
[  119.406130] Bluetooth: RFCOMM TTY layer initialized
[  119.406132] Bluetooth: RFCOMM ver 1.8
[  120.318609] e1000: eth0: e1000_watchdog_task: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[  124.827843] NET: Registered protocol family 17
[  126.957562] [drm] Initialized drm 1.1.0 20060810
[  126.977706] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[  126.977823] [drm] Initialized i915 1.6.0 20060119 on minor 0
[  126.978414] set status page addr 0x00033000
[  130.732286] NET: Registered protocol family 10
[  130.732372] lo: Disabled Privacy Extensions
[  141.284277] eth0: no IPv6 routers present
