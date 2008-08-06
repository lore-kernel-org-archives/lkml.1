Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYHFPY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYHFPY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbYHFPYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:24:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:17003 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbYHFPYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:24:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :content-type:sender;
        b=Qt54fkdrWxQEdiOI/Eh6TGedQYWtfaFAaRvj/V0Yd3UXfHxsL/vPwos1OYHMulHjG5
         bZXOeQZsN3zQwibrq7rF1JDnW0fuNAS/5C79iUHS28NRBWjLtUhCox1hSCjvn7t76JxO
         KGFJ58Ij7ZZcfdnGf3UFjtdzbJYn2aINAA5DY=
Message-ID: <4899C1FF.2090404@student.cs.york.ac.uk>
Date: Wed, 06 Aug 2008 16:23:43 +0100
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Reply-To: alan-jenkins@tuffmail.co.uk
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-uvc-devel@berlios.de
CC: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc2: uvcvideo breaks after suspend to ram
Content-Type: multipart/mixed;
 boundary="------------010308030006030609070501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010308030006030609070501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I don't use the webcam on my EeePC; I just happened to try it while 
testing 2.6.27-rc2.  I don't know about any other version so this isn't 
neccessarily a regression.

I think I tested it using Kopete, then later I got this warning on 
resume.  I definitely didn't have Kopete open when I suspended though.

Thanks
Alan

--------------010308030006030609070501
Content-Type: text/plain;
 name="dmesg-uvc-WARNING.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-uvc-WARNING.txt"

