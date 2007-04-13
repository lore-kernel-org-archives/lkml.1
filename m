Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbXDMFeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbXDMFeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 01:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbXDMFeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 01:34:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:24145 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXDMFeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 01:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XdSueDltfnIMAKxx0IwxLiWvPGQ9BXnrqmf4PH1F85LVjUNgQ+31MKNyJ1JNovcHuJzVXI7modOQVMzNGzlDGzDyxpYxTE1DDxSXs0G8wPXydKHDvCi6u+h/goiCgb8JucTK6krVSDkm2GYvlKpkPbtaL6A76rFYbTnlwLD9giI=
Message-ID: <a872555b0704122234m6f26405l293dd39f8af672b6@mail.gmail.com>
Date: Fri, 13 Apr 2007 09:34:01 +0400
From: "=?UTF-8?B?0JTQtdC90LjRgSDQmtC40YDRjNGP0L3QvtCy?=" 
	<kirjanov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20.6 vanilla does't boot
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
I installed a new kernel 2.6.20.6 and it is unable to boot. During
loading, I get some messages from the kernel, similar to the
following
PCI: BIOS Bug: MCFG area at xxxxx is not E820-reserved
PCI: Not using MMCONFIG
udevplug: make_queue: unable to create /dev/.udev/queue: No such file
or directory
udevplug: make_queue: unable to create /dev/.udev/queue: File exists
sda: assuming drive cache: write through
Then loading stops and after about 2 minutes boots BusyBox.  Kernel
version 2.6.18.8 and 2.6.16.44-rc2 loaded properly.

