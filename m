Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYKDPB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYKDPB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYKDPBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:01:19 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:18358 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbYKDPBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:01:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:sender;
        b=yEsXaZ4ZfG9RR+Y814+0QLJcVSrailgncMki2bY4yOxLdMeSDXaX2dqZJYtt3Ye7qT
         TfOWMsRjEBMLZ4lqw8sFigGJiOvRAo6QiivqWNrh30SYvvZsxbIyaRs16MhUnSrT+8jg
         xdjE8eMk+KQr9H2VuzBCee92U32E5Hi7stvUM=
Message-ID: <491063B3.4080808@tuffmail.co.uk>
Date: Tue, 04 Nov 2008 15:01:07 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Add option to passively listen for PCIE hotplug events
References: <bspwK-420-11@gated-at.bofh.it> <bujnh-2fr-5@gated-at.bofh.it> <bujwT-2Ew-5@gated-at.bofh.it> <buml1-6du-3@gated-at.bofh.it> <d51a1b7b-32db-41dd-a36d-911ed62f5cb4@l33g2000pri.googlegroups.com> <20081104124706.GB19401@srcf.ucam.org> <20081104133214.GA20427@srcf.ucam.org> <49105BA6.9090403@tuffmail.co.uk> <20081104143332.GA21689@srcf.ucam.org>
In-Reply-To: <20081104143332.GA21689@srcf.ucam.org>
Content-Type: multipart/mixed;
 boundary="------------060107010004000404010303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060107010004000404010303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Matthew Garrett wrote:
> Ah, one more spot. How about this one?
>   

I don't think that's any better, sorry.

Hey... you're making this conditional on whether a power led is reported
present, right?  Are you sure the EeePC doesn't report itself as having
a power led?

Because it has a nice blue LED that shows the rfkill state, and it could
well be implemented as a pci hotplug power led.  I know that you can't
change it independently from the EC - you can poke EeePC-specific mapped
registers to hack the state of the charge LED, but not the rfkill one.

Alan