[    0.000000] Linux version 2.6.27-rc2eeepc-00004-gd2ceca8 (alan@alan-desktop) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #22 Wed Aug 6 14:32:25 BST 2008
[    0.000000] PAT disabled. Not yet verified on this CPU type.
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
[    0.000000] last_pfn = 0x1f780 max_arch_pfn = 0x1000000
[    0.000000] kernel direct mapping tables up to 1f780000 @ 7000-d000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] RAMDISK: 1f3ff000 - 1f76ff9b
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000FBE60, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 1F780000, 0034 (r1 A M I  OEMRSDT   1000808 MSFT       97)
[    0.000000] ACPI: FACP 1F780200, 0081 (r1 A M I  OEMFACP   1000808 MSFT       97)
[    0.000000] ACPI: DSDT 1F780400, 5F2B (r1  A0797 A0797000        0 INTL 20051117)
[    0.000000] ACPI: FACS 1F790000, 0040
[    0.000000] ACPI: APIC 1F780390, 0068 (r1 A M I  OEMAPIC   1000808 MSFT       97)
[    0.000000] ACPI: OEMB 1F790040, 0046 (r1 A M I  AMI_OEM   1000808 MSFT       97)
[    0.000000] ACPI: MCFG 1F786330, 003C (r1 A M I  OEMMCFG   1000808 MSFT       97)
[    0.000000] 503MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1f780000
[    0.000000]   low ram: 00000000 - 1f780000
[    0.000000]   bootmap 00001000 - 00004ef0
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 001f780000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 0000480194]    TEXT DATA BSS ==> [0000100000 - 0000480194]
[    0.000000]   #2 [001f3ff000 - 001f76ff9b]          RAMDISK ==> [001f3ff000 - 001f76ff9b]
[    0.000000]   #3 [0000481000 - 0000488000]    INIT_PG_TABLE ==> [0000481000 - 0000488000]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0000007000 - 000000a000]          PGTABLE ==> [0000007000 - 000000a000]
[    0.000000]   #6 [0000001000 - 0000005000]          BOOTMAP ==> [0000001000 - 0000005000]
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001f780
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001f780
[    0.000000] On node 0 totalpages: 128799
[    0.000000] free_area_init_node: node 0, pgdat c03bded4, node_mem_map c1000000
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 123825 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 1f800000:df600000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 127792
[    0.000000] Kernel command line: root=UUID=585a9dec-f84d-4e3a-b3b7-e67bd04f7f16 resume=UUID=585a9dec-f84d-4e3a-b3b7-e67bd04f7f16 resume_offset=12453 ro hpet=force 
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 630.063 MHz processor.
[    0.006666] Console: colour VGA+ 80x25
[    0.006666] console [tty0] enabled
[    0.006666] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.006666] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.006666] Memory: 503356k/515584k available (1744k kernel code, 11604k reserved, 1176k data, 296k init, 0k highmem)
[    0.006666] virtual kernel memory layout:
[    0.006666]     fixmap  : 0xfffb9000 - 0xfffff000   ( 280 kB)
[    0.006666]     vmalloc : 0xe0000000 - 0xfffb7000   ( 511 MB)
[    0.006666]     lowmem  : 0xc0000000 - 0xdf780000   ( 503 MB)
[    0.006666]       .init : 0xc03de000 - 0xc0428000   ( 296 kB)
[    0.006666]       .data : 0xc02b420d - 0xc03da348   (1176 kB)
[    0.006666]       .text : 0xc0100000 - 0xc02b420d   (1744 kB)
[    0.006666] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.006666] CPA: page pool initialized 1 of 1 pages preallocated
[    0.006666] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.006862] Calibrating delay loop (skipped), value calculated using timer frequency.. 1260.63 BogoMIPS (lpj=2100210)
[    0.007087] Mount-cache hash table entries: 512
[    0.007483] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.007623] CPU: L2 cache: 512K
[    0.007712] Intel machine check architecture supported.
[    0.007814] Intel machine check reporting enabled on CPU#0.
[    0.007924] CPU: Intel(R) Celeron(R) M processor          900MHz stepping 08
[    0.008120] Checking 'hlt' instruction... OK.
[    0.020827] Freeing SMP alternatives: 0k freed
[    0.020922] ACPI: Core revision 20080609
[    0.046663] ENABLING IO-APIC IRQs
[    0.046663] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.079994] net_namespace: 804 bytes
[    0.079994] NET: Registered protocol family 16
[    0.079994] No dock devices found.
[    0.079994] EISA bus registered
[    0.079994] ACPI: bus type pci registered
[    0.079994] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.079994] PCI: Not using MMCONFIG.
[    0.079994] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.079994] PCI: Using configuration type 1 for base access
[    0.081680] ACPI: EC: Look up EC in DSDT
[    0.106659] ACPI: Interpreter enabled
[    0.106659] ACPI: (supports S0 S1 S3 S4 S5)
[    0.106659] ACPI: Using IOAPIC for interrupt routing
[    0.106659] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.112911] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.113019] PCI: Using MMCONFIG for extended config space
[    0.127952] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.128061] ACPI: EC: driver started in poll mode
[    0.128469] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.129020] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.129125] pci 0000:00:1b.0: PME# disabled
[    0.129284] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.129386] pci 0000:00:1c.0: PME# disabled
[    0.129543] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.129645] pci 0000:00:1c.1: PME# disabled
[    0.129800] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.129902] pci 0000:00:1c.2: PME# disabled
[    0.130400] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.130504] pci 0000:00:1d.7: PME# disabled
[    0.130731] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.130747] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.130883] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.131068] pci 0000:00:1f.2: PME# supported from D3hot
[    0.131166] pci 0000:00:1f.2: PME# disabled
[    0.131532] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.131636] pci 0000:03:00.0: PME# disabled
[    0.131744] Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.1. It can be enabled forcedly with 'pcie_aspm=force'
[    0.132098] Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.2. It can be enabled forcedly with 'pcie_aspm=force'
[    0.132357] pci 0000:00:1e.0: transparent bridge
[    0.132485] bus 00 -> node 0
[    0.132509] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.133177] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.133462] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.133725] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.145275] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.146271] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.147294] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.148267] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.149240] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.150349] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.151458] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.152569] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.153640] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.153819] pnp: PnP ACPI init
[    0.153921] ACPI: bus type pnp registered
[    0.160079] pnp: PnP ACPI: found 13 devices
[    0.160180] ACPI: ACPI bus type pnp unregistered
[    0.160766] SCSI subsystem initialized
[    0.160917] libata version 3.00 loaded.
[    0.161197] usbcore: registered new interface driver usbfs
[    0.161384] usbcore: registered new interface driver hub
[    0.161575] usbcore: registered new device driver usb
[    0.162070] PCI: Using ACPI for IRQ routing
[    0.162859] hpet clockevent registered
[    0.162870] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.163147] hpet0: 3 64-bit timers, 14318180 Hz
[    0.164322] ACPI: RTC can wake from S4
[    0.164444] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.164541] system 00:08: ioport range 0x380-0x383 has been reserved
[    0.164621] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.164702] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.164783] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.164865] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.164949] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.165033] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.165144] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.165228] system 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.165340] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.165434] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.165523] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.165605] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
[    0.165689] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.165772] system 00:0c: iomem range 0x100000-0x1f7fffff could not be reserved
[    0.198137] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.199953] pci 0000:00:1c.0:   IO window: disabled
[    0.199984] pci 0000:00:1c.0:   MEM window: disabled
[    0.199984] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.199984] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.199984] pci 0000:00:1c.1:   IO window: disabled
[    0.199984] pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
[    0.199984] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.199984] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:01
[    0.200090] pci 0000:00:1c.2:   IO window: disabled
[    0.200189] pci 0000:00:1c.2:   MEM window: 0xf8000000-0xfbefffff
[    0.200293] pci 0000:00:1c.2:   PREFETCH window: 0x000000f0000000-0x000000f6ffffff
[    0.200433] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.200531] pci 0000:00:1e.0:   IO window: disabled
[    0.200629] pci 0000:00:1e.0:   MEM window: disabled
[    0.200726] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.200850] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.200957] pci 0000:00:1c.0: setting latency timer to 64
[    0.200972] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.201077] pci 0000:00:1c.1: setting latency timer to 64
[    0.201092] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.201197] pci 0000:00:1c.2: setting latency timer to 64
[    0.201209] pci 0000:00:1e.0: setting latency timer to 64
[    0.201237] NET: Registered protocol family 2
[    0.201595] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.202212] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.202606] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[    0.202852] TCP: Hash tables configured (established 16384 bind 16384)
[    0.202954] TCP reno registered
[    0.203192] NET: Registered protocol family 1
[    0.203599] checking if image is initramfs... it is
[    0.663357] Switched to high resolution mode on CPU 0
[    1.022302] Freeing initrd memory: 3523k freed
[    1.023678] audit: initializing netlink socket (disabled)
[    1.023811] type=2000 audit(1218032045.020:1): initialized
[    1.045714] msgmni has been set to 990
[    1.046092] io scheduler noop registered
[    1.046185] io scheduler anticipatory registered
[    1.046280] io scheduler deadline registered
[    1.046401] io scheduler cfq registered (default)
[    1.046524] pci 0000:00:02.0: Boot video device
[    1.046894] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.046946] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.047099] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.047197] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.047280] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.047444] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.047492] pcieport-driver 0000:00:1c.1: found MSI capability
[    1.047635] pci_express 0000:00:1c.1:pcie00: allocate port service
[    1.047723] pci_express 0000:00:1c.1:pcie02: allocate port service
[    1.047808] pci_express 0000:00:1c.1:pcie03: allocate port service
[    1.047959] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    1.048007] pcieport-driver 0000:00:1c.2: found MSI capability
[    1.048149] pci_express 0000:00:1c.2:pcie00: allocate port service
[    1.048236] pci_express 0000:00:1c.2:pcie02: allocate port service
[    1.048319] pci_express 0000:00:1c.2:pcie03: allocate port service
[    1.048976] ACPI: AC Adapter [AC0] (on-line)
[    1.049539] ACPI: Battery Slot [BAT0] (battery absent)
[    1.050007] input: Power Button (FF) as /class/input/input0
[    1.050123] ACPI: Power Button (FF) [PWRF]
[    1.050440] input: Lid Switch as /class/input/input1
[    1.051666] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    1.061730] ACPI: Lid Switch [LID]
[    1.062029] input: Sleep Button (CM) as /class/input/input2
[    1.062135] ACPI: Sleep Button (CM) [SLPB]
[    1.062406] input: Power Button (CM) as /class/input/input3
[    1.062507] ACPI: Power Button (CM) [PWRB]
[    1.063789] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.064156] processor ACPI0007:00: registered as cooling_device0
[    1.064261] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.071981] thermal LNXTHERM:01: registered as thermal_zone0
[    1.086080] ACPI: Thermal Zone [TZ00] (55 C)
[    1.086280] isapnp: Scanning for PnP cards...
[    1.442923] isapnp: No Plug & Play device found
[    1.452062] Linux agpgart interface v0.103
[    1.452200] agpgart: Detected an Intel 915GM Chipset.
[    1.452737] agpgart: Detected 7932K stolen memory.
[    1.482680] agpgart: AGP aperture is 256M @ 0xd0000000
[    1.482994] [drm] Initialized drm 1.1.0 20060810
[    1.483134] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.483240] pci 0000:00:02.0: setting latency timer to 64
[    1.483578] [drm] Initialized i915 1.6.0 20060119 on minor 0
[    1.483724] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    1.488262] brd: module loaded
[    1.488451] Driver 'sd' needs updating - please use bus_type methods
[    1.488673] ahci 0000:00:1f.2: version 3.0
[    1.488708] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.488838] ahci 0000:00:1f.2: PCI INT B disabled
[    1.488938] ahci: probe of 0000:00:1f.2 failed with error -22
[    1.489166] ata_piix 0000:00:1f.2: version 2.12
[    1.489181] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.489289] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    1.489636] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.489749] scsi0 : ata_piix
[    1.490251] scsi1 : ata_piix
[    1.494496] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.494603] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.817054] ata2.00: ATA-4: SILICONMOTION SM223AC, , max UDMA/66
[    1.817155] ata2.00: 7815024 sectors, multi 0: LBA 
[    1.830332] ata2.00: configured for UDMA/66
[    1.830634] scsi 1:0:0:0: Direct-Access     ATA      SILICONMOTION SM n/a  PQ: 0 ANSI: 5
[    1.831121] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors (4001 MB)
[    1.831255] sd 1:0:0:0: [sda] Write Protect is off
[    1.831353] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.831405] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.831673] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors (4001 MB)
[    1.831804] sd 1:0:0:0: [sda] Write Protect is off
[    1.831900] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.831948] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.832092]  sda: sda1
[    1.833010] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.833580] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.833712] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.833720] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.834085] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.838163] ehci_hcd 0000:00:1d.7: debug port 1
[    1.838262] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.838287] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
[    1.850001] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    1.850404] usb usb1: configuration #1 chosen from 1 choice
[    1.850624] hub 1-0:1.0: USB hub found
[    1.850732] hub 1-0:1.0: 8 ports detected
[    2.057159] USB Universal Host Controller Interface driver v3.0
[    2.057335] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.057451] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.057460] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.057827] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.057998] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
[    2.058359] usb usb2: configuration #1 chosen from 1 choice
[    2.058579] hub 2-0:1.0: USB hub found
[    2.058684] hub 2-0:1.0: 2 ports detected
[    2.160346] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.160464] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.160472] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.160788] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.160964] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
[    2.161325] usb usb3: configuration #1 chosen from 1 choice
[    2.161567] hub 3-0:1.0: USB hub found
[    2.161678] hub 3-0:1.0: 2 ports detected
[    2.163336] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    2.263672] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.263788] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.263796] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.264114] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.264289] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[    2.264657] usb usb4: configuration #1 chosen from 1 choice
[    2.264877] hub 4-0:1.0: USB hub found
[    2.264979] hub 4-0:1.0: 2 ports detected
[    2.287851] usb 1-5: configuration #1 chosen from 1 choice
[    2.393324] usb 1-8: new high speed USB device using ehci_hcd and address 3
[    2.470312] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    2.470429] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.470436] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.470752] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.470929] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
[    2.471288] usb usb5: configuration #1 chosen from 1 choice
[    2.471503] hub 5-0:1.0: USB hub found
[    2.471610] hub 5-0:1.0: 2 ports detected
[    2.517865] usb 1-8: configuration #1 chosen from 1 choice
[    2.677256] usbcore: registered new interface driver libusual
[    2.680841] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.708306] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.708414] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.708889] mice: PS/2 mouse device common for all mice
[    2.709521] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.709660] rtc0: alarms up to one month, hpet irqs
[    2.710224] cpuidle: using governor ladder
[    2.710816] cpuidle: using governor menu
[    2.711019] Advanced Linux Sound Architecture Driver Version 1.0.17.
[    2.711123] ALSA device list:
[    2.711211]   No soundcards found.
[    2.712444] TCP cubic registered
[    2.712553] Using IPI Shortcut mode
[    2.712964] PM: Resume from partition UUID=585a9dec-f84d-4e3a-b3b7-e67bd04f7f16
[    2.712971] PM: Checking hibernation image.
[    2.712988] PM: Error -6 checking image file
[    2.712993] PM: Resume from disk failed.
[    2.713332] rtc_cmos 00:03: setting system clock to 2008-08-06 14:14:07 UTC (1218032047)
[    2.713476] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    2.714158] Freeing unused kernel memory: 296k freed
[    2.729743] input: AT Translated Set 2 keyboard as /class/input/input4
[    3.533274] PM: Starting manual resume from disk
[    3.533404] PM: Resume from partition 8:1
[    3.533409] PM: Checking hibernation image.
[    3.534067] PM: Resume from disk failed.
[    3.557100] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    3.557118] PM: Basic memory bitmaps created
[    3.567057] PM: Basic memory bitmaps freed
[    3.716116] Marking TSC unstable due to TSC halts in idle
[    4.162901] Clocksource tsc unstable (delta = -157401203 ns)
[    6.894183] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    7.279927] eeepc: Eee PC Hotkey Driver
[    7.280256] eeepc: Hotkey init flags 0x41
[    7.281606] eeepc: Get control methods supported: 0x101711
[    7.493879] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.494026] hda_intel: position_fix set to 1 for device 1043:82a1
[    7.494161] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.584222] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    7.592213] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    7.598780] input: Video Bus as /class/input/input5
[    7.621568] atl2: disagrees about version of symbol __vlan_hwaccel_rx
[    7.621685] atl2: Unknown symbol __vlan_hwaccel_rx
[    7.622181] atl2: disagrees about version of symbol skb_put
[    7.622278] atl2: Unknown symbol skb_put
[    7.622498] atl2: disagrees about version of symbol __netif_schedule
[    7.622598] atl2: Unknown symbol __netif_schedule
[    7.622903] atl2: disagrees about version of symbol ethtool_op_get_tso
[    7.623005] atl2: Unknown symbol ethtool_op_get_tso
[    7.623226] atl2: disagrees about version of symbol unregister_netdev
[    7.623327] atl2: Unknown symbol unregister_netdev
[    7.624098] atl2: disagrees about version of symbol eth_type_trans
[    7.624198] atl2: Unknown symbol eth_type_trans
[    7.624460] atl2: disagrees about version of symbol ethtool_op_set_sg
[    7.624560] atl2: Unknown symbol ethtool_op_set_sg
[    7.624866] atl2: disagrees about version of symbol netif_device_detach
[    7.624967] atl2: Unknown symbol netif_device_detach
[    7.625219] atl2: disagrees about version of symbol netif_device_attach
[    7.625320] atl2: Unknown symbol netif_device_attach
[    7.625563] atl2: disagrees about version of symbol dev_kfree_skb_any
[    7.625664] atl2: Unknown symbol dev_kfree_skb_any
[    7.626138] atl2: disagrees about version of symbol register_netdev
[    7.626238] atl2: Unknown symbol register_netdev
[    7.626525] atl2: disagrees about version of symbol free_netdev
[    7.626624] atl2: Unknown symbol free_netdev
[    7.626863] atl2: disagrees about version of symbol ethtool_op_get_link
[    7.626964] atl2: Unknown symbol ethtool_op_get_link
[    7.627348] atl2: disagrees about version of symbol alloc_etherdev_mq
[    7.627449] atl2: Unknown symbol alloc_etherdev_mq
[    7.627743] atl2: disagrees about version of symbol netif_rx
[    7.627840] atl2: Unknown symbol netif_rx
[    7.628052] atl2: disagrees about version of symbol __netdev_alloc_skb
[    7.628153] atl2: Unknown symbol __netdev_alloc_skb
[    7.628728] atl2: disagrees about version of symbol netif_carrier_off
[    7.628830] atl2: Unknown symbol netif_carrier_off
[    7.629081] atl2: disagrees about version of symbol ethtool_op_get_sg
[    7.629182] atl2: Unknown symbol ethtool_op_get_sg
[    7.629406] atl2: disagrees about version of symbol netif_carrier_on
[    7.629506] atl2: Unknown symbol netif_carrier_on
[    7.630075] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    7.639631] atl2: disagrees about version of symbol __vlan_hwaccel_rx
[    7.639745] atl2: Unknown symbol __vlan_hwaccel_rx
[    7.640294] atl2: disagrees about version of symbol skb_put
[    7.640391] atl2: Unknown symbol skb_put
[    7.640613] atl2: disagrees about version of symbol __netif_schedule
[    7.640713] atl2: Unknown symbol __netif_schedule
[    7.641018] atl2: disagrees about version of symbol ethtool_op_get_tso
[    7.641119] atl2: Unknown symbol ethtool_op_get_tso
[    7.641340] atl2: disagrees about version of symbol unregister_netdev
[    7.641441] atl2: Unknown symbol unregister_netdev
[    7.642172] atl2: disagrees about version of symbol eth_type_trans
[    7.642272] atl2: Unknown symbol eth_type_trans
[    7.642533] atl2: disagrees about version of symbol ethtool_op_set_sg
[    7.642634] atl2: Unknown symbol ethtool_op_set_sg
[    7.642937] atl2: disagrees about version of symbol netif_device_detach
[    7.643040] atl2: Unknown symbol netif_device_detach
[    7.643291] atl2: disagrees about version of symbol netif_device_attach
[    7.643401] atl2: Unknown symbol netif_device_attach
[    7.643642] atl2: disagrees about version of symbol dev_kfree_skb_any
[    7.643743] atl2: Unknown symbol dev_kfree_skb_any
[    7.644219] atl2: disagrees about version of symbol register_netdev
[    7.644318] atl2: Unknown symbol register_netdev
[    7.644605] atl2: disagrees about version of symbol free_netdev
[    7.644704] atl2: Unknown symbol free_netdev
[    7.644932] atl2: disagrees about version of symbol ethtool_op_get_link
[    7.645034] atl2: Unknown symbol ethtool_op_get_link
[    7.645420] atl2: disagrees about version of symbol alloc_etherdev_mq
[    7.645520] atl2: Unknown symbol alloc_etherdev_mq
[    7.645815] atl2: disagrees about version of symbol netif_rx
[    7.645912] atl2: Unknown symbol netif_rx
[    7.646123] atl2: disagrees about version of symbol __netdev_alloc_skb
[    7.646224] atl2: Unknown symbol __netdev_alloc_skb
[    7.646803] atl2: disagrees about version of symbol netif_carrier_off
[    7.646903] atl2: Unknown symbol netif_carrier_off
[    7.647155] atl2: disagrees about version of symbol ethtool_op_get_sg
[    7.647256] atl2: Unknown symbol ethtool_op_get_sg
[    7.647480] atl2: disagrees about version of symbol netif_carrier_on
[    7.647581] atl2: Unknown symbol netif_carrier_on
[    7.751795] ath5k_pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.751954] ath5k_pci 0000:01:00.0: setting latency timer to 64
[    7.752016] ath5k_pci 0000:01:00.0: registered as 'phy0'
[    7.756924] ath5k phy0: Support for RF2425 is under development.
[    7.800353] phy0: Selected rate control algorithm 'pid'
[    7.849698] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[    7.857957] intel_rng: FWH not detected
[    7.870090] iTCO_vendor_support: vendor-support=0
[    7.874499] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[    7.874844] iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x0860)
[    7.875098] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.880054] intel_rng: FWH not detected
[    7.922605] Linux video capture interface: v2.00
[    7.952295] uvcvideo: Found UVC 1.00 device <unnamed> (eb1a:2761)
[    7.958576] input: UVC Camera (eb1a:2761) as /class/input/input6
[    7.960368] usbcore: registered new interface driver uvcvideo
[    7.960514] USB Video Class driver (v0.1.0)
[    7.972409] input: PC Speaker as /class/input/input7
[    8.449456] udev: renamed network interface wlan0 to ath0
[    8.832569] Synaptics Touchpad, model: 1, fw: 6.5, id: 0x1c0b1, caps: 0xa04751/0xa00000
[    8.935586] input: SynPS/2 Synaptics TouchPad as /class/input/input8
[    9.347956] fuse init (API version 7.9)
[    9.655302] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    9.702715] aes_i586: Unknown symbol crypto_it_tab
[    9.702960] aes_i586: Unknown symbol crypto_aes_set_key
[    9.703346] aes_i586: Unknown symbol crypto_fl_tab
[    9.703346] aes_i586: Unknown symbol crypto_il_tab
[    9.703618] aes_i586: Unknown symbol crypto_ft_tab
[    9.756262] aes_i586: Unknown symbol crypto_it_tab
[    9.756506] aes_i586: Unknown symbol crypto_aes_set_key
[    9.756977] aes_i586: Unknown symbol crypto_fl_tab
[    9.757216] aes_i586: Unknown symbol crypto_il_tab
[    9.757453] aes_i586: Unknown symbol crypto_ft_tab
[   10.091056] Adding 409592k swap on /swapfile.  Priority:-1 extents:704 across:581464k
[   10.250004] ip_tables: (C) 2000-2006 Netfilter Core Team
[   10.310003] nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
[   10.310390] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
[   10.310398] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   10.310405] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   10.456669] NET: Registered protocol family 10
[   10.458091] lo: Disabled Privacy Extensions
[   10.473340] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   12.685460] ACPI: WMI: Mapper loaded
[   14.126676] warning: `dnsmasq' uses 32-bit capabilities (legacy support in use)
[   16.115855] ACPI: EC: GPE storm detected, disabling EC GPE
[   18.047474] ADDRCONF(NETDEV_UP): ath0: link is not ready
[   51.150789] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[   68.306663] NET: Registered protocol family 17
[   69.638847] ath0: authenticate with AP 00:1b:9e:19:45:90
[   69.640159] ath0: authenticated
[   69.640159] ath0: associate with AP 00:1b:9e:19:45:90
[   69.642462] ath0: RX AssocResp from 00:1b:9e:19:45:90 (capab=0x431 status=0 aid=2)
[   69.642473] ath0: associated
[   69.643335] ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
[   86.017920] ath0: no IPv6 routers present
[  285.587500] ath0: deauthenticating by local choice (reason=3)
[  286.902148] ADDRCONF(NETDEV_UP): ath0: link is not ready
[  287.938359] PM: Syncing filesystems ... done.
[  287.939096] PM: Preparing system for mem sleep
[  287.939992] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  287.941400] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  287.941469] PM: Entering mem sleep
[  287.941474] Suspending console(s) (use no_console_suspend to debug)
[  288.507496] sd 1:0:0:0: [sda] Stopping disk
[  288.508560] pci 0000:00:02.0: PCI INT A disabled
[  288.521787] ath5k_pci 0000:01:00.0: PCI INT A disabled
[  288.535192] ata_piix 0000:00:1f.2: PCI INT B disabled
[  288.548500] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  288.561778] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[  288.561852] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  288.561926] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  288.562004] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  288.575355] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  288.589396] ACPI: Preparing to enter system sleep state S3
[  288.589396] Intel machine check architecture supported.
[  288.589428] Intel machine check reporting enabled on CPU#0.
[  288.589558] Back to C!
[  288.590021] Force enabled HPET at resume
[  288.590021] ACPI: Waking up from system sleep state S3
[  288.704382] ACPI: EC: non-query interrupt received, switching to interrupt mode
[  288.720343] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900003)
[  288.756989] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
[  288.757057] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  288.757080] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  288.757192] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[  288.757228] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100504)
[  288.757315] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[  288.757385] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[  288.757420] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[  288.757504] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[  288.757570] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[  288.757606] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[  288.757690] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[  288.757723] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  288.757741] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  288.757849] usb usb2: root hub lost power or was reset
[  288.757900] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  288.757918] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  288.758020] usb usb3: root hub lost power or was reset
[  288.758067] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[  288.758085] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  288.758188] usb usb4: root hub lost power or was reset
[  288.758234] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[  288.758252] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  288.758353] usb usb5: root hub lost power or was reset
[  288.770971] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  288.770990] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  288.771150] pci 0000:00:1e.0: restoring config space at offset 0xf (was 0x60000, writing 0x600ff)
[  288.771227] pci 0000:00:1e.0: setting latency timer to 64
[  288.784536] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  288.784554] ata_piix 0000:00:1f.2: setting latency timer to 64
[  288.790021] ath5k_pci 0000:01:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[  288.790021] ath5k_pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xfbef0004)
[  288.790021] ath5k_pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x4)
[  288.790021] ath5k_pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  288.800391] ath5k_pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  288.842794] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  288.842815] pci 0000:00:02.0: setting latency timer to 64
[  288.843317] sd 1:0:0:0: [sda] Starting disk
[  288.959748] ata2.00: ACPI cmd ef/03:44:00:00:00:a0 filtered out
[  288.959766] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[  288.973352] ata2.00: configured for UDMA/66
[  289.000034] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors (4001 MB)
[  289.000071] sd 1:0:0:0: [sda] Write Protect is off
[  289.000078] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  289.000125] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  289.221599] usb 1-5: reset high speed USB device using ehci_hcd and address 2
[  289.452100] usb 1-8: reset high speed USB device using ehci_hcd and address 3
[  290.127788] uvcvideo 1-8:1.0: no reset_resume for driver uvcvideo?
[  290.127788] uvcvideo 1-8:1.1: no reset_resume for driver uvcvideo?
[  290.127971] uvcvideo: Found UVC 1.00 device <unnamed> (eb1a:2761)
[  290.128471] video4linux video0: parent 1-8:1.0 is sleeping, will not add
[  290.128487] ------------[ cut here ]------------
[  290.128493] WARNING: at drivers/base/power/main.c:82 device_pm_add+0x4d/0xb3()
[  290.128501] Modules linked in: aes_i586 aes_generic af_packet cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_stats freq_table cpufreq_conservative fan wmi sbs sbshc ip6t_LOG nf_conntrack_ipv6 ipt_LOG xt_limit ipt_addrtype xt_state xt_tcpudp xt_conntrack ip6table_filter ip6_tables ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables dm_crypt dm_mod fuse joydev psmouse serio_raw pcspkr uvcvideo compat_ioctl32 videodev v4l1_compat ata_generic iTCO_wdt iTCO_vendor_support arc4 ecb crypto_blkcipher ath5k mac80211 led_class cfg80211 video shpchp pci_hotplug output snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_hwdep eeepc_laptop backlight sg evdev ext2 mbcache
[  290.128611] Pid: 5300, comm: pm-suspend Not tainted 2.6.27-rc2eeepc-00004-gd2ceca8 #22
[  290.128619]  [<c0118e01>] warn_on_slowpath+0x40/0x63
[  290.128635]  [<c01a67e8>] sprintf+0x1d/0x20
[  290.128643]  [<c0119693>] vprintk+0x1b4/0x227
[  290.128651]  [<c01191a3>] try_acquire_console_sem+0xa/0x2a
[  290.128660]  [<c016c9d6>] ifind+0xa/0x49
[  290.128680]  [<c018c624>] sysfs_find_dirent+0x13/0x23
[  290.128690]  [<c018c87d>] sysfs_addrm_finish+0x13/0x16f
[  290.128699]  [<c018c687>] __sysfs_add_one+0x53/0x5b
[  290.128711]  [<c011971a>] printk+0x14/0x18
[  290.128718]  [<c020d13a>] device_pm_add+0x4d/0xb3
[  290.128731]  [<c0209196>] device_add+0x344/0x496
[  290.128743]  [<c0200030>] i915_resume+0x4f0/0x96c
[  290.128755]  [<e02b72b2>] video_register_device_index+0x21a/0x28f [videodev]
[  290.128784]  [<e02b732e>] video_register_device+0x7/0x9 [videodev]
[  290.128801]  [<e02e2f13>] uvc_probe+0x8d6/0x97f [uvcvideo]
[  290.128821]  [<c016c9d6>] ifind+0xa/0x49
[  290.128830]  [<c02b0334>] mutex_lock+0xb/0x19
[  290.128842]  [<c0233c66>] usb_match_one_id+0x1c/0x71
[  290.128861]  [<c0234b75>] usb_probe_interface+0xc1/0xec
[  290.128872]  [<c020a813>] driver_probe_device+0xa1/0x117
[  290.128883]  [<c0209f1a>] bus_for_each_drv+0x34/0x5c
[  290.128892]  [<c020a94c>] device_attach+0x4e/0x5e
[  290.128900]  [<c020a8de>] __device_attach+0x0/0x5
[  290.128909]  [<c023465e>] usb_rebind_intf+0x27/0x4e
[  290.128916]  [<c02346eb>] do_unbind_rebind+0x4d/0x5a
[  290.128924]  [<c0234738>] usb_external_resume_device+0x40/0x51
[  290.128933]  [<c020cd87>] device_resume+0x8a/0x2d2
[  290.128941]  [<c01334e2>] suspend_devices_and_enter+0x10f/0x138
[  290.128954]  [<c013363a>] enter_state+0x10b/0x164
[  290.128963]  [<c0133721>] state_store+0x8e/0xa4
[  290.128972]  [<c0133693>] state_store+0x0/0xa4
[  290.128981]  [<c01a3087>] kobj_attr_store+0x18/0x1c
[  290.128991]  [<c018bedc>] sysfs_write_file+0xaf/0xdc
[  290.129000]  [<c018be2d>] sysfs_write_file+0x0/0xdc
[  290.129007]  [<c015ec41>] vfs_write+0x83/0xf6
[  290.129016]  [<c015efd2>] sys_write+0x3c/0x63
[  290.129024]  [<c01035c1>] sysenter_do_call+0x12/0x21
[  290.129035]  [<c02b0000>] wait_for_common+0xe0/0xe3
[  290.129045]  =======================
[  290.129050] ---[ end trace 6ef95bc81bce41aa ]---
[  290.129149] input input9: parent 1-8:1.0 is sleeping, will not add
[  290.129158] ------------[ cut here ]------------
[  290.129163] WARNING: at drivers/base/power/main.c:82 device_pm_add+0x4d/0xb3()
[  290.129168] Modules linked in: aes_i586 aes_generic af_packet cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_stats freq_table cpufreq_conservative fan wmi sbs sbshc ip6t_LOG nf_conntrack_ipv6 ipt_LOG xt_limit ipt_addrtype xt_state xt_tcpudp xt_conntrack ip6table_filter ip6_tables ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables dm_crypt dm_mod fuse joydev psmouse serio_raw pcspkr uvcvideo compat_ioctl32 videodev v4l1_compat ata_generic iTCO_wdt iTCO_vendor_support arc4 ecb crypto_blkcipher ath5k mac80211 led_class cfg80211 video shpchp pci_hotplug output snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_hwdep eeepc_laptop backlight sg evdev ext2 mbcache
[  290.129260] Pid: 5300, comm: pm-suspend Tainted: G        W 2.6.27-rc2eeepc-00004-gd2ceca8 #22
[  290.129267]  [<c0118e01>] warn_on_slowpath+0x40/0x63
[  290.129277]  [<c01a67e8>] sprintf+0x1d/0x20
[  290.129285]  [<c0119693>] vprintk+0x1b4/0x227
[  290.129292]  [<c01191a3>] try_acquire_console_sem+0xa/0x2a
[  290.129301]  [<c018c144>] sysfs_add_file_mode+0x49/0x67
[  290.129310]  [<c018d7da>] internal_create_group+0xcf/0x140
[  290.129320]  [<c011971a>] printk+0x14/0x18
[  290.129327]  [<c020d13a>] device_pm_add+0x4d/0xb3
[  290.129335]  [<c0209196>] device_add+0x344/0x496
[  290.129344]  [<c0247a15>] input_register_device+0x9f/0x177
[  290.129364]  [<e02e6dca>] uvc_status_init+0xc2/0x1ae [uvcvideo]
[  290.129390]  [<e02e2fa4>] uvc_probe+0x967/0x97f [uvcvideo]
[  290.129408]  [<c016c9d6>] ifind+0xa/0x49
[  290.129418]  [<c02b0334>] mutex_lock+0xb/0x19
[  290.129427]  [<c0233c66>] usb_match_one_id+0x1c/0x71
[  290.129443]  [<c0234b75>] usb_probe_interface+0xc1/0xec
[  290.129453]  [<c020a813>] driver_probe_device+0xa1/0x117
[  290.129463]  [<c0209f1a>] bus_for_each_drv+0x34/0x5c
[  290.129472]  [<c020a94c>] device_attach+0x4e/0x5e
[  290.129480]  [<c020a8de>] __device_attach+0x0/0x5
[  290.129489]  [<c023465e>] usb_rebind_intf+0x27/0x4e
[  290.129496]  [<c02346eb>] do_unbind_rebind+0x4d/0x5a
[  290.129504]  [<c0234738>] usb_external_resume_device+0x40/0x51
[  290.129512]  [<c020cd87>] device_resume+0x8a/0x2d2
[  290.129521]  [<c01334e2>] suspend_devices_and_enter+0x10f/0x138
[  290.129531]  [<c013363a>] enter_state+0x10b/0x164
[  290.129540]  [<c0133721>] state_store+0x8e/0xa4
[  290.129549]  [<c0133693>] state_store+0x0/0xa4
[  290.129557]  [<c01a3087>] kobj_attr_store+0x18/0x1c
[  290.129566]  [<c018bedc>] sysfs_write_file+0xaf/0xdc
[  290.129575]  [<c018be2d>] sysfs_write_file+0x0/0xdc
[  290.129583]  [<c015ec41>] vfs_write+0x83/0xf6
[  290.129590]  [<c015efd2>] sys_write+0x3c/0x63
[  290.129598]  [<c01035c1>] sysenter_do_call+0x12/0x21
[  290.129606]  [<c02b0000>] wait_for_common+0xe0/0xe3
[  290.129615]  =======================
[  290.129620] ---[ end trace 6ef95bc81bce41aa ]---
[  290.129688] input: UVC Camera (eb1a:2761) as /class/input/input9
[  290.137206] PM: Finishing wakeup.
[  290.137206] Restarting tasks ... done.
[  291.192128] ADDRCONF(NETDEV_UP): ath0: link is not ready

--------------010308030006030609070501--