the output of dmesg:
[17179569.184000] Linux version 2.6.15-26-686 (buildd@terranova) (gcc
version 4.0.3 (Ubuntu 4.0.3-1ubuntu5)) #1 SMP PREEMPT Fri Sep 8
20:16:40 UTC 2006
[17179569.184000] BIOS-provided physical RAM map:
[17179569.184000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[17179569.184000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[17179569.184000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[17179569.184000]  BIOS-e820: 0000000000100000 - 000000007ffa0000 (usable)
[17179569.184000]  BIOS-e820: 000000007ffa0000 - 000000007ffae000 (ACPI data)
[17179569.184000]  BIOS-e820: 000000007ffae000 - 000000007ffe0000 (ACPI NVS)
[17179569.184000]  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
[17179569.184000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[17179569.184000] 1151MB HIGHMEM available.
[17179569.184000] 896MB LOWMEM available.
[17179569.184000] found SMP MP-table at 000ff780
[17179569.184000] On node 0 totalpages: 524192
[17179569.184000]   DMA zone: 4096 pages, LIFO batch:0
[17179569.184000]   DMA32 zone: 0 pages, LIFO batch:0
[17179569.184000]   Normal zone: 225280 pages, LIFO batch:31
[17179569.184000]   HighMem zone: 294816 pages, LIFO batch:31
[17179569.184000] DMI 2.3 present.
[17179569.184000] ACPI: RSDP (v000 ACPIAM
  ) @ 0x000fad00
[17179569.184000] ACPI: RSDT (v001 A M I  OEMRSDT  0x05000504 MSFT
0x00000097) @ 0x7ffa0000
[17179569.184000] ACPI: FADT (v001 A M I  OEMFACP  0x05000504 MSFT
0x00000097) @ 0x7ffa0200
[17179569.184000] ACPI: MADT (v001 A M I  OEMAPIC  0x05000504 MSFT
0x00000097) @ 0x7ffa0390
[17179569.184000] ACPI: OEMB (v001 A M I  AMI_OEM  0x05000504 MSFT
0x00000097) @ 0x7ffae040
[17179569.184000]   >>> ERROR: Invalid checksum
[17179569.184000] ACPI: MCFG (v001 A M I  OEMMCFG  0x05000504 MSFT
0x00000097) @ 0x7ffa8810
[17179569.184000] ACPI: DSDT (v001  A0229 A0229000 0x00000000 INTL
0x02002026) @ 0x00000000
[17179569.184000] ACPI: PM-Timer IO Port: 0x808
[17179569.184000] ACPI: Local APIC address 0xfee00000
[17179569.184000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[17179569.184000] Processor #0 15:4 APIC version 20
[17179569.184000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[17179569.184000] Processor #1 15:4 APIC version 20
[17179569.184000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[17179569.184000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[17179569.184000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[17179569.184000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[17179569.184000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[17179569.184000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[17179569.184000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[17179569.184000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[17179569.184000] ACPI: IRQ0 used by override.
[17179569.184000] ACPI: IRQ2 used by override.
[17179569.184000] ACPI: IRQ9 used by override.
[17179569.184000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[17179569.184000] Using ACPI (MADT) for SMP configuration information
[17179569.184000] Allocating PCI resources starting at 88000000 (gap:
80000000:7fb00000)
[17179569.184000] Built 1 zonelists
[17179569.184000] Kernel command line: root=/dev/sda2 ro quiet vga=795
[17179569.184000] mapped APIC to ffffd000 (fee00000)
[17179569.184000] mapped IOAPIC to ffffc000 (fec00000)
[17179569.184000] Initializing CPU#0
[17179569.184000] PID hash table entries: 4096 (order: 12, 65536 bytes)
[17179569.184000] Detected 3011.186 MHz processor.
[17179569.184000] Using pmtmr for high-res timesource
[17179569.184000] Console: colour dummy device 80x25
[17179572.764000] Dentry cache hash table entries: 131072 (order: 7,
524288 bytes)
[17179572.764000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[17179572.868000] Memory: 2065764k/2096768k available (2115k kernel
code, 29864k reserved, 595k data, 332k init, 1179264k highmem)
[17179572.868000] Checking if this processor honours the WP bit even
in supervisor mode... Ok.
[17179572.948000] Calibrating delay using timer specific routine..
6029.29 BogoMIPS (lpj=12058592)
[17179572.948000] Security Framework v1.0.0 initialized
[17179572.948000] SELinux:  Disabled at boot.
[17179572.948000] Mount-cache hash table entries: 512
[17179572.948000] CPU: After generic identify, caps: bfebfbff 20000000
00000000 00000000 0000649d 00000000 00000000
[17179572.948000] CPU: After vendor identify, caps: bfebfbff 20000000
00000000 00000000 0000649d 00000000 00000000
[17179572.948000] monitor/mwait feature present.
[17179572.948000] using mwait in idle threads.
[17179572.948000] CPU: Trace cache: 12K uops, L1 D cache: 16K
[17179572.948000] CPU: L2 cache: 2048K
[17179572.948000] CPU: Hyper-Threading is disabled
[17179572.948000] CPU: After all inits, caps: bfebfbff 20000000
00000000 00000080 0000649d 00000000 00000000
[17179572.948000] mtrr: v2.0 (20020519)
[17179572.948000] Enabling fast FPU save and restore... done.
[17179572.948000] Enabling unmasked SIMD FPU exception support... done.
[17179572.948000] Checking 'hlt' instruction... OK.
[17179572.964000] SMP alternatives: switching to UP code
[17179572.964000] checking if image is initramfs... it is
[17179573.448000] Freeing initrd memory: 6809k freed
[17179573.452000] ACPI: Looking for DSDT ... not found!
[17179573.464000] CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 03
[17179573.464000] SMP alternatives: switching to SMP code
[17179573.464000] Booting processor 1/1 eip 3000
[17179573.476000] Initializing CPU#1
[17179573.556000] Calibrating delay using timer specific routine..
6021.78 BogoMIPS (lpj=12043573)
[17179573.556000] CPU: After generic identify, caps: bfebfbff 20000000
00000000 00000000 0000649d 00000000 00000000
[17179573.556000] CPU: After vendor identify, caps: bfebfbff 20000000
00000000 00000000 0000649d 00000000 00000000
[17179573.556000] monitor/mwait feature present.
[17179573.556000] CPU: Trace cache: 12K uops, L1 D cache: 16K
[17179573.556000] CPU: L2 cache: 2048K
[17179573.556000] CPU: Hyper-Threading is disabled
[17179573.556000] CPU: After all inits, caps: bfebfbff 20000000
00000000 00000080 0000649d 00000000 00000000
[17179573.556000] CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 03
[17179573.556000] Total of 2 processors activated (12051.08 BogoMIPS).
[17179573.556000] ENABLING IO-APIC IRQs
[17179573.556000] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[17179573.720000] checking TSC synchronization across 2 CPUs: passed.
[17179573.724000] Brought up 2 CPUs
[17179573.724000] NET: Registered protocol family 16
[17179573.724000] EISA bus registered
[17179573.724000] ACPI: bus type pci registered
[17179573.724000] PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=4
[17179573.724000] PCI: Using MMCONFIG
[17179573.724000] ACPI: Subsystem revision 20051216
[17179573.740000] ACPI: Interpreter enabled
[17179573.740000] ACPI: Using IOAPIC for interrupt routing
[17179573.740000] ACPI: PCI Root Bridge [PCI0] (0000:00)
[17179573.740000] PCI: Probing PCI hardware (bus 00)
[17179573.744000] PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
[17179573.744000] Boot video device is 0000:04:00.0
[17179573.744000] PCI: Transparent bridge - 0000:00:1e.0
[17179573.744000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[17179573.748000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[17179573.748000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[17179573.748000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[17179573.748000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[17179573.756000] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10
11 12 14 15)
[17179573.756000] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10
*11 12 14 15)
[17179573.756000] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10
11 12 14 15)
[17179573.756000] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10
*11 12 14 15)
[17179573.756000] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10
11 12 14 15)
[17179573.756000] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10
*11 12 14 15)
[17179573.756000] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10
11 12 14 15) *0, disabled.
[17179573.756000] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10
*11 12 14 15)
[17179573.756000] Linux Plug and Play Support v0.97 (c) Adam Belay
[17179573.756000] pnp: PnP ACPI init
[17179573.764000] pnp: PnP ACPI: found 16 devices
[17179573.764000] PnPBIOS: Disabled by ACPI PNP
[17179573.764000] PCI: Using ACPI for IRQ routing
[17179573.764000] PCI: If a device doesn't work, try "pci=routeirq".
If it helps, post a report
[17179573.780000] pnp: 00:07: ioport range 0x290-0x297 has been reserved
[17179573.784000] PCI: Bridge: 0000:00:01.0
[17179573.784000]   IO window: e000-efff
[17179573.784000]   MEM window: cff00000-cfffffff
[17179573.784000]   PREFETCH window: d0000000-dfffffff
[17179573.784000] PCI: Bridge: 0000:00:1c.0
[17179573.784000]   IO window: d000-dfff
[17179573.784000]   MEM window: disabled.
[17179573.784000]   PREFETCH window: disabled.
[17179573.784000] PCI: Bridge: 0000:00:1c.4
[17179573.784000]   IO window: c000-cfff
[17179573.784000]   MEM window: cfe00000-cfefffff
[17179573.784000]   PREFETCH window: disabled.
[17179573.784000] PCI: Bridge: 0000:00:1e.0
[17179573.784000]   IO window: b000-bfff
[17179573.784000]   MEM window: cfd00000-cfdfffff
[17179573.784000]   PREFETCH window: 88000000-880fffff
[17179573.784000] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16
(level, low) -> IRQ 169
[17179573.784000] PCI: Setting latency timer of device 0000:00:01.0 to 64
[17179573.784000] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16
(level, low) -> IRQ 169
[17179573.784000] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[17179573.784000] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16
(level, low) -> IRQ 169
[17179573.784000] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[17179573.784000] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[17179573.784000] audit: initializing netlink socket (disabled)
[17179573.784000] audit(1176455394.780:1): initialized
[17179573.784000] highmem bounce pool size: 64 pages
[17179573.784000] VFS: Disk quotas dquot_6.5.1
[17179573.784000] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[17179573.784000] Initializing Cryptographic API
[17179573.784000] io scheduler noop registered
[17179573.784000] io scheduler anticipatory registered
[17179573.784000] io scheduler deadline registered
[17179573.784000] io scheduler cfq registered
[17179573.784000] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16
(level, low) -> IRQ 169
[17179573.784000] PCI: Setting latency timer of device 0000:00:01.0 to 64
[17179573.784000] assign_interrupt_mode Found MSI capability
[17179573.784000] Allocate Port Service[pcie00]
[17179573.784000] Allocate Port Service[pcie03]
[17179573.784000] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16
(level, low) -> IRQ 169
[17179573.784000] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[17179573.784000] assign_interrupt_mode Found MSI capability
[17179573.784000] Allocate Port Service[pcie00]
[17179573.784000] Allocate Port Service[pcie02]
[17179573.784000] Allocate Port Service[pcie03]
[17179573.784000] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16
(level, low) -> IRQ 169
[17179573.784000] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[17179573.784000] assign_interrupt_mode Found MSI capability
[17179573.784000] Allocate Port Service[pcie00]
[17179573.784000] Allocate Port Service[pcie02]
[17179573.784000] Allocate Port Service[pcie03]
[17179573.784000] isapnp: Scanning for PnP cards...
[17179574.136000] isapnp: No Plug & Play device found
[17179574.156000] Real Time Clock Driver v1.12
[17179574.156000] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[17179574.156000] PNP: PS/2 controller doesn't have AUX irq; using default 12
[17179574.160000] serio: i8042 AUX port at 0x60,0x64 irq 12
[17179574.160000] serio: i8042 KBD port at 0x60,0x64 irq 1
[17179574.160000] Serial: 8250/16550 driver $Revision: 1.90 $ 48
ports, IRQ sharing enabled
[17179574.160000] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[17179574.160000] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[17179574.164000] RAMDISK driver initialized: 16 RAM disks of 65536K
size 1024 blocksize
[17179574.164000] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[17179574.164000] ide: Assuming 33MHz system bus speed for PIO modes;
override with idebus=xx
[17179574.164000] mice: PS/2 mouse device common for all mice
[17179574.164000] EISA: Probing bus 0 at eisa.0
[17179574.164000] Cannot allocate resource for EISA slot 8
[17179574.164000] EISA: Detected 0 cards.
[17179574.164000] NET: Registered protocol family 2
[17179574.204000] input: AT Translated Set 2 keyboard as /class/input/input0
[17179574.220000] IP route cache hash table entries: 131072 (order: 7,
524288 bytes)
[17179574.220000] TCP established hash table entries: 262144 (order:
9, 3145728 bytes)
[17179574.224000] TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
[17179574.224000] TCP: Hash tables configured (established 262144 bind 65536)
[17179574.224000] TCP reno registered
[17179574.224000] TCP bic registered
[17179574.224000] NET: Registered protocol family 1
[17179574.224000] NET: Registered protocol family 8
[17179574.224000] NET: Registered protocol family 20
[17179574.224000] Starting balanced_irq
[17179574.224000] Using IPI No-Shortcut mode
[17179574.224000] ACPI wakeup devices:
[17179574.224000] P0P1 P0P3 P0P4 P0P5 P0P6 P0P7 P0P8 P0P9 PS2K UAR1
USB2 USB3 USB4 MC97 USB1 EUSB
[17179574.224000] ACPI: (supports S0 S1 S3 S4 S5)
[17179574.224000] Freeing unused kernel memory: 332k freed
[17179574.272000] vesafb: framebuffer at 0xd0000000, mapped to
0xf8880000, using 10240k, total 16384k
[17179574.272000] vesafb: mode is 1280x1024x32, linelength=5120, pages=2
[17179574.272000] vesafb: protected mode interface info at c000:b540
[17179574.272000] vesafb: scrolling: redraw
[17179574.272000] vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
[17179574.272000] vesafb: Mode is VGA compatible
[17179574.404000] Console: switching to colour frame buffer device 160x64
[17179574.404000] fb0: VESA VGA frame buffer device
[17179574.416000] Capability LSM initialized
[17179574.452000] ACPI: Processor [CPU1] (supports 8 throttling states)
[17179574.928000] ICH7: IDE controller at PCI slot 0000:00:1f.1
[17179574.928000] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22
(level, low) -> IRQ 209
[17179574.928000] ICH7: chipset revision 1
[17179574.928000] ICH7: not 100% native mode: will probe irqs later
[17179574.928000]     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings:
hda:DMA, hdb:pio
[17179574.928000] Probing IDE interface ide0...
[17179575.688000] hda: ASUS DRW-1608P, ATAPI CD/DVD-ROM drive
[17179576.376000] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[17179576.388000] hda: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2000kB
Cache, UDMA(66)
[17179576.388000] Uniform CD-ROM driver Revision: 3.20
[17179576.460000] SCSI subsystem initialized
[17179576.464000] ACPI: bus type scsi registered
[17179576.464000] libata version 1.20 loaded.
[17179576.464000] ata_piix 0000:00:1f.2: version 1.05
[17179576.464000] ata_pci_init_one: pci_dev class+intf: 0x1018f
[17179576.464000] ata_pci_init_one: NO_LEGACY == 0
[17179576.464000] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23
(level, low) -> IRQ 217
[17179576.464000] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[17179576.464000] ata1: PATA max UDMA/133 cmd 0xA800 ctl 0xA402 bmdma
0x9400 irq 217
[17179576.464000] ata2: PATA max UDMA/133 cmd 0xA000 ctl 0x9802 bmdma
0x9408 irq 217
[17179576.632000] ata1: dev 0 cfg 00:0c5a 49:2f00 82:346b 83:7d01
84:4003 85:3469 86:3c01 87:4003 88:207f 93:0000
[17179576.632000] ata1: dev 0 ATA-6, max UDMA/133, 312581808 sectors: LBA48
[17179576.632000] sata_get_dev_handle: SATA dev addr=0x1f0002, handle=0xdffe42e0
[17179576.636000] ata1: dev 0 configured for UDMA/133
[17179576.636000] sata_get_dev_handle: SATA dev addr=0x1f0002, handle=0xdffe42e0
[17179576.640000] scsi0 : ata_piix
[17179577.808000] ata2: disabling port
[17179577.808000] scsi1 : ata_piix
[17179577.808000]   Vendor: ATA       Model: ST3160827AS       Rev: 3.42
[17179577.808000]   Type:   Direct-Access                      ANSI
SCSI revision: 05
[17179577.816000] Driver 'sd' needs updating - please use bus_type methods
[17179577.816000] SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
[17179577.816000] SCSI device sda: drive cache: write back
[17179577.816000] SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
[17179577.816000] SCSI device sda: drive cache: write back
[17179577.816000]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 >
[17179577.888000] sd 0:0:0:0: Attached scsi disk sda
[17179578.268000] usbcore: registered new driver usbfs
[17179578.268000] usbcore: registered new driver hub
[17179578.324000] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20
(level, low) -> IRQ 225
[17179578.324000] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[17179578.324000] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[17179578.324000] ehci_hcd 0000:00:1d.7: debug port 1
[17179578.324000] PCI: cache line size of 128 is not supported by
device 0000:00:1d.7
[17179578.324000] ehci_hcd 0000:00:1d.7: new USB bus registered,
assigned bus number 1
[17179578.324000] ehci_hcd 0000:00:1d.7: irq 225, io mem 0xcfcff800
[17179578.328000] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[17179578.328000] hub 1-0:1.0: USB hub found
[17179578.328000] hub 1-0:1.0: 8 ports detected
[17179578.340000] USB Universal Host Controller Interface driver v2.3
[17179578.340000] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20
(level, low) -> IRQ 225
[17179578.340000] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[17179578.340000] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[17179578.344000] ieee1394: Initialized config rom entry `ip1394'
[17179578.432000] uhci_hcd 0000:00:1d.0: new USB bus registered,
assigned bus number 2
[17179578.432000] uhci_hcd 0000:00:1d.0: irq 225, io base 0x00008000
[17179578.432000] hub 2-0:1.0: USB hub found
[17179578.432000] hub 2-0:1.0: 2 ports detected
[17179578.536000] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17
(level, low) -> IRQ 233
[17179578.536000] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[17179578.536000] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[17179578.536000] uhci_hcd 0000:00:1d.1: new USB bus registered,
assigned bus number 3
[17179578.536000] uhci_hcd 0000:00:1d.1: irq 233, io base 0x00008400
[17179578.536000] hub 3-0:1.0: USB hub found
[17179578.536000] hub 3-0:1.0: 2 ports detected
[17179578.644000] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18
(level, low) -> IRQ 50
[17179578.644000] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[17179578.644000] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[17179578.644000] uhci_hcd 0000:00:1d.2: new USB bus registered,
assigned bus number 4
[17179578.644000] uhci_hcd 0000:00:1d.2: irq 50, io base 0x00008800
[17179578.644000] hub 4-0:1.0: USB hub found
[17179578.644000] hub 4-0:1.0: 2 ports detected
[17179578.748000] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19
(level, low) -> IRQ 58
[17179578.748000] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[17179578.748000] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[17179578.748000] uhci_hcd 0000:00:1d.3: new USB bus registered,
assigned bus number 5
[17179578.748000] uhci_hcd 0000:00:1d.3: irq 58, io base 0x00009000
[17179578.748000] hub 5-0:1.0: USB hub found
[17179578.748000] hub 5-0:1.0: 2 ports detected
[17179578.852000] ohci1394: $Rev: 1313 $ Ben Collins <bcollins@debian.org>
[17179578.852000] ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 21
(level, low) -> IRQ 66
[17179578.868000] usb 1-7: new high speed USB device using ehci_hcd
and address 3
[17179578.900000] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[66]
MMIO=[cfddb800-cfddbfff]  Max Packet=[2048]
[17179578.920000] Probing IDE interface ide1...
[17179579.012000] Initializing USB Mass Storage driver...
[17179579.252000] usb 3-1: new low speed USB device using uhci_hcd and address 2
[17179579.428000] scsi2 : SCSI emulation for USB Mass Storage devices
[17179579.428000] usb-storage: device found at 3
[17179579.428000] usb-storage: waiting for device to settle before scanning
[17179579.428000] usbcore: registered new driver usb-storage
[17179579.428000] USB Mass Storage support registered.
[17179579.564000] usbcore: registered new driver hiddev
[17179579.580000] input: Darfon USB Optical Mouse as /class/input/input1
[17179579.580000] input: USB HID v1.10 Mouse [Darfon USB Optical
Mouse] on usb-0000:00:1d.1-1
[17179579.580000] usbcore: registered new driver usbhid
[17179579.580000] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[17179579.628000] Attempting manual resume
[17179579.656000] EXT3-fs: mounted filesystem with ordered data mode.
[17179579.656000] kjournald starting.  Commit interval 5 seconds
[17179580.172000] ieee1394: Host added: ID:BUS[0-00:1023]
GUID[0011d800003e2806]
[17179583.444000] ts: Compaq touchscreen protocol output
[17179583.508000] sd 0:0:0:0: Attached scsi generic sg0 type 0
[17179584.432000]   Vendor: Kingston  Model: DataTraveler II   Rev: PMAP
[17179584.432000]   Type:   Direct-Access                      ANSI
SCSI revision: 00
[17179584.432000] SCSI device sdb: 4062208 512-byte hdwr sectors (2080 MB)
[17179584.436000] sdb: Write Protect is off
[17179584.436000] sdb: Mode Sense: 23 00 00 00
[17179584.436000] sdb: assuming drive cache: write through
[17179584.440000] SCSI device sdb: 4062208 512-byte hdwr sectors (2080 MB)
[17179584.440000] sdb: Write Protect is off
[17179584.440000] sdb: Mode Sense: 23 00 00 00
[17179584.440000] sdb: assuming drive cache: write through
[17179584.440000]  sdb: sdb1
[17179584.444000] sd 2:0:0:0: Attached scsi removable disk sdb
[17179584.444000] sd 2:0:0:0: Attached scsi generic sg1 type 0
[17179584.444000] usb-storage: device scan complete
[17179585.496000] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[17179585.500000] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[17179585.560000] hw_random: RNG not detected
[17179585.684000] input: PC Speaker as /class/input/input2
[17179585.716000] Floppy drive(s): fd0 is 1.44M
[17179585.724000] parport: PnPBIOS parport detected.
[17179585.724000] parport0: PC-style at 0x378 (0x778), irq 7, dma 3
[PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[17179585.736000] FDC 0 is a post-1991 82077
[17179586.168000] Intel(R) PRO/1000 Network Driver - version 7.0.33-k2
[17179586.168000] Copyright (c) 1999-2005 Intel Corporation.
[17179586.168000] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16
(level, low) -> IRQ 169
[17179586.168000] PCI: Setting latency timer of device 0000:02:00.0 to 64
[17179586.184000] Linux video capture interface: v1.00
[17179586.228000] e1000: 0000:02:00.0: e1000_probe: (PCI
Express:2.5Gb/s:Width x1) 00:13:d4:1f:a7:54
[17179586.296000] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[17179586.296000] ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 21
(level, low) -> IRQ 66
[17179586.296000] skge 1.5 addr 0xcfddc000 irq 66 chip Yukon-Lite rev 9
[17179586.296000] skge eth1: addr 00:13:d4:1f:ab:a0
[17179586.304000] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 19
(level, low) -> IRQ 58
[17179586.304000] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[17179586.384000] saa7130/34: v4l2 driver version 0.2.14 loaded
[17179586.692000] hda_codec: Unknown model for ALC882, trying
auto-probe from BIOS...
[17179586.916000] ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 23
(level, low) -> IRQ 217
[17179586.916000] saa7133[0]: found at 0000:01:02.0, rev: 208, irq:
217, latency: 64, mmio: 0xcfddb000
[17179586.916000] saa7133[0]: subsystem: 1043:8188, board:
UNKNOWN/GENERIC [card=0,autodetected]
[17179586.916000] saa7133[0]: board init: gpio is 0
[17179587.052000] saa7133[0]: i2c eeprom 00: 43 10 88 81 54 20 1c 00
43 43 a9 1c 55 d2 b2 92
[17179587.052000] saa7133[0]: i2c eeprom 10: 00 01 22 00 ff 20 ff ff
ff ff ff ff ff ff ff ff
[17179587.052000] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03
08 ff 00 38 ff ff ff ff
[17179587.052000] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff
[17179587.052000] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32
15 08 ff ff ff ff ff ff
[17179587.052000] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff
[17179587.052000] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff
[17179587.052000] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff
[17179587.052000] saa7133[0]: registered device video0 [v4l2]
[17179587.052000] saa7133[0]: registered device vbi0
[17179587.060000] saa7134 ALSA driver for DMA sound loaded
[17179587.060000] saa7133[0]/alsa: saa7133[0] at 0xcfddb000 irq 217
registered as card -1
[17179587.156000] lp0: using parport0 (interrupt-driven).
[17179587.204000] sbp2: $Rev: 1306 $ Ben Collins <bcollins@debian.org>
[17179587.204000] ieee1394: sbp2: Driver forced to serialize I/O
(serialize_io=1)
[17179587.204000] ieee1394: sbp2: Try serialize_io=0 for better performance
[17179587.248000] Adding 3903752k swap on /dev/sda5.  Priority:-1
extents:1 across:3903752k
[17179587.268000] EXT3 FS on sda2, internal journal
[17179587.376000] md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
[17179587.376000] md: bitmap version 4.39
[17179588.168000] device-mapper: 4.4.0-ioctl (2005-01-12) initialised:
dm-devel@redhat.com
[17179588.540000] cdrom: open failed.
[17179589.360000] kjournald starting.  Commit interval 5 seconds
[17179589.360000] EXT3 FS on sda6, internal journal
[17179589.360000] EXT3-fs: mounted filesystem with ordered data mode.
[17179589.408000] NTFS driver 2.1.25 [Flags: R/O MODULE].
[17179589.476000] NTFS volume version 3.1.
[17179589.500000] kjournald starting.  Commit interval 5 seconds
[17179589.500000] EXT3 FS on sda9, internal journal
[17179589.500000] EXT3-fs: mounted filesystem with ordered data mode.
[17179589.520000] kjournald starting.  Commit interval 5 seconds
[17179589.520000] EXT3 FS on sda7, internal journal
[17179589.520000] EXT3-fs: mounted filesystem with ordered data mode.
[17179589.536000] kjournald starting.  Commit interval 5 seconds
[17179589.536000] EXT3 FS on sda8, internal journal
[17179589.536000] EXT3-fs: mounted filesystem with ordered data mode.
[17179594.328000] ACPI: Power Button (FF) [PWRF]
[17179594.328000] ACPI: Power Button (CM) [PWRB]
[17179594.400000] ibm_acpi: ec object not found
[17179594.452000] pcc_acpi: loading...
[17179598.672000] ppdev: user-space parallel port driver
[17179600.016000] Linux agpgart interface v0.101 (c) Dave Jones
[17179600.172000] fglrx: module license 'Proprietary. (C) 2002 - ATI
Technologies, Starnberg, GERMANY' taints kernel.
[17179600.172000] [fglrx] Maximum main memory to use for locked dma
buffers: 1898 MBytes.
[17179600.172000] [fglrx] module loaded - fglrx 8.33.6 [Jan  8 2007] on minor 0
[17179600.212000] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16
(level, low) -> IRQ 169
[17179602.052000] [fglrx] total      GART = 130023424
[17179602.052000] [fglrx] free       GART = 114032640
[17179602.052000] [fglrx] max single GART = 114032640
[17179602.052000] [fglrx] total      LFB  = 134086656
[17179602.052000] [fglrx] free       LFB  = 116256768
[17179602.052000] [fglrx] max single LFB  = 116256768
[17179602.052000] [fglrx] total      Inv  = 134217728
[17179602.052000] [fglrx] free       Inv  = 134217728
[17179602.052000] [fglrx] max single Inv  = 134217728
[17179602.052000] [fglrx] total      TIM  = 0
[17179616.788000] NET: Registered protocol family 10
[17179616.792000] lo: Disabled Privacy Extensions
[17179616.792000] IPv6 over IPv4 tunneling driver
[17179644.916000] skge eth0: enabling interface
[17179644.940000] ADDRCONF(NETDEV_UP): eth0: link is not ready
[17179645.004000] e1000: eth1: e1000_watchdog_task: NIC Link is Up 100
Mbps Full Duplex
[17179645.004000] e1000: eth1: e1000_watchdog_task: 10/100 speed: disabling TSO
[17179646.604000] skge eth0: Link is up at 100 Mbps, full duplex, flow
control none
[17179646.616000] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[17179655.656000] eth1: no IPv6 routers present
[17179657.188000] eth0: no IPv6 routers present

-- 
Regards,
Denis