--------------060107010004000404010303
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
[    0.000000] Linux version 2.6.28-rc3eeepc (alan@alan-desktop) (gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3)) #124 Tue Nov 4 14:44:30 GMT 2008
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001f780000 (usable)
[    0.000000]  BIOS-e820: 000000001f780000 - 000000001f790000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001f790000 - 000000001f7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001f7d0000 - 000000001f7de000 (reserved)
[    0.000000]  BIOS-e820: 000000001f7e0000 - 000000001f800000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x1f780 max_arch_pfn = 0x1000000
[    0.000000] kernel direct mapping tables up to 1f780000 @ 10000-16000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] RAMDISK: 1f3e0000 - 1f76f12f
[    0.000000] ACPI: RSDP 000FBE60, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 1F780000, 0034 (r1 A M I  OEMRSDT   3000803 MSFT       97)
[    0.000000] ACPI: FACP 1F780200, 0081 (r1 A M I  OEMFACP   3000803 MSFT       97)
[    0.000000] ACPI: DSDT 1F780400, 5F61 (r1  A0797 A0797000        0 INTL 20051117)
[    0.000000] ACPI: FACS 1F790000, 0040
[    0.000000] ACPI: APIC 1F780390, 0068 (r1 A M I  OEMAPIC   3000803 MSFT       97)
[    0.000000] ACPI: OEMB 1F790040, 0046 (r1 A M I  AMI_OEM   3000803 MSFT       97)
[    0.000000] ACPI: MCFG 1F786370, 003C (r1 A M I  OEMMCFG   3000803 MSFT       97)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 503MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1f780000
[    0.000000]   low ram: 00000000 - 1f780000
[    0.000000]   bootmap 00013000 - 00016ef0
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 001f780000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 00004648a4]    TEXT DATA BSS ==> [0000100000 - 00004648a4]
[    0.000000]   #2 [001f3e0000 - 001f76f12f]          RAMDISK ==> [001f3e0000 - 001f76f12f]
[    0.000000]   #3 [0000465000 - 000046c000]    INIT_PG_TABLE ==> [0000465000 - 000046c000]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
[    0.000000]   #6 [0000013000 - 0000017000]          BOOTMAP ==> [0000013000 - 0000017000]
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001f780
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001f780
[    0.000000] On node 0 totalpages: 128783
[    0.000000] free_area_init_node: node 0, pgdat c03be710, node_mem_map c1000200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 975 pages used for memmap
[    0.000000]   Normal zone: 123825 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: Skipping IOAPIC probe due to 'noapic' option.
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] MPTABLE: OEM ID: INTEL   
[    0.000000] MPTABLE: Product ID: 
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] I/O APIC #1 Version 32 at 0xFEC00000.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Processors: 1
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 1f800000:df600000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 127776
[    0.000000] Kernel command line: root=/dev/sda1 resume=/dev/sda1 resume_offset=12453 ro vga=0xf07 noapic notsc 
[    0.000000] notsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely.
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 630.108 MHz processor.
[    0.000000] Console: colour VGA+ 80x60
[    0.000000] console [tty0] enabled
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Memory: 503408k/515584k available (1646k kernel code, 11620k reserved, 1208k data, 256k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
[    0.000000]     vmalloc : 0xdff80000 - 0xfffaa000   ( 512 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xdf780000   ( 503 MB)
[    0.000000]       .init : 0xc03cc000 - 0xc040c000   ( 256 kB)
[    0.000000]       .data : 0xc029bb06 - 0xc03c9c70   (1208 kB)
[    0.000000]       .text : 0xc0100000 - 0xc029bb06   (1646 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 1260.72 BogoMIPS (lpj=2100360)
[    0.003333] Mount-cache hash table entries: 512
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 512K
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#0.
[    0.003333] CPU: Intel(R) Celeron(R) M processor          900MHz stepping 08
[    0.003333] Checking 'hlt' instruction... OK.
[    0.016665] Freeing SMP alternatives: 0k freed
[    0.016665] ACPI: Core revision 20080926
[    0.036665] ACPI: setting ELCR to 0200 (from 0ca8)
[    0.039999] net_namespace: 740 bytes
[    0.039999] NET: Registered protocol family 16
[    0.039999] ACPI: bus type pci registered
[    0.039999] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.039999] PCI: Not using MMCONFIG.
[    0.039999] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.039999] PCI: Using configuration type 1 for base access
[    0.046665] ACPI: EC: Look up EC in DSDT
[    0.066665] ACPI: Interpreter enabled
[    0.066665] ACPI: (supports S0 S1 S3 S4 S5)
[    0.066665] ACPI: Using PIC for interrupt routing
[    0.066665] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.073332] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.073332] PCI: Using MMCONFIG for extended config space
[    0.086665] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.089999] ACPI: EC: driver started in poll mode
[    0.089999] ACPI: No dock devices found.
[    0.089999] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.089999] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7f00000-0xf7f7ffff]
[    0.089999] pci 0000:00:02.0: reg 14 io port: [0xec00-0xec07]
[    0.089999] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.089999] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf7ec0000-0xf7efffff]
[    0.089999] pci 0000:00:02.1: reg 10 32bit mmio: [0xf7f80000-0xf7ffffff]
[    0.089999] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7eb8000-0xf7ebbfff]
[    0.089999] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.089999] pci 0000:00:1b.0: PME# disabled
[    0.089999] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.089999] pci 0000:00:1c.0: PME# disabled
[    0.089999] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.089999] pci 0000:00:1c.1: PME# disabled
[    0.089999] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.089999] pci 0000:00:1c.2: PME# disabled
[    0.089999] pci 0000:00:1d.0: reg 20 io port: [0xe400-0xe41f]
[    0.089999] pci 0000:00:1d.1: reg 20 io port: [0xe480-0xe49f]
[    0.089999] pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
[    0.089999] pci 0000:00:1d.3: reg 20 io port: [0xe880-0xe89f]
[    0.089999] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7eb7c00-0xf7eb7fff]
[    0.089999] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.089999] pci 0000:00:1d.7: PME# disabled
[    0.089999] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.089999] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.089999] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.093332] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.093332] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.093332] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.093332] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.093332] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
[    0.093332] pci 0000:00:1f.2: PME# supported from D3hot
[    0.093332] pci 0000:00:1f.2: PME# disabled
[    0.093332] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.093332] pci 0000:03:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
[    0.093332] pci 0000:03:00.0: reg 30 32bit mmio: [0xfbfa0000-0xfbfbffff]
[    0.093332] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.093332] pci 0000:03:00.0: PME# disabled
[    0.093332] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.093332] pci 0000:00:1c.1: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
[    0.093332] pci 0000:01:00.0: reg 10 64bit mmio: [0xfbef0000-0xfbefffff]
[    0.093332] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.093332] pci 0000:00:1c.2: bridge 32bit mmio: [0xf8000000-0xfbefffff]
[    0.093332] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xf0000000-0xf6ffffff]
[    0.093332] pci 0000:00:1e.0: transparent bridge
[    0.093332] bus 00 -> node 0
[    0.093332] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.093332] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.093332] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.093332] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.106665] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.106665] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.106665] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.109998] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.109998] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.109998] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.113332] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.113332] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.116665] SCSI subsystem initialized
[    0.116665] libata version 3.00 loaded.
[    0.116665] PCI: Using ACPI for IRQ routing
[    0.116665] hpet clockevent registered
[    0.116665] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.116665] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.116665] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.119998] pnp: PnP ACPI init
[    0.119998] ACPI: bus type pnp registered
[    0.123336] Switched to NOHz mode on CPU #0
[    0.126672] pnp: PnP ACPI: found 13 devices
[    0.126672] ACPI: ACPI bus type pnp unregistered
[    0.126672] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.126672] system 00:08: ioport range 0x380-0x383 has been reserved
[    0.126672] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.126672] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.126672] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.126672] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.126672] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.126672] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.126672] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.126672] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.126672] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.134286] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.134286] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.134286] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
[    0.134286] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.134286] system 00:0c: iomem range 0x100000-0x1f7fffff could not be reserved
[    0.170004] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.170004] pci 0000:00:1c.0:   IO window: disabled
[    0.170004] pci 0000:00:1c.0:   MEM window: disabled
[    0.170004] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.170004] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.170004] pci 0000:00:1c.1:   IO window: disabled
[    0.170004] pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
[    0.170004] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.170004] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:01
[    0.170004] pci 0000:00:1c.2:   IO window: disabled
[    0.170004] pci 0000:00:1c.2:   MEM window: 0xf8000000-0xfbefffff
[    0.170004] pci 0000:00:1c.2:   PREFETCH window: 0x000000f0000000-0x000000f6ffffff
[    0.170004] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.170004] pci 0000:00:1e.0:   IO window: disabled
[    0.170004] pci 0000:00:1e.0:   MEM window: disabled
[    0.170004] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.170004] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 5
[    0.170004] PCI: setting IRQ 5 as level-triggered
[    0.170004] pci 0000:00:1c.0: PCI INT A -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[    0.170004] pci 0000:00:1c.0: setting latency timer to 64
[    0.170004] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    0.173390] PCI: setting IRQ 11 as level-triggered
[    0.173390] pci 0000:00:1c.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
[    0.173390] pci 0000:00:1c.1: setting latency timer to 64
[    0.173390] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    0.173390] PCI: setting IRQ 10 as level-triggered
[    0.173390] pci 0000:00:1c.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[    0.173390] pci 0000:00:1c.2: setting latency timer to 64
[    0.173390] pci 0000:00:1e.0: setting latency timer to 64
[    0.173390] bus: 00 index 0 io port: [0x00-0xffff]
[    0.173390] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.173390] bus: 04 index 0 mmio: [0x0-0x0]
[    0.173390] bus: 04 index 1 mmio: [0x0-0x0]
[    0.173390] bus: 04 index 2 mmio: [0x0-0x0]
[    0.173390] bus: 04 index 3 mmio: [0x0-0x0]
[    0.173390] bus: 03 index 0 mmio: [0x0-0x0]
[    0.173390] bus: 03 index 1 mmio: [0xfbf00000-0xfbffffff]
[    0.173390] bus: 03 index 2 mmio: [0x0-0x0]
[    0.173390] bus: 03 index 3 mmio: [0x0-0x0]
[    0.173390] bus: 01 index 0 mmio: [0x0-0x0]
[    0.173390] bus: 01 index 1 mmio: [0xf8000000-0xfbefffff]
[    0.173390] bus: 01 index 2 mmio: [0xf0000000-0xf6ffffff]
[    0.173390] bus: 01 index 3 mmio: [0x0-0x0]
[    0.173390] bus: 05 index 0 mmio: [0x0-0x0]
[    0.173390] bus: 05 index 1 mmio: [0x0-0x0]
[    0.173390] bus: 05 index 2 mmio: [0x0-0x0]
[    0.173390] bus: 05 index 3 io port: [0x00-0xffff]
[    0.173390] bus: 05 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.173390] NET: Registered protocol family 2
[    0.176357] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.179690] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.179690] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[    0.179690] TCP: Hash tables configured (established 16384 bind 16384)
[    0.179690] TCP reno registered
[    0.179690] NET: Registered protocol family 1
[    0.179690] checking if image is initramfs... it is
[    1.026698] Freeing initrd memory: 3644k freed
[    1.026698] audit: initializing netlink socket (disabled)
[    1.026698] type=2000 audit(1225810330.026:1): initialized
[    1.046675] msgmni has been set to 990
[    1.046675] alg: No test for stdrng (krng)
[    1.046675] io scheduler noop registered
[    1.046675] io scheduler anticipatory registered
[    1.046675] io scheduler deadline registered
[    1.046675] io scheduler cfq registered (default)
[    1.046675] pci 0000:00:02.0: Boot video device
[    1.053343] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.053343] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.053343] pcieport-driver 0000:00:1c.0: irq 47 for MSI/MSI-X
[    1.053343] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.053343] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.053343] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.053343] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.053343] pcieport-driver 0000:00:1c.1: found MSI capability
[    1.053343] pcieport-driver 0000:00:1c.1: irq 46 for MSI/MSI-X
[    1.053343] pci_express 0000:00:1c.1:pcie00: allocate port service
[    1.053343] pci_express 0000:00:1c.1:pcie02: allocate port service
[    1.053343] pci_express 0000:00:1c.1:pcie03: allocate port service
[    1.053343] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    1.053343] pcieport-driver 0000:00:1c.2: found MSI capability
[    1.053343] pcieport-driver 0000:00:1c.2: irq 45 for MSI/MSI-X
[    1.053343] pci_express 0000:00:1c.2:pcie00: allocate port service
[    1.053343] pci_express 0000:00:1c.2:pcie02: allocate port service
[    1.053343] pci_express 0000:00:1c.2:pcie03: allocate port service
[    1.063343] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    1.066677] brd: module loaded
[    1.066677] Driver 'sd' needs updating - please use bus_type methods
[    1.066677] ahci 0000:00:1f.2: version 3.0
[    1.070012] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 7
[    1.070012] PCI: setting IRQ 7 as level-triggered
[    1.070012] ahci 0000:00:1f.2: PCI INT B -> Link[LNKD] -> GSI 7 (level, low) -> IRQ 7
[    1.070012] ahci 0000:00:1f.2: PCI INT B disabled
[    1.070012] ahci: probe of 0000:00:1f.2 failed with error -22
[    1.070012] ata_piix 0000:00:1f.2: version 2.12
[    1.070012] ata_piix 0000:00:1f.2: PCI INT B -> Link[LNKD] -> GSI 7 (level, low) -> IRQ 7
[    1.070012] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    1.070012] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.070012] scsi0 : ata_piix
[    1.070012] scsi1 : ata_piix
[    1.070012] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.070012] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.396668] ata2.00: ATA-4: SILICONMOTION SM223AC, , max UDMA/66
[    1.396668] ata2.00: 7815024 sectors, multi 0: LBA 
[    1.410001] ata2.00: configured for UDMA/66
[    1.410001] scsi 1:0:0:0: Direct-Access     ATA      SILICONMOTION SM n/a  PQ: 0 ANSI: 5
[    1.410001] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors: (4.00 GB/3.72 GiB)
[    1.410001] sd 1:0:0:0: [sda] Write Protect is off
[    1.410001] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.410001] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.410001] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors: (4.00 GB/3.72 GiB)
[    1.410001] sd 1:0:0:0: [sda] Write Protect is off
[    1.410001] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.410001] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.410001]  sda: sda1
[    1.410001] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.412643] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.434397] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.434397] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.434397] mice: PS/2 mouse device common for all mice
[    1.434397] rtc_cmos 00:03: RTC can wake from S4
[    1.434397] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.434397] rtc0: alarms up to one month, 114 bytes nvram, , hpet irqs irqs
[    1.437731] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[    1.437731] iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x0860)
[    1.437731] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.437731] iTCO_vendor_support: vendor-support=0
[    1.437731] cpuidle: using governor ladder
[    1.437731] cpuidle: using governor menu
[    1.437731] Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
[    1.437731] ALSA device list:
[    1.437731]   No soundcards found.
[    1.437731] TCP cubic registered
[    1.437731] Using IPI Shortcut mode
[    1.443441] rtc_cmos 00:03: setting system clock to 2008-11-04 14:52:11 UTC (1225810331)
[    1.443441] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    1.443441] Freeing unused kernel memory: 256k freed
[    1.456680] input: AT Translated Set 2 keyboard as /class/input/input0
[    1.893341] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.893341] processor ACPI0007:00: registered as cooling_device0
[    1.893341] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.900011] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    1.907037] Marking TSC unstable due to TSC halts in idle
[    1.909405] thermal LNXTHERM:01: registered as thermal_zone0
[    1.922789] ACPI: Thermal Zone [TZ00] (41 C)
[    2.360016] PM: Starting manual resume from disk
[    3.383346] input: PC Speaker as /class/input/input1
[    3.386679] usbcore: registered new interface driver usbfs
[    3.386679] usbcore: registered new interface driver hub
[    3.386679] usbcore: registered new device driver usb
[    3.396831] usbcore: registered new interface driver libusual
[    3.406678] Initializing USB Mass Storage driver...
[    3.406678] usbcore: registered new interface driver usb-storage
[    3.410018] USB Mass Storage support registered.
[    3.423341] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.423341] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 3
[    3.423341] PCI: setting IRQ 3 as level-triggered
[    3.423341] ehci_hcd 0000:00:1d.7: PCI INT A -> Link[LNKH] -> GSI 3 (level, low) -> IRQ 3
[    3.423341] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.423341] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.423341] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    3.430009] ehci_hcd 0000:00:1d.7: debug port 1
[    3.430009] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.430009] ehci_hcd 0000:00:1d.7: irq 3, io mem 0xf7eb7c00
[    3.439785] udev: starting version 131
[    3.439785] udev: deprecated sysfs layout (kernel too old, or CONFIG_SYSFS_DEPRECATED) is unsupported, some udev features may fail
[    3.443351] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.443351] usb usb1: configuration #1 chosen from 1 choice
[    3.443351] hub 1-0:1.0: USB hub found
[    3.443351] hub 1-0:1.0: 8 ports detected
[    3.453351] uhci_hcd: USB Universal Host Controller Interface driver
[    3.453351] uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKH] -> GSI 3 (level, low) -> IRQ 3
[    3.453351] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.453351] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.453351] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.453351] uhci_hcd 0000:00:1d.0: irq 3, io base 0x0000e400
[    3.453351] usb usb2: configuration #1 chosen from 1 choice
[    3.453351] hub 2-0:1.0: USB hub found
[    3.453351] hub 2-0:1.0: 2 ports detected
[    3.453351] uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 7 (level, low) -> IRQ 7
[    3.453351] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.453351] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.453351] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    3.453351] uhci_hcd 0000:00:1d.1: irq 7, io base 0x0000e480
[    3.453351] usb usb3: configuration #1 chosen from 1 choice
[    3.453351] hub 3-0:1.0: USB hub found
[    3.453351] hub 3-0:1.0: 2 ports detected
[    3.453351] uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[    3.456725] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.456725] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.456725] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    3.456725] uhci_hcd 0000:00:1d.2: irq 10, io base 0x0000e800
[    3.456725] usb usb4: configuration #1 chosen from 1 choice
[    3.456725] hub 4-0:1.0: USB hub found
[    3.456725] hub 4-0:1.0: 2 ports detected
[    3.456725] uhci_hcd 0000:00:1d.3: PCI INT D -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[    3.456725] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    3.456725] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.456725] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    3.456725] uhci_hcd 0000:00:1d.3: irq 5, io base 0x0000e880
[    3.456725] usb usb5: configuration #1 chosen from 1 choice
[    3.456725] hub 5-0:1.0: USB hub found
[    3.456725] hub 5-0:1.0: 2 ports detected
[    3.750020] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    3.873356] usb 1-5: configuration #1 chosen from 1 choice
[    3.880024] scsi2 : SCSI emulation for USB Mass Storage devices
[    3.886689] usb-storage: device found at 2
[    3.886689] usb-storage: waiting for device to settle before scanning
[    4.233345] Linux agpgart interface v0.103
[    4.243350] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    4.243350] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    4.256685] input: Power Button (FF) as /class/input/input2
[    4.260018] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    4.280088] ACPI: Power Button (FF) [PWRF]
[    4.280088] input: Lid Switch as /class/input/input3
[    4.300050] ACPI: Lid Switch [LID]
[    4.300050] input: Sleep Button (CM) as /class/input/input4
[    4.306678] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.323348] pciehp 0000:00:1c.0:pcie02: HPC vendor_id 8086 device_id 2660 ss_vid 0 ss_did 0
[    4.323348] pciehp 0000:00:1c.0:pcie02: service driver pciehp loaded
[    4.323348] pciehp 0000:00:1c.1:pcie02: HPC vendor_id 8086 device_id 2662 ss_vid 0 ss_did 0
[    4.326681] ACPI: Sleep Button (CM) [SLPB]
[    4.326681] eeepc: Eee PC Hotkey Driver
[    4.326681] eeepc: Hotkey init flags 0x41
[    4.326681] eeepc: Get control methods supported: 0x101711
[    4.326681] input: Asus EeePC extra buttons as /class/input/input5
[    4.353350] input: Power Button (CM) as /class/input/input6
[    4.380021] ACPI: Power Button (CM) [PWRB]
[    4.616685] intel_rng: FWH not detected
[    5.329945] pciehp 0000:00:1c.1:pcie02: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
[    5.329945] pciehp 0000:00:1c.1:pcie02: Cannot add device at 0000:03:00
[    5.329945] pciehp 0000:00:1c.1:pcie02: service driver pciehp loaded
[    5.329945] pciehp 0000:00:1c.2:pcie02: HPC vendor_id 8086 device_id 2664 ss_vid 0 ss_did 0
[    5.329945] HDA Intel 0000:00:1b.0: PCI INT A -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[    5.329945] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.410019] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    5.507622] Synaptics Touchpad, model: 1, fw: 6.5, id: 0x1c0b1, caps: 0xa04751/0xa00000
[    5.646685] input: SynPS/2 Synaptics TouchPad as /class/input/input7
[    6.333384] pciehp 0000:00:1c.2:pcie02: Device 0000:01:00.0 already exists at 0000:01:00, cannot hot-add
[    6.333384] pciehp 0000:00:1c.2:pcie02: Cannot add device at 0000:01:00
[    6.333384] pciehp 0000:00:1c.2:pcie02: service driver pciehp loaded
[    6.333384] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    6.333384] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    6.340021] ACPI: AC Adapter [AC0] (on-line)
[    6.360019] ACPI: Battery Slot [BAT0] (battery absent)
[    6.430016] input: Video Bus as /class/input/input8
[    6.456688] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    6.483350] cfg80211: Using static regulatory domain info
[    6.483350] cfg80211: Regulatory domain: US
[    6.483350] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    6.483350] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    6.483350] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    6.483350] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    6.483350] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    6.488610] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    6.488610] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    6.488610] cfg80211: Calling CRDA for country: US
[    6.550009] ath5k_pci 0000:01:00.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[    6.550009] ath5k_pci 0000:01:00.0: setting latency timer to 64
[    6.550009] ath5k_pci 0000:01:00.0: registered as 'phy0'
[    6.606683] phy0: Selected rate control algorithm 'pid'
[    6.633352] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[    6.643350] udev: renamed network interface wlan0 to ath0
[    6.833343] fuse init (API version 7.10)
[    7.143345] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    7.192555] aes_i586: Unknown symbol crypto_it_tab
[    7.192555] aes_i586: Unknown symbol crypto_aes_set_key
[    7.192555] aes_i586: Unknown symbol crypto_fl_tab
[    7.192555] aes_i586: Unknown symbol crypto_il_tab
[    7.192555] aes_i586: Unknown symbol crypto_ft_tab
[    7.256686] aes_i586: Unknown symbol crypto_it_tab
[    7.260042] aes_i586: Unknown symbol crypto_aes_set_key
[    7.260042] aes_i586: Unknown symbol crypto_fl_tab
[    7.260042] aes_i586: Unknown symbol crypto_il_tab
[    7.260042] aes_i586: Unknown symbol crypto_ft_tab
[    7.613195] Adding 409592k swap on /swapfile.  Priority:-1 extents:704 across:581464k
[    8.380010] ip_tables: (C) 2000-2006 Netfilter Core Team
[    8.440003] nf_conntrack version 0.5.0 (8056 buckets, 32224 max)
[    8.440003] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    8.440003] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[    8.440003] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    8.590039] NET: Registered protocol family 10
[    8.590039] lo: Disabled Privacy Extensions
[    8.610013] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    8.890044] usb-storage: device scan complete
[    8.890044] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
[    9.065604] sensors[3179]: segfault at 46 ip b7e782cd sp bffa6c40 error 4 in libc-2.7.so[b7e1e000+149000]
[    9.065604] sensors[3181]: segfault at 46 ip b7f862cd sp bfab6760 error 4 in libc-2.7.so[b7f2c000+149000]
[    9.260037] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors: (8.01 GB/7.46 GiB)
[    9.260037] sd 2:0:0:0: [sdb] Write Protect is off
[    9.260037] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
[    9.260037] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    9.260037] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors: (8.01 GB/7.46 GiB)
[    9.260037] sd 2:0:0:0: [sdb] Write Protect is off
[    9.260037] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
[    9.260037] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    9.260037]  sdb: sdb1
[    9.263350] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    9.263350] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    9.987268] ACPI: WMI: Mapper loaded
[   11.612481] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   13.463348] [drm] Initialized drm 1.1.0 20060810
[   13.496686] pci 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[   13.496686] pci 0000:00:02.0: setting latency timer to 64
[   13.496686] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read from MCHBAR.  Disabling tiling.
[   13.496686] [drm:i915_driver_load] *ERROR* failed to enable MSI
[   13.496686] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   13.980003] ADDRCONF(NETDEV_UP): ath0: link is not ready
[   15.313362] evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
[   57.716665] NET: Registered protocol family 17
[   59.109999] ath0: authenticate with AP 00:1b:9e:19:45:90
[   59.113346] ath0: authenticated
[   59.113346] ath0: associate with AP 00:1b:9e:19:45:90
[   59.120003] ath0: RX AssocResp from 00:1b:9e:19:45:90 (capab=0x431 status=0 aid=1)
[   59.120003] ath0: associated
[   59.120003] ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
[   71.536678] ath0: deauthenticating by local choice (reason=3)
[   71.961536] ADDRCONF(NETDEV_UP): ath0: link is not ready
[   75.667576] PM: Syncing filesystems ... done.
[   75.667576] Freezing user space processes ... (elapsed 0.00 seconds) done.
[   75.670011] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[   75.670011] Suspending console(s) (use no_console_suspend to debug)
[   75.670011] pci 0000:00:02.0: PCI INT A disabled
[   76.200036] sd 1:0:0:0: [sda] Stopping disk
[   76.200036] pciehp 0000:00:1c.2:pcie02: pciehp_suspend ENTRY
[   76.200036] pciehp 0000:00:1c.1:pcie02: pciehp_suspend ENTRY
[   76.200036] pciehp 0000:00:1c.0:pcie02: pciehp_suspend ENTRY
[   76.200036] ath5k_pci 0000:01:00.0: PCI INT A disabled
[   76.213372] ata_piix 0000:00:1f.2: PCI INT B disabled
[   76.226702] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[   76.240037] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[   76.240037] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[   76.240037] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[   76.240037] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[   76.240037] pciehp 0000:00:1c.2:pcie02: pciehp_suspend ENTRY
[   76.240037] pciehp 0000:00:1c.1:pcie02: pciehp_suspend ENTRY
[   76.240037] pciehp 0000:00:1c.0:pcie02: pciehp_suspend ENTRY
[   76.253333] HDA Intel 0000:00:1b.0: PCI INT A disabled
[   76.266703] ACPI: Preparing to enter system sleep state S3
[   76.266703] Intel machine check architecture supported.
[   76.266703] Intel machine check reporting enabled on CPU#0.
[   76.266703] Back to C!
[   76.266703] Force enabled HPET at resume
[   76.267711] ACPI: Waking up from system sleep state S3
[   76.306666] ACPI: EC: non-query interrupt received, switching to interrupt mode
[   76.321361] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900003)
[   76.340041] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
[   76.340041] HDA Intel 0000:00:1b.0: PCI INT A -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[   76.340041] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   76.340041] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[   76.340041] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100504)
[   76.340041] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[   76.340041] pciehp 0000:00:1c.0:pcie02: pciehp_resume ENTRY
[   76.340041] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[   76.340041] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x180106, writing 0x100506)
[   76.340041] pciehp 0000:00:1c.1:pcie02: Card present on Slot(2)
[   76.340041] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[   76.340041] pciehp 0000:00:1c.1:pcie02: pciehp_resume ENTRY
[   77.343370] pciehp 0000:00:1c.1:pcie02: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
[   77.343370] pciehp 0000:00:1c.1:pcie02: Cannot add device at 0000:03:00
[   78.346704] pciehp 0000:00:1c.1:pcie02: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
[   78.346704] pciehp 0000:00:1c.1:pcie02: Cannot add device at 0000:03:00
[   79.873330] irq 10: nobody cared (try booting with the "irqpoll" option)
[   79.873330] Pid: 4930, comm: pm-suspend Not tainted 2.6.28-rc3eeepc #124
[   79.873330] Call Trace:
[   79.873330]  [<c0142d0c>] __report_bad_irq+0x24/0x69
[   79.873330]  [<c0142d13>] __report_bad_irq+0x2b/0x69
[   79.873330]  [<c0142e3e>] note_interrupt+0xed/0x133
[   79.873330]  [<c0142291>] handle_IRQ_event+0x1a/0x3f
[   79.873330]  [<c0143538>] handle_level_irq+0x4d/0x8d
[   79.873330]  [<c0104e95>] do_IRQ+0x55/0x6c
[   79.873330]  [<c010430b>] common_interrupt+0x23/0x28
[   79.873330]  [<c0230000>] atkbd_schedule_event_work+0x34/0x51
[   79.873330]  [<c011ec28>] __do_softirq+0x2a/0xbc
[   79.873330]  [<c011ecdc>] do_softirq+0x22/0x26
[   79.873330]  [<c011ef49>] irq_exit+0x25/0x55
[   79.873330]  [<c0104e9a>] do_IRQ+0x5a/0x6c
[   79.873330]  [<c010430b>] common_interrupt+0x23/0x28
[   79.873330]  [<c01bb6e8>] pci_bus_write_config_word+0x28/0x2e
[   79.873330]  [<c01bd29b>] pci_restore_state+0x79/0x15c
[   79.873330]  [<c01c2440>] resume_iter+0x0/0x25
[   79.873330]  [<c01c2af0>] pcie_portdrv_restore_config+0x9/0x22
[   79.873330]  [<c01c2b45>] pcie_portdrv_resume+0x8/0x10
[   79.873330]  [<c01bf1d3>] pci_legacy_resume+0x15/0x16
[   79.873330]  [<c020984f>] pm_op+0x52/0xac
[   79.873330]  [<c0209e15>] device_resume+0x7d/0x2d2
[   79.873330]  [<c0135c91>] suspend_devices_and_enter+0xc7/0xfb
[   79.873330]  [<c0135de6>] enter_state+0xdf/0x12e
[   79.873330]  [<c0135ec3>] state_store+0x8e/0xa4
[   79.873330]  [<c0135e35>] state_store+0x0/0xa4
[   79.873330]  [<c01b3d8b>] kobj_attr_store+0x18/0x1c
[   79.873330]  [<c0190d72>] sysfs_write_file+0xaf/0xdc
[   79.873330]  [<c0190cc3>] sysfs_write_file+0x0/0xdc
[   79.873330]  [<c0162b38>] vfs_write+0x83/0xf6
[   79.873330]  [<c0162ec9>] sys_write+0x3c/0x63
[   79.873330]  [<c010376d>] sysenter_do_call+0x12/0x21
[   79.873330]  [<c0290000>] __inet6_lookup_established+0x98/0x21c
[   79.873330] handlers:
[   79.873330] [<e0018d79>] (usb_hcd_irq+0x0/0x57 [usbcore])
[   79.873330] Disabling IRQ #10
[   79.873330] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[   79.873330] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x180106, writing 0x100506)
[   79.873330] pciehp 0000:00:1c.2:pcie02: Card present on Slot(3)
[   79.873330] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[   79.873330] pciehp 0000:00:1c.2:pcie02: pciehp_resume ENTRY
[   80.880036] pciehp 0000:00:1c.2:pcie02: Device 0000:01:00.0 already exists at 0000:01:00, cannot hot-add
[   80.880036] pciehp 0000:00:1c.2:pcie02: Cannot add device at 0000:01:00
[   81.883371] pciehp 0000:00:1c.2:pcie02: Device 0000:01:00.0 already exists at 0000:01:00, cannot hot-add
[   81.883371] pciehp 0000:00:1c.2:pcie02: Cannot add device at 0000:01:00
[   81.883371] uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKH] -> GSI 3 (level, low) -> IRQ 3
[   81.883371] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   81.883371] usb usb2: root hub lost power or was reset
[   81.883371] uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 7 (level, low) -> IRQ 7
[   81.883371] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   81.883371] usb usb3: root hub lost power or was reset
[   81.883371] uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[   81.883371] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   81.883371] usb usb4: root hub lost power or was reset
[   81.883371] uhci_hcd 0000:00:1d.3: PCI INT D -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[   81.883371] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   81.883371] usb usb5: root hub lost power or was reset
[   81.896702] ehci_hcd 0000:00:1d.7: PCI INT A -> Link[LNKH] -> GSI 3 (level, low) -> IRQ 3
[   81.896702] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   81.896702] pci 0000:00:1e.0: restoring config space at offset 0xf (was 0x60000, writing 0x600ff)
[   81.896702] pci 0000:00:1e.0: setting latency timer to 64
[   81.910037] ata_piix 0000:00:1f.2: PCI INT B -> Link[LNKD] -> GSI 7 (level, low) -> IRQ 7
[   81.910037] ata_piix 0000:00:1f.2: setting latency timer to 64
[   81.910037] ath5k_pci 0000:01:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[   81.910037] ath5k_pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfbef0004)
[   81.910037] ath5k_pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x4)
[   81.910037] ath5k_pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[   81.923372] ath5k_pci 0000:01:00.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[   81.943328] pciehp 0000:00:1c.0:pcie02: pciehp_resume ENTRY
[   81.943328] pciehp 0000:00:1c.1:pcie02: pciehp_resume ENTRY
[   82.086705] ata2.00: configured for UDMA/66
[   82.086705] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors: (4.00 GB/3.72 GiB)
[   82.086705] sd 1:0:0:0: [sda] Write Protect is off
[   82.086705] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   82.086705] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   82.953368] pciehp 0000:00:1c.1:pcie02: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
[   82.953368] pciehp 0000:00:1c.1:pcie02: Cannot add device at 0000:03:00
[   82.953368] pciehp 0000:00:1c.2:pcie02: pciehp_resume ENTRY
[   83.956703] pciehp 0000:00:1c.2:pcie02: Device 0000:01:00.0 already exists at 0000:01:00, cannot hot-add
[   83.956703] pciehp 0000:00:1c.2:pcie02: Cannot add device at 0000:01:00
[   83.956703] sd 1:0:0:0: [sda] Starting disk
[   84.210036] usb 1-5: reset high speed USB device using ehci_hcd and address 2
[   85.446704] pci 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
[   85.446704] pci 0000:00:02.0: setting latency timer to 64
[   85.446704] Restarting tasks ... done.
[   86.437568] ADDRCONF(NETDEV_UP): ath0: link is not ready
[   88.980037] evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
[  100.673326] ath0: authenticate with AP 00:1b:9e:19:45:90
[  100.676677] ath0: authenticated
[  100.676677] ath0: associate with AP 00:1b:9e:19:45:90
[  100.683332] ath0: RX AssocResp from 00:1b:9e:19:45:90 (capab=0x431 status=0 aid=1)
[  100.683332] ath0: associated
[  100.683332] ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready

--------------060107010004000404010303--
