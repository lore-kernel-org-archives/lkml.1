Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbYDABTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbYDABTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 21:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYDABS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 21:18:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:57785 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbYDABSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 21:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qwhV/6PYfIQZ4lMB/CHbPqGDFu2pqBJwrz0/9JYqMOifw4b1c3aNqvoa0HV8QQ5AuUYm6UDflqO8MgJFiUlb1gxaTXXKxkwH3szxOYVoDcFhFNlpsUkIyx8bkNmC58s87m4+7bzchuQbQIl3p9XBmeicZAS9/WLuW8JcYUG0Dhs=
Date: Tue, 1 Apr 2008 05:18:37 +0400
From: Sergey Dolgov <solkaa@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
	2.6.25-rc7
Message-ID: <20080401011837.GA5385@slk.laptop>
References: <20080330074927.GA8178@slk.laptop> <Pine.LNX.4.44L0.0803301456560.21506-100000@netrider.rowland.org> <20080330223212.GB8178@slk.laptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20080330223212.GB8178@slk.laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 31, 2008 at 02:32:12AM +0400, Sergey Dolgov wrote:
> On Sun, Mar 30, 2008 at 02:59:49PM -0400, Alan Stern wrote:
> > On Sun, 30 Mar 2008, Sergey Dolgov wrote:
> > 
> > Can you build both 2.6.24.4 and 2.6.25-rc7 with
> > CONFIG_USB_STORAGE_DEBUG enabled, and post the dmesg logs from both
> > kernels showing what happens when the SDHC card is probed during boot?
> > Comparing the two logs should indicate where the crucial difference 
> > lies.
> 
> The dmesg output for 2.6.25-rc7 with USB storage debugging enabled is
> attached. I hope to produce the same for 2.6.24.4 on Monday.
> 

Here goes...

-- 
Sergey

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.24.8G-dbg"

[    0.000000] Linux version 2.6.24.4-storage-dbg (root@slke) (gcc version 4.2.3 (Debian 4.2.3-3)) #1 Tue Apr 1 00:40:57 MSD 2008
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
[    0.000000] 503MB LOWMEM available.
[    0.000000] found SMP MP-table at 000ff780
[    0.000000] Entering add_active_range(0, 0, 128896) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   128896
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   128896
[    0.000000] On node 0 totalpages: 128896
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 975 pages used for memmap
[    0.000000]   Normal zone: 123825 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000FBE60, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 1F780000, 0034 (r1 A M I  OEMRSDT   1000808 MSFT       97)
[    0.000000] ACPI: FACP 1F780200, 0081 (r1 A M I  OEMFACP   1000808 MSFT       97)
[    0.000000] ACPI: DSDT 1F780400, 5F2B (r1  A0797 A0797000        0 INTL 20051117)
[    0.000000] ACPI: FACS 1F790000, 0040
[    0.000000] ACPI: APIC 1F780390, 0068 (r1 A M I  OEMAPIC   1000808 MSFT       97)
[    0.000000] ACPI: OEMB 1F790040, 0046 (r1 A M I  AMI_OEM   1000808 MSFT       97)
[    0.000000] ACPI: MCFG 1F786330, 003C (r1 A M I  OEMMCFG   1000808 MSFT       97)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:13 APIC version 20
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
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 1f800000:df600000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e4000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e4000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 127889
[    0.000000] Kernel command line: root=LABEL=root ro 
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 630.072 MHz processor.
[   13.122224] Console: colour VGA+ 80x25
[   13.122233] console [tty0] enabled
[   13.127442] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[   13.128148] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[   13.154801] Memory: 504936k/515584k available (1979k kernel code, 10052k reserved, 925k data, 224k init, 0k highmem)
[   13.154965] virtual kernel memory layout:
[   13.154968]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
[   13.154971]     vmalloc : 0xe0000000 - 0xfffb3000   ( 511 MB)
[   13.154975]     lowmem  : 0xc0000000 - 0xdf780000   ( 503 MB)
[   13.154978]       .init : 0xc03da000 - 0xc0412000   ( 224 kB)
[   13.154981]       .data : 0xc02eef8c - 0xc03d6694   ( 925 kB)
[   13.154984]       .text : 0xc0100000 - 0xc02eef8c   (1979 kB)
[   13.155637] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   13.155899] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
[   13.306041] Calibrating delay using timer specific routine.. 1261.19 BogoMIPS (lpj=6305978)
[   13.306276] Mount-cache hash table entries: 512
[   13.306618] CPU: After generic identify, caps: afe9fbff 00100000 00000000 00000000 00000000 00000000 00000000 00000000
[   13.306644] CPU: L1 I cache: 32K, L1 D cache: 32K
[   13.306785] CPU: L2 cache: 512K
[   13.306873] CPU: After all inits, caps: afe9fbff 00100000 00000000 00002040 00000000 00000000 00000000 00000000
[   13.306889] Intel machine check architecture supported.
[   13.306993] Intel machine check reporting enabled on CPU#0.
[   13.307094] Compat vDSO mapped to ffffe000.
[   13.307209] CPU: Intel(R) Celeron(R) M processor          900MHz stepping 08
[   13.307405] Checking 'hlt' instruction... OK.
[   13.350959] Freeing SMP alternatives: 0k freed
[   13.351055] ACPI: Core revision 20070126
[   13.360267] Parsing all Control Methods:
[   13.360677] Table [DSDT](id 0001) - 841 Objects with 56 Devices 257 Methods 20 Regions
[   13.360887]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
[   13.578921] evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
[   13.579445] ENABLING IO-APIC IRQs
[   13.579760] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   13.796293] net_namespace: 64 bytes
[   13.796409] Booting paravirtualized kernel on bare hardware
[   13.797628] NET: Registered protocol family 16
[   13.798090] No dock devices found.
[   13.798394] ACPI: bus type pci registered
[   13.798665] PCI: Using configuration type 1
[   13.798758] Setting up standard PCI resources
[   13.818498] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
[   13.823476] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 9 Wake, Enabled 0 Runtime GPEs in this block
[   13.823717] ACPI: EC: Look up EC in DSDT
[   13.825917] Completing Region/Field/Buffer/Package initialization:..............................................................................................
[   13.837030] Initialized 19/20 Regions 18/18 Fields 33/34 Buffers 24/26 Packages (850 nodes)
[   13.837242] Initializing Device/Processor/Thermal objects by executing _INI methods:..
[   13.865694] Executed 2 _INI methods requiring 0 _STA executions (examined 60 objects)
[   13.865919] ACPI: Interpreter enabled
[   13.866015] ACPI: (supports S0 S1 S3 S4 S5)
[   13.866372] ACPI: Using IOAPIC for interrupt routing
[   13.885742] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[   13.885856] ACPI: EC: driver started in poll mode
[   13.886442] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   13.887486] Force enabled HPET at base address 0xfed00000
[   13.887501] PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[   13.887606] PCI quirk: region 0480-04bf claimed by ICH6 GPIO
[   13.888566] PCI: Transparent bridge - 0000:00:1e.0
[   13.888720] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   13.889176] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[   13.889436] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[   13.889683] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[   13.904352] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   13.905364] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   13.906381] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   13.907381] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[   13.908392] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   13.909519] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   13.910641] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   13.911757] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[   13.912730] Linux Plug and Play Support v0.97 (c) Adam Belay
[   13.912909] pnp: PnP ACPI init
[   13.913013] ACPI: bus type pnp registered
[   13.919090] pnp: PnP ACPI: found 13 devices
[   13.919189] ACPI: ACPI bus type pnp unregistered
[   13.919727] SCSI subsystem initialized
[   13.919878] libata version 3.00 loaded.
[   13.920229] PCI: Using ACPI for IRQ routing
[   13.920324] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   13.936424] hpet clockevent registered
[   13.945977] Time: tsc clocksource has been installed.
[   13.966083] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[   13.966207] system 00:08: ioport range 0x380-0x383 has been reserved
[   13.966310] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[   13.966413] system 00:08: ioport range 0x800-0x87f has been reserved
[   13.966516] system 00:08: ioport range 0x480-0x4bf has been reserved
[   13.966620] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[   13.966728] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[   13.966835] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
[   13.966977] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[   13.967083] system 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
[   13.967225] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[   13.967341] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[   13.967454] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   13.967560] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
[   13.967665] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   13.967770] system 00:0c: iomem range 0x100000-0x1f7fffff could not be reserved
[   13.967905] system 00:0c: iomem range 0x0-0x0 could not be reserved
[   13.998894] PCI: Bridge: 0000:00:1c.0
[   13.998990]   IO window: disabled.
[   13.999083]   MEM window: disabled.
[   13.999173]   PREFETCH window: disabled.
[   13.999268] PCI: Bridge: 0000:00:1c.1
[   13.999356]   IO window: disabled.
[   13.999448]   MEM window: fbf00000-fbffffff
[   13.999541]   PREFETCH window: disabled.
[   13.999635] PCI: Bridge: 0000:00:1c.2
[   13.999724]   IO window: disabled.
[   13.999816]   MEM window: f8000000-fbefffff
[   13.999910]   PREFETCH window: f0000000-f6ffffff
[   14.000007] PCI: Bridge: 0000:00:1e.0
[   14.000095]   IO window: disabled.
[   14.000186]   MEM window: disabled.
[   14.000276]   PREFETCH window: disabled.
[   14.000423] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[   14.000607] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   14.000637] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[   14.000818] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   14.000847] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[   14.001028] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   14.001045] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   14.001070] NET: Registered protocol family 2
[   14.096096] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[   14.096649] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[   14.097038] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[   14.097275] TCP: Hash tables configured (established 16384 bind 16384)
[   14.097376] TCP reno registered
[   14.126253] checking if image is initramfs... it is
[   14.445936] Switched to high resolution mode on CPU 0
[   14.611616] Freeing initrd memory: 2006k freed
[   14.619203] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[   14.619355] io scheduler noop registered
[   14.619446] io scheduler deadline registered (default)
[   14.619556] Boot video device is 0000:00:02.0
[   14.619899] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   14.619956] assign_interrupt_mode Found MSI capability
[   14.620055] Allocate Port Service[0000:00:1c.0:pcie00]
[   14.620156] Allocate Port Service[0000:00:1c.0:pcie02]
[   14.620320] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   14.620377] assign_interrupt_mode Found MSI capability
[   14.620476] Allocate Port Service[0000:00:1c.1:pcie00]
[   14.620559] Allocate Port Service[0000:00:1c.1:pcie02]
[   14.620708] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   14.620764] assign_interrupt_mode Found MSI capability
[   14.620863] Allocate Port Service[0000:00:1c.2:pcie00]
[   14.620949] Allocate Port Service[0000:00:1c.2:pcie02]
[   14.685698] Linux agpgart interface v0.102
[   14.685915] agpgart: Detected an Intel 915GM Chipset.
[   14.686503] agpgart: Detected 7932K stolen memory.
[   14.716330] agpgart: AGP aperture is 256M @ 0xd0000000
[   14.716564] [drm] Initialized drm 1.1.0 20060810
[   14.716710] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[   14.716893] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   14.717065] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   14.718460] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
[   14.719256] loop: module loaded
[   14.719360] tun: Universal TUN/TAP device driver, 1.6
[   14.719455] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   14.719711] Driver 'sd' needs updating - please use bus_type methods
[   14.719963] ata_piix 0000:00:1f.2: version 2.12
[   14.719977] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[   14.720306] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[   14.720553] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   14.720705] scsi0 : ata_piix
[   14.720959] scsi1 : ata_piix
[   14.725120] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[   14.725230] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[   15.066225] ata2.00: ATA-4: SILICONMOTION SM223AC, , max UDMA/66
[   15.066328] ata2.00: 7815024 sectors, multi 0: LBA 
[   15.066450] ata2.00: limited to UDMA/33 due to 40-wire cable
[   15.106159] ata2.00: configured for UDMA/33
[   15.106518] scsi 1:0:0:0: Direct-Access     ATA      SILICONMOTION SM n/a  PQ: 0 ANSI: 5
[   15.106968] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors (4001 MB)
[   15.107096] sd 1:0:0:0: [sda] Write Protect is off
[   15.107193] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   15.107237] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   15.107486] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors (4001 MB)
[   15.107607] sd 1:0:0:0: [sda] Write Protect is off
[   15.107701] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   15.107739] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   15.107881]  sda: sda1 sda2
[   15.108766] sd 1:0:0:0: [sda] Attached SCSI disk
[   15.109319] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   15.141253] serio: i8042 KBD port at 0x60,0x64 irq 1
[   15.141356] serio: i8042 AUX port at 0x60,0x64 irq 12
[   15.141771] mice: PS/2 mouse device common for all mice
[   15.168492] input: AT Translated Set 2 keyboard as /class/input/input0
[   15.234297] cpuidle: using governor ladder
[   15.234391] cpuidle: using governor menu
[   15.236933] TCP cubic registered
[   15.237060] NET: Registered protocol family 1
[   15.237179] NET: Registered protocol family 17
[   15.237279] Using IPI Shortcut mode
[   15.237431] registered taskstats version 1
[   15.237951] Freeing unused kernel memory: 224k freed
[   15.401417] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   15.401704] ACPI: Processor [CPU1] (supports 8 throttling states)
[   15.406179] ACPI: EC: non-query interrupt received, switching to interrupt mode
[   15.411506] Marking TSC unstable due to: TSC halts in idle.
[   15.412128] ACPI: Thermal Zone [TZ00] (51 C)
[   15.416015] Time: hpet clocksource has been installed.
[   16.165478] Synaptics Touchpad, model: 1, fw: 6.5, id: 0x1c0b1, caps: 0xa04751/0xa00000
[   16.252669] input: SynPS/2 Synaptics TouchPad as /class/input/input1
[   17.175353] usbcore: registered new interface driver usbfs
[   17.175553] usbcore: registered new interface driver hub
[   17.180715] usbcore: registered new device driver usb
[   17.183832] USB Universal Host Controller Interface driver v3.0
[   17.184050] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 20
[   17.184246] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   17.184257] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   17.184784] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   17.184962] uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000e400
[   17.185375] usb usb1: configuration #1 chosen from 1 choice
[   17.185897] hub 1-0:1.0: USB hub found
[   17.186004] hub 1-0:1.0: 2 ports detected
[   17.295811] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   17.296016] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   17.296028] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   17.296177] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   17.296359] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
[   17.296753] usb usb2: configuration #1 chosen from 1 choice
[   17.296907] hub 2-0:1.0: USB hub found
[   17.297008] hub 2-0:1.0: 2 ports detected
[   17.359487] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[   17.359691] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   17.359703] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   17.359853] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[   17.360025] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[   17.360391] usb usb3: configuration #1 chosen from 1 choice
[   17.360550] hub 3-0:1.0: USB hub found
[   17.360648] hub 3-0:1.0: 2 ports detected
[   17.362958] Clocksource tsc unstable (delta = -72540628 ns)
[   17.364510] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[   17.364703] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   17.364713] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   17.364863] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[   17.365033] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
[   17.365391] usb usb4: configuration #1 chosen from 1 choice
[   17.365551] hub 4-0:1.0: USB hub found
[   17.365655] hub 4-0:1.0: 2 ports detected
[   17.370320] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 20
[   17.370518] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   17.370526] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   17.370682] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[   17.374744] ehci_hcd 0000:00:1d.7: debug port 1
[   17.374843] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   17.374858] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf7eb7c00
[   17.389918] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   17.390373] usb usb5: configuration #1 chosen from 1 choice
[   17.390534] hub 5-0:1.0: USB hub found
[   17.390637] hub 5-0:1.0: 8 ports detected
[   17.537982] kjournald starting.  Commit interval 5 seconds
[   17.538107] EXT3-fs: mounted filesystem with ordered data mode.
[   17.825045] usb 5-5: new high speed USB device using ehci_hcd and address 2
[   17.964111] usb 5-5: configuration #1 chosen from 1 choice
[   18.242593] usb 5-8: new high speed USB device using ehci_hcd and address 3
[   18.394447] usb 5-8: configuration #1 chosen from 1 choice
[   18.405367] usbcore: registered new interface driver libusual
[   18.426078] Initializing USB Mass Storage driver...
[   18.426248] usb-storage: USB Mass Storage device detected
[   18.437628] usb-storage: -- associate_dev
[   18.437642] usb-storage: Vendor: 0x0951, Product: 0x1606, Revision: 0x0100
[   18.437648] usb-storage: Interface Subclass: 0x06, Protocol: 0x50
[   18.437664] usb-storage: Transport: Bulk
[   18.437668] usb-storage: Protocol: Transparent SCSI
[   18.453532] scsi2 : SCSI emulation for USB Mass Storage devices
[   18.453766] usb-storage: *** thread sleeping.
[   18.464863] usbcore: registered new interface driver usb-storage
[   18.464981] USB Mass Storage support registered.
[   18.465273] usb-storage: device found at 2
[   18.465278] usb-storage: waiting for device to settle before scanning
[   20.156603] input: Power Button (FF) as /class/input/input2
[   20.232723] ACPI: Power Button (FF) [PWRF]
[   20.233014] input: Lid Switch as /class/input/input3
[   20.276797] ACPI: Lid Switch [LID]
[   20.277078] input: Sleep Button (CM) as /class/input/input4
[   20.342374] ACPI: Sleep Button (CM) [SLPB]
[   20.342622] input: Power Button (CM) as /class/input/input5
[   20.389007] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[   20.389234] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   20.422330] ACPI: Power Button (CM) [PWRB]
[   20.583876] power_supply AC0: uevent
[   20.583886] power_supply AC0: No power supply yet
[   20.583910] power_supply AC0: power_supply_changed
[   20.583930] ACPI: AC Adapter [AC0] (on-line)
[   20.584042] power_supply AC0: power_supply_changed_work
[   20.584049] power_supply AC0: power_supply_update_gen_leds 1
[   20.584065] power_supply AC0: uevent
[   20.584069] power_supply AC0: POWER_SUPPLY_NAME=AC0
[   20.584079] power_supply AC0: Static prop TYPE=Mains
[   20.584085] power_supply AC0: 1 dynamic props
[   20.584092] power_supply AC0: prop ONLINE=1
[   20.667703] input: Video Bus as /class/input/input6
[   20.742319] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[   21.017292] power_supply BAT0: uevent
[   21.017304] power_supply BAT0: No power supply yet
[   21.017353] power_supply BAT0: power_supply_changed
[   21.017372] power_supply BAT0: power_supply_changed_work
[   21.032677] power_supply BAT0: power_supply_update_bat_leds 4
[   21.032710] power_supply BAT0: uevent
[   21.032715] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[   21.032728] power_supply BAT0: Static prop TYPE=Battery
[   21.032734] power_supply BAT0: 11 dynamic props
[   21.032741] power_supply BAT0: prop STATUS=Full
[   21.032749] power_supply BAT0: prop PRESENT=1
[   21.032757] power_supply BAT0: prop TECHNOLOGY=Li-ion
[   21.032766] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=8400000
[   21.032773] power_supply BAT0: prop VOLTAGE_NOW=8372000
[   21.032781] power_supply BAT0: prop CURRENT_NOW=-1000
[   21.032788] power_supply BAT0: prop CHARGE_FULL_DESIGN=5200000
[   21.032796] power_supply BAT0: prop CHARGE_FULL=100000
[   21.032804] power_supply BAT0: prop CHARGE_NOW=100000
[   21.032811] power_supply BAT0: prop MODEL_NAME=701
[   21.032818] power_supply BAT0: prop MANUFACTURER=ASUS
[   21.047114] ACPI: Battery Slot [BAT0] (battery present)
[   21.283113] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
[   23.252178] EXT3 FS on sda2, internal journal
[   23.398685] usb-storage: usb_stor_control_msg: rq=fe rqtype=a1 value=0000 index=00 len=1
[   23.398783] usb-storage: GetMaxLUN command result is 1, data is 0
[   23.398897] usb-storage: queuecommand called
[   23.398913] usb-storage: *** thread awakened.
[   23.398919] usb-storage: Command INQUIRY (6 bytes)
[   23.398923] usb-storage:  12 00 00 00 24 00
[   23.398940] usb-storage: Bulk Command S 0x43425355 T 0x1 L 36 F 128 Trg 0 LUN 0 CL 6
[   23.398947] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.399026] usb-storage: Status code 0; transferred 31/31
[   23.399034] usb-storage: -- transfer complete
[   23.399038] usb-storage: Bulk command transfer result=0
[   23.399044] usb-storage: usb_stor_bulk_transfer_sglist: xfer 36 bytes, 1 entries
[   23.399149] usb-storage: Status code 0; transferred 36/36
[   23.399154] usb-storage: -- transfer complete
[   23.399158] usb-storage: Bulk data transfer result 0x0
[   23.399163] usb-storage: Attempting to get CSW...
[   23.399167] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.399273] usb-storage: Status code 0; transferred 13/13
[   23.399277] usb-storage: -- transfer complete
[   23.399281] usb-storage: Bulk status result = 0
[   23.399287] usb-storage: Bulk Status S 0x53425355 T 0x1 R 0 Stat 0x0
[   23.399293] usb-storage: scsi cmd done, result=0x0
[   23.399301] usb-storage: *** thread sleeping.
[   23.399384] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
[   23.399738] usb-storage: queuecommand called
[   23.400300] usb-storage: *** thread awakened.
[   23.400309] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.400314] usb-storage:  00 00 00 00 00 00
[   23.400326] usb-storage: Bulk Command S 0x43425355 T 0x2 L 0 F 0 Trg 0 LUN 0 CL 6
[   23.400334] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.400583] usb-storage: Status code 0; transferred 31/31
[   23.400589] usb-storage: -- transfer complete
[   23.400594] usb-storage: Bulk command transfer result=0
[   23.400599] usb-storage: Attempting to get CSW...
[   23.400604] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.762989] usb-storage: Status code 0; transferred 13/13
[   23.762998] usb-storage: -- transfer complete
[   23.763003] usb-storage: Bulk status result = 0
[   23.763010] usb-storage: Bulk Status S 0x53425355 T 0x2 R 0 Stat 0x1
[   23.763016] usb-storage: -- transport indicates command failure
[   23.763021] usb-storage: Issuing auto-REQUEST_SENSE
[   23.763031] usb-storage: Bulk Command S 0x43425355 T 0x3 L 18 F 128 Trg 0 LUN 0 CL 6
[   23.763038] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.763097] usb-storage: Status code 0; transferred 31/31
[   23.763101] usb-storage: -- transfer complete
[   23.763106] usb-storage: Bulk command transfer result=0
[   23.763112] usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
[   23.763346] usb-storage: Status code 0; transferred 18/18
[   23.763351] usb-storage: -- transfer complete
[   23.763355] usb-storage: Bulk data transfer result 0x0
[   23.763359] usb-storage: Attempting to get CSW...
[   23.763364] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.763469] usb-storage: Status code 0; transferred 13/13
[   23.763473] usb-storage: -- transfer complete
[   23.763477] usb-storage: Bulk status result = 0
[   23.763483] usb-storage: Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
[   23.763489] usb-storage: -- Result from auto-sense is 0
[   23.763495] usb-storage: -- code: 0x70, key: 0x6, ASC: 0x28, ASCQ: 0x0
[   23.763501] usb-storage: (Unknown Key): (unknown ASC/ASCQ)
[   23.763508] usb-storage: scsi cmd done, result=0x2
[   23.763517] usb-storage: *** thread sleeping.
[   23.763571] usb-storage: queuecommand called
[   23.763579] usb-storage: *** thread awakened.
[   23.763585] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.763590] usb-storage:  00 00 00 00 00 00
[   23.763602] usb-storage: Bulk Command S 0x43425355 T 0x4 L 0 F 0 Trg 0 LUN 0 CL 6
[   23.763608] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.763722] usb-storage: Status code 0; transferred 31/31
[   23.763726] usb-storage: -- transfer complete
[   23.763731] usb-storage: Bulk command transfer result=0
[   23.763735] usb-storage: Attempting to get CSW...
[   23.763740] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.763969] usb-storage: Status code 0; transferred 13/13
[   23.763974] usb-storage: -- transfer complete
[   23.763978] usb-storage: Bulk status result = 0
[   23.763983] usb-storage: Bulk Status S 0x53425355 T 0x4 R 0 Stat 0x0
[   23.763991] usb-storage: scsi cmd done, result=0x0
[   23.763997] usb-storage: *** thread sleeping.
[   23.764029] usb-storage: queuecommand called
[   23.764037] usb-storage: *** thread awakened.
[   23.764042] usb-storage: Command READ_CAPACITY (10 bytes)
[   23.764047] usb-storage:  25 00 00 00 00 00 00 00 00 00
[   23.764061] usb-storage: Bulk Command S 0x43425355 T 0x5 L 8 F 128 Trg 0 LUN 0 CL 10
[   23.764068] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.764223] usb-storage: Status code 0; transferred 31/31
[   23.764227] usb-storage: -- transfer complete
[   23.764232] usb-storage: Bulk command transfer result=0
[   23.764238] usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
[   23.764469] usb-storage: Status code 0; transferred 8/8
[   23.764473] usb-storage: -- transfer complete
[   23.764477] usb-storage: Bulk data transfer result 0x0
[   23.764482] usb-storage: Attempting to get CSW...
[   23.764487] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.764592] usb-storage: Status code 0; transferred 13/13
[   23.764597] usb-storage: -- transfer complete
[   23.764601] usb-storage: Bulk status result = 0
[   23.764607] usb-storage: Bulk Status S 0x53425355 T 0x5 R 0 Stat 0x0
[   23.764612] usb-storage: scsi cmd done, result=0x0
[   23.764618] usb-storage: *** thread sleeping.
[   23.764639] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors (8018 MB)
[   23.764764] usb-storage: queuecommand called
[   23.764773] usb-storage: *** thread awakened.
[   23.764778] usb-storage: Command MODE_SENSE (6 bytes)
[   23.764783] usb-storage:  1a 00 3f 00 c0 00
[   23.764794] usb-storage: Bulk Command S 0x43425355 T 0x6 L 192 F 128 Trg 0 LUN 0 CL 6
[   23.764801] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.764847] usb-storage: Status code 0; transferred 31/31
[   23.764852] usb-storage: -- transfer complete
[   23.764856] usb-storage: Bulk command transfer result=0
[   23.764862] usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
[   23.765098] usb-storage: Status code -121; transferred 4/192
[   23.765103] usb-storage: -- short read transfer
[   23.765108] usb-storage: Bulk data transfer result 0x1
[   23.765112] usb-storage: Attempting to get CSW...
[   23.765117] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.765343] usb-storage: Status code 0; transferred 13/13
[   23.765347] usb-storage: -- transfer complete
[   23.765351] usb-storage: Bulk status result = 0
[   23.765357] usb-storage: Bulk Status S 0x53425355 T 0x6 R 188 Stat 0x0
[   23.765363] usb-storage: scsi cmd done, result=0x0
[   23.765368] usb-storage: *** thread sleeping.
[   23.765386] sd 2:0:0:0: [sdb] Write Protect is off
[   23.765484] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   23.765490] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   23.765695] usb-storage: queuecommand called
[   23.765711] usb-storage: *** thread awakened.
[   23.765716] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.765720] usb-storage:  00 00 00 00 00 00
[   23.765732] usb-storage: Bulk Command S 0x43425355 T 0x7 L 0 F 0 Trg 0 LUN 0 CL 6
[   23.765739] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.765850] usb-storage: Status code 0; transferred 31/31
[   23.765854] usb-storage: -- transfer complete
[   23.765859] usb-storage: Bulk command transfer result=0
[   23.765864] usb-storage: Attempting to get CSW...
[   23.765869] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.766093] usb-storage: Status code 0; transferred 13/13
[   23.766097] usb-storage: -- transfer complete
[   23.766101] usb-storage: Bulk status result = 0
[   23.766107] usb-storage: Bulk Status S 0x53425355 T 0x7 R 0 Stat 0x0
[   23.766113] usb-storage: scsi cmd done, result=0x0
[   23.766118] usb-storage: *** thread sleeping.
[   23.766139] usb-storage: queuecommand called
[   23.766147] usb-storage: *** thread awakened.
[   23.766152] usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
[   23.766156] usb-storage:  1e 00 00 00 01 00
[   23.766170] usb-storage: Bulk Command S 0x43425355 T 0x8 L 0 F 0 Trg 0 LUN 0 CL 6
[   23.766177] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.766220] usb-storage: Status code 0; transferred 31/31
[   23.766225] usb-storage: -- transfer complete
[   23.766229] usb-storage: Bulk command transfer result=0
[   23.766234] usb-storage: Attempting to get CSW...
[   23.766239] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.766470] usb-storage: Status code 0; transferred 13/13
[   23.766475] usb-storage: -- transfer complete
[   23.766479] usb-storage: Bulk status result = 0
[   23.766485] usb-storage: Bulk Status S 0x53425355 T 0x8 R 0 Stat 0x1
[   23.766490] usb-storage: -- transport indicates command failure
[   23.766498] usb-storage: Issuing auto-REQUEST_SENSE
[   23.766505] usb-storage: Bulk Command S 0x43425355 T 0x9 L 18 F 128 Trg 0 LUN 0 CL 6
[   23.766511] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.766595] usb-storage: Status code 0; transferred 31/31
[   23.766600] usb-storage: -- transfer complete
[   23.766604] usb-storage: Bulk command transfer result=0
[   23.766610] usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
[   23.766845] usb-storage: Status code 0; transferred 18/18
[   23.766849] usb-storage: -- transfer complete
[   23.766853] usb-storage: Bulk data transfer result 0x0
[   23.766858] usb-storage: Attempting to get CSW...
[   23.766863] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.766969] usb-storage: Status code 0; transferred 13/13
[   23.766973] usb-storage: -- transfer complete
[   23.766978] usb-storage: Bulk status result = 0
[   23.766983] usb-storage: Bulk Status S 0x53425355 T 0x9 R 0 Stat 0x0
[   23.766989] usb-storage: -- Result from auto-sense is 0
[   23.766995] usb-storage: -- code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0
[   23.767000] usb-storage: (Unknown Key): (unknown ASC/ASCQ)
[   23.767006] usb-storage: scsi cmd done, result=0x2
[   23.767012] usb-storage: *** thread sleeping.
[   23.767041] usb-storage: queuecommand called
[   23.767050] usb-storage: *** thread awakened.
[   23.767055] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.767059] usb-storage:  00 00 00 00 00 00
[   23.767070] usb-storage: Bulk Command S 0x43425355 T 0xa L 0 F 0 Trg 0 LUN 0 CL 6
[   23.767076] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.767222] usb-storage: Status code 0; transferred 31/31
[   23.767227] usb-storage: -- transfer complete
[   23.767232] usb-storage: Bulk command transfer result=0
[   23.767236] usb-storage: Attempting to get CSW...
[   23.767241] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.767468] usb-storage: Status code 0; transferred 13/13
[   23.767473] usb-storage: -- transfer complete
[   23.767477] usb-storage: Bulk status result = 0
[   23.767483] usb-storage: Bulk Status S 0x53425355 T 0xa R 0 Stat 0x0
[   23.767488] usb-storage: scsi cmd done, result=0x0
[   23.767493] usb-storage: *** thread sleeping.
[   23.767515] usb-storage: queuecommand called
[   23.767522] usb-storage: *** thread awakened.
[   23.767527] usb-storage: Command READ_CAPACITY (10 bytes)
[   23.767531] usb-storage:  25 00 00 00 00 00 00 00 00 00
[   23.767546] usb-storage: Bulk Command S 0x43425355 T 0xb L 8 F 128 Trg 0 LUN 0 CL 10
[   23.767552] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.767598] usb-storage: Status code 0; transferred 31/31
[   23.767602] usb-storage: -- transfer complete
[   23.767607] usb-storage: Bulk command transfer result=0
[   23.767613] usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
[   23.767844] usb-storage: Status code 0; transferred 8/8
[   23.767848] usb-storage: -- transfer complete
[   23.767852] usb-storage: Bulk data transfer result 0x0
[   23.767857] usb-storage: Attempting to get CSW...
[   23.767862] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.767966] usb-storage: Status code 0; transferred 13/13
[   23.767971] usb-storage: -- transfer complete
[   23.767975] usb-storage: Bulk status result = 0
[   23.767984] usb-storage: Bulk Status S 0x53425355 T 0xb R 0 Stat 0x0
[   23.767989] usb-storage: scsi cmd done, result=0x0
[   23.767995] usb-storage: *** thread sleeping.
[   23.768011] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors (8018 MB)
[   23.768123] usb-storage: queuecommand called
[   23.768132] usb-storage: *** thread awakened.
[   23.768138] usb-storage: Command MODE_SENSE (6 bytes)
[   23.768142] usb-storage:  1a 00 3f 00 c0 00
[   23.768153] usb-storage: Bulk Command S 0x43425355 T 0xc L 192 F 128 Trg 0 LUN 0 CL 6
[   23.768160] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.768224] usb-storage: Status code 0; transferred 31/31
[   23.768228] usb-storage: -- transfer complete
[   23.768233] usb-storage: Bulk command transfer result=0
[   23.768238] usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
[   23.768470] usb-storage: Status code -121; transferred 4/192
[   23.768477] usb-storage: -- short read transfer
[   23.768481] usb-storage: Bulk data transfer result 0x1
[   23.768486] usb-storage: Attempting to get CSW...
[   23.768491] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.768621] usb-storage: Status code 0; transferred 13/13
[   23.768625] usb-storage: -- transfer complete
[   23.768630] usb-storage: Bulk status result = 0
[   23.768635] usb-storage: Bulk Status S 0x53425355 T 0xc R 188 Stat 0x0
[   23.768643] usb-storage: scsi cmd done, result=0x0
[   23.768648] usb-storage: *** thread sleeping.
[   23.768664] sd 2:0:0:0: [sdb] Write Protect is off
[   23.768770] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   23.768776] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   23.768884]  sdb:<7>usb-storage: queuecommand called
[   23.769064] usb-storage: *** thread awakened.
[   23.769073] usb-storage: Command READ_10 (10 bytes)
[   23.769077] usb-storage:  28 00 00 00 00 00 00 00 08 00
[   23.769092] usb-storage: Bulk Command S 0x43425355 T 0xd L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.769099] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.769219] usb-storage: Status code 0; transferred 31/31
[   23.769224] usb-storage: -- transfer complete
[   23.769228] usb-storage: Bulk command transfer result=0
[   23.769234] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.771722] usb-storage: Status code 0; transferred 4096/4096
[   23.771727] usb-storage: -- transfer complete
[   23.771731] usb-storage: Bulk data transfer result 0x0
[   23.771736] usb-storage: Attempting to get CSW...
[   23.771741] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.771846] usb-storage: Status code 0; transferred 13/13
[   23.771850] usb-storage: -- transfer complete
[   23.771855] usb-storage: Bulk status result = 0
[   23.771860] usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x0
[   23.771866] usb-storage: scsi cmd done, result=0x0
[   23.771872] usb-storage: *** thread sleeping.
[   23.771894]  sdb1 sdb2
[   23.772249] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   23.772524] usb-storage: queuecommand called
[   23.773023] usb-storage: *** thread awakened.
[   23.773031] usb-storage: Bad target number (1:0)
[   23.773037] usb-storage: scsi cmd done, result=0x40000
[   23.773045] usb-storage: *** thread sleeping.
[   23.773368] usb-storage: queuecommand called
[   23.773384] usb-storage: *** thread awakened.
[   23.773388] usb-storage: Bad target number (2:0)
[   23.773393] usb-storage: scsi cmd done, result=0x40000
[   23.773400] usb-storage: *** thread sleeping.
[   23.773465] usb-storage: queuecommand called
[   23.773475] usb-storage: *** thread awakened.
[   23.773480] usb-storage: Bad target number (3:0)
[   23.773484] usb-storage: scsi cmd done, result=0x40000
[   23.773490] usb-storage: *** thread sleeping.
[   23.774805] usb-storage: queuecommand called
[   23.774826] usb-storage: *** thread awakened.
[   23.774831] usb-storage: Bad target number (4:0)
[   23.774836] usb-storage: scsi cmd done, result=0x40000
[   23.774846] usb-storage: *** thread sleeping.
[   23.774914] usb-storage: queuecommand called
[   23.774924] usb-storage: *** thread awakened.
[   23.774929] usb-storage: Bad target number (5:0)
[   23.774933] usb-storage: scsi cmd done, result=0x40000
[   23.774939] usb-storage: *** thread sleeping.
[   23.774994] usb-storage: queuecommand called
[   23.775004] usb-storage: *** thread awakened.
[   23.775008] usb-storage: Bad target number (6:0)
[   23.775013] usb-storage: scsi cmd done, result=0x40000
[   23.775019] usb-storage: *** thread sleeping.
[   23.775076] usb-storage: queuecommand called
[   23.775085] usb-storage: *** thread awakened.
[   23.775090] usb-storage: Bad target number (7:0)
[   23.775094] usb-storage: scsi cmd done, result=0x40000
[   23.775100] usb-storage: *** thread sleeping.
[   23.775125] usb-storage: device scan complete
[   23.791332] usb-storage: queuecommand called
[   23.791365] usb-storage: *** thread awakened.
[   23.791374] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.791379] usb-storage:  00 00 00 00 00 00
[   23.791392] usb-storage: Bulk Command S 0x43425355 T 0xe L 0 F 0 Trg 0 LUN 0 CL 6
[   23.791400] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.791488] usb-storage: Status code 0; transferred 31/31
[   23.791494] usb-storage: -- transfer complete
[   23.791498] usb-storage: Bulk command transfer result=0
[   23.791506] usb-storage: Attempting to get CSW...
[   23.791511] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.791597] usb-storage: Status code 0; transferred 13/13
[   23.791601] usb-storage: -- transfer complete
[   23.791606] usb-storage: Bulk status result = 0
[   23.791611] usb-storage: Bulk Status S 0x53425355 T 0xe R 0 Stat 0x0
[   23.791618] usb-storage: scsi cmd done, result=0x0
[   23.791626] usb-storage: *** thread sleeping.
[   23.793147] usb-storage: queuecommand called
[   23.793170] usb-storage: *** thread awakened.
[   23.793177] usb-storage: Command INQUIRY (6 bytes)
[   23.793181] usb-storage:  12 00 00 00 fe 00
[   23.793195] usb-storage: Bulk Command S 0x43425355 T 0xf L 254 F 128 Trg 0 LUN 0 CL 6
[   23.793203] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.793358] usb-storage: Status code 0; transferred 31/31
[   23.793364] usb-storage: -- transfer complete
[   23.793369] usb-storage: Bulk command transfer result=0
[   23.793375] usb-storage: usb_stor_bulk_transfer_sglist: xfer 254 bytes, 1 entries
[   23.793475] usb-storage: Status code -121; transferred 36/254
[   23.793480] usb-storage: -- short read transfer
[   23.793486] usb-storage: Bulk data transfer result 0x1
[   23.793490] usb-storage: Attempting to get CSW...
[   23.793495] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.793732] usb-storage: Status code 0; transferred 13/13
[   23.793738] usb-storage: -- transfer complete
[   23.793743] usb-storage: Bulk status result = 0
[   23.793751] usb-storage: Bulk Status S 0x53425355 T 0xf R 218 Stat 0x0
[   23.793758] usb-storage: scsi cmd done, result=0x0
[   23.793767] usb-storage: *** thread sleeping.
[   23.793998] usb-storage: queuecommand called
[   23.794017] usb-storage: *** thread awakened.
[   23.794023] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.794027] usb-storage:  00 00 00 00 00 00
[   23.794040] usb-storage: Bulk Command S 0x43425355 T 0x10 L 0 F 0 Trg 0 LUN 0 CL 6
[   23.794047] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.794099] usb-storage: Status code 0; transferred 31/31
[   23.794103] usb-storage: -- transfer complete
[   23.794108] usb-storage: Bulk command transfer result=0
[   23.794112] usb-storage: Attempting to get CSW...
[   23.794117] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.794350] usb-storage: Status code 0; transferred 13/13
[   23.794355] usb-storage: -- transfer complete
[   23.794360] usb-storage: Bulk status result = 0
[   23.794366] usb-storage: Bulk Status S 0x53425355 T 0x10 R 0 Stat 0x0
[   23.794372] usb-storage: scsi cmd done, result=0x0
[   23.794379] usb-storage: *** thread sleeping.
[   23.794432] usb-storage: queuecommand called
[   23.794445] usb-storage: *** thread awakened.
[   23.794450] usb-storage: Command INQUIRY (6 bytes)
[   23.794454] usb-storage:  12 01 00 00 fe 00
[   23.794467] usb-storage: Bulk Command S 0x43425355 T 0x11 L 254 F 128 Trg 0 LUN 0 CL 6
[   23.794475] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.794599] usb-storage: Status code 0; transferred 31/31
[   23.794607] usb-storage: -- transfer complete
[   23.794611] usb-storage: Bulk command transfer result=0
[   23.794618] usb-storage: usb_stor_bulk_transfer_sglist: xfer 254 bytes, 1 entries
[   23.794851] usb-storage: Status code -121; transferred 36/254
[   23.794857] usb-storage: -- short read transfer
[   23.794862] usb-storage: Bulk data transfer result 0x1
[   23.794866] usb-storage: Attempting to get CSW...
[   23.794871] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.795097] usb-storage: Status code 0; transferred 13/13
[   23.795102] usb-storage: -- transfer complete
[   23.795107] usb-storage: Bulk status result = 0
[   23.795113] usb-storage: Bulk Status S 0x53425355 T 0x11 R 218 Stat 0x0
[   23.795119] usb-storage: scsi cmd done, result=0x0
[   23.795126] usb-storage: *** thread sleeping.
[   23.896263] usb-storage: queuecommand called
[   23.896296] usb-storage: *** thread awakened.
[   23.896302] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.896307] usb-storage:  00 00 00 00 00 00
[   23.896323] usb-storage: Bulk Command S 0x43425355 T 0x12 L 0 F 0 Trg 0 LUN 0 CL 6
[   23.896331] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.896466] usb-storage: Status code 0; transferred 31/31
[   23.896471] usb-storage: -- transfer complete
[   23.896476] usb-storage: Bulk command transfer result=0
[   23.896481] usb-storage: Attempting to get CSW...
[   23.896486] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.896578] usb-storage: Status code 0; transferred 13/13
[   23.896583] usb-storage: -- transfer complete
[   23.896587] usb-storage: Bulk status result = 0
[   23.896593] usb-storage: Bulk Status S 0x53425355 T 0x12 R 0 Stat 0x0
[   23.896599] usb-storage: scsi cmd done, result=0x0
[   23.896607] usb-storage: *** thread sleeping.
[   23.898017] usb-storage: queuecommand called
[   23.898493] usb-storage: *** thread awakened.
[   23.898504] usb-storage: Command READ_10 (10 bytes)
[   23.898509] usb-storage:  28 00 00 ee f3 80 00 00 08 00
[   23.898526] usb-storage: Bulk Command S 0x43425355 T 0x13 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.898534] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.898805] usb-storage: Status code 0; transferred 31/31
[   23.898811] usb-storage: -- transfer complete
[   23.898821] usb-storage: Bulk command transfer result=0
[   23.898828] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.899637] usb-storage: Status code 0; transferred 4096/4096
[   23.899645] usb-storage: -- transfer complete
[   23.899650] usb-storage: Bulk data transfer result 0x0
[   23.899655] usb-storage: Attempting to get CSW...
[   23.899661] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.899833] usb-storage: Status code 0; transferred 13/13
[   23.899838] usb-storage: -- transfer complete
[   23.899843] usb-storage: Bulk status result = 0
[   23.899849] usb-storage: Bulk Status S 0x53425355 T 0x13 R 0 Stat 0x0
[   23.899856] usb-storage: scsi cmd done, result=0x0
[   23.899866] usb-storage: *** thread sleeping.
[   23.900053] usb-storage: queuecommand called
[   23.900072] usb-storage: *** thread awakened.
[   23.900079] usb-storage: Command READ_10 (10 bytes)
[   23.900083] usb-storage:  28 00 00 00 00 00 00 00 08 00
[   23.900099] usb-storage: Bulk Command S 0x43425355 T 0x14 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.900106] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.900207] usb-storage: Status code 0; transferred 31/31
[   23.900212] usb-storage: -- transfer complete
[   23.900216] usb-storage: Bulk command transfer result=0
[   23.900222] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.900827] usb-storage: Status code 0; transferred 4096/4096
[   23.900831] usb-storage: -- transfer complete
[   23.900836] usb-storage: Bulk data transfer result 0x0
[   23.900840] usb-storage: Attempting to get CSW...
[   23.900845] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.900951] usb-storage: Status code 0; transferred 13/13
[   23.900955] usb-storage: -- transfer complete
[   23.900959] usb-storage: Bulk status result = 0
[   23.900965] usb-storage: Bulk Status S 0x53425355 T 0x14 R 0 Stat 0x0
[   23.900974] usb-storage: scsi cmd done, result=0x0
[   23.900980] usb-storage: *** thread sleeping.
[   23.901078] usb-storage: queuecommand called
[   23.901094] usb-storage: *** thread awakened.
[   23.901099] usb-storage: Command READ_10 (10 bytes)
[   23.901103] usb-storage:  28 00 00 00 00 08 00 00 20 00
[   23.901119] usb-storage: Bulk Command S 0x43425355 T 0x15 L 16384 F 128 Trg 0 LUN 0 CL 10
[   23.901126] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.901205] usb-storage: Status code 0; transferred 31/31
[   23.901210] usb-storage: -- transfer complete
[   23.901214] usb-storage: Bulk command transfer result=0
[   23.901220] usb-storage: usb_stor_bulk_transfer_sglist: xfer 16384 bytes, 3 entries
[   23.902329] usb-storage: Status code 0; transferred 16384/16384
[   23.902333] usb-storage: -- transfer complete
[   23.902338] usb-storage: Bulk data transfer result 0x0
[   23.902342] usb-storage: Attempting to get CSW...
[   23.902347] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.902450] usb-storage: Status code 0; transferred 13/13
[   23.902454] usb-storage: -- transfer complete
[   23.902458] usb-storage: Bulk status result = 0
[   23.902464] usb-storage: Bulk Status S 0x53425355 T 0x15 R 0 Stat 0x0
[   23.902470] usb-storage: scsi cmd done, result=0x0
[   23.902476] usb-storage: *** thread sleeping.
[   23.902548] usb-storage: queuecommand called
[   23.902566] usb-storage: *** thread awakened.
[   23.902571] usb-storage: Command READ_10 (10 bytes)
[   23.902575] usb-storage:  28 00 00 ee f3 f8 00 00 08 00
[   23.902591] usb-storage: Bulk Command S 0x43425355 T 0x16 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.902598] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.902704] usb-storage: Status code 0; transferred 31/31
[   23.902709] usb-storage: -- transfer complete
[   23.902713] usb-storage: Bulk command transfer result=0
[   23.902720] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.903337] usb-storage: Status code 0; transferred 4096/4096
[   23.903343] usb-storage: -- transfer complete
[   23.903349] usb-storage: Bulk data transfer result 0x0
[   23.903354] usb-storage: Attempting to get CSW...
[   23.903359] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.903448] usb-storage: Status code 0; transferred 13/13
[   23.903453] usb-storage: -- transfer complete
[   23.903457] usb-storage: Bulk status result = 0
[   23.903463] usb-storage: Bulk Status S 0x53425355 T 0x16 R 0 Stat 0x0
[   23.903469] usb-storage: scsi cmd done, result=0x0
[   23.903476] usb-storage: *** thread sleeping.
[   23.903622] usb-storage: queuecommand called
[   23.903638] usb-storage: *** thread awakened.
[   23.903648] usb-storage: Command READ_10 (10 bytes)
[   23.903652] usb-storage:  28 00 00 ee f3 c0 00 00 08 00
[   23.903668] usb-storage: Bulk Command S 0x43425355 T 0x17 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.903674] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.903830] usb-storage: Status code 0; transferred 31/31
[   23.903835] usb-storage: -- transfer complete
[   23.903839] usb-storage: Bulk command transfer result=0
[   23.903845] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.904200] usb-storage: Status code 0; transferred 4096/4096
[   23.904204] usb-storage: -- transfer complete
[   23.904209] usb-storage: Bulk data transfer result 0x0
[   23.904213] usb-storage: Attempting to get CSW...
[   23.904218] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.904323] usb-storage: Status code 0; transferred 13/13
[   23.904327] usb-storage: -- transfer complete
[   23.904331] usb-storage: Bulk status result = 0
[   23.904337] usb-storage: Bulk Status S 0x53425355 T 0x17 R 0 Stat 0x0
[   23.904343] usb-storage: scsi cmd done, result=0x0
[   23.904349] usb-storage: *** thread sleeping.
[   23.904402] usb-storage: queuecommand called
[   23.904416] usb-storage: *** thread awakened.
[   23.904421] usb-storage: Command READ_10 (10 bytes)
[   23.904426] usb-storage:  28 00 00 ee f3 00 00 00 08 00
[   23.904441] usb-storage: Bulk Command S 0x43425355 T 0x18 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.904448] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.904578] usb-storage: Status code 0; transferred 31/31
[   23.904582] usb-storage: -- transfer complete
[   23.904587] usb-storage: Bulk command transfer result=0
[   23.904593] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.904950] usb-storage: Status code 0; transferred 4096/4096
[   23.904955] usb-storage: -- transfer complete
[   23.904959] usb-storage: Bulk data transfer result 0x0
[   23.904964] usb-storage: Attempting to get CSW...
[   23.904969] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.905074] usb-storage: Status code 0; transferred 13/13
[   23.905079] usb-storage: -- transfer complete
[   23.905083] usb-storage: Bulk status result = 0
[   23.905089] usb-storage: Bulk Status S 0x53425355 T 0x18 R 0 Stat 0x0
[   23.905097] usb-storage: scsi cmd done, result=0x0
[   23.905103] usb-storage: *** thread sleeping.
[   23.905166] usb-storage: queuecommand called
[   23.905180] usb-storage: *** thread awakened.
[   23.905185] usb-storage: Command READ_10 (10 bytes)
[   23.905189] usb-storage:  28 00 00 ee f3 f0 00 00 08 00
[   23.905204] usb-storage: Bulk Command S 0x43425355 T 0x19 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.905211] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.905330] usb-storage: Status code 0; transferred 31/31
[   23.905335] usb-storage: -- transfer complete
[   23.905339] usb-storage: Bulk command transfer result=0
[   23.905346] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.905703] usb-storage: Status code 0; transferred 4096/4096
[   23.905707] usb-storage: -- transfer complete
[   23.905712] usb-storage: Bulk data transfer result 0x0
[   23.905716] usb-storage: Attempting to get CSW...
[   23.905721] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.905826] usb-storage: Status code 0; transferred 13/13
[   23.905830] usb-storage: -- transfer complete
[   23.905835] usb-storage: Bulk status result = 0
[   23.905840] usb-storage: Bulk Status S 0x53425355 T 0x19 R 0 Stat 0x0
[   23.905846] usb-storage: scsi cmd done, result=0x0
[   23.905852] usb-storage: *** thread sleeping.
[   23.905905] usb-storage: queuecommand called
[   23.905918] usb-storage: *** thread awakened.
[   23.905923] usb-storage: Command READ_10 (10 bytes)
[   23.905927] usb-storage:  28 00 00 ee f2 70 00 00 08 00
[   23.905943] usb-storage: Bulk Command S 0x43425355 T 0x1a L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.905949] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.906079] usb-storage: Status code 0; transferred 31/31
[   23.906086] usb-storage: -- transfer complete
[   23.906091] usb-storage: Bulk command transfer result=0
[   23.906097] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.906450] usb-storage: Status code 0; transferred 4096/4096
[   23.906454] usb-storage: -- transfer complete
[   23.906459] usb-storage: Bulk data transfer result 0x0
[   23.906463] usb-storage: Attempting to get CSW...
[   23.906468] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.906572] usb-storage: Status code 0; transferred 13/13
[   23.906577] usb-storage: -- transfer complete
[   23.906581] usb-storage: Bulk status result = 0
[   23.906587] usb-storage: Bulk Status S 0x53425355 T 0x1a R 0 Stat 0x0
[   23.906593] usb-storage: scsi cmd done, result=0x0
[   23.906598] usb-storage: *** thread sleeping.
[   23.907125] usb-storage: queuecommand called
[   23.907146] usb-storage: *** thread awakened.
[   23.907152] usb-storage: Command READ_10 (10 bytes)
[   23.907156] usb-storage:  28 00 00 00 00 28 00 00 40 00
[   23.907173] usb-storage: Bulk Command S 0x43425355 T 0x1b L 32768 F 128 Trg 0 LUN 0 CL 10
[   23.907180] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.907333] usb-storage: Status code 0; transferred 31/31
[   23.907338] usb-storage: -- transfer complete
[   23.907343] usb-storage: Bulk command transfer result=0
[   23.907349] usb-storage: usb_stor_bulk_transfer_sglist: xfer 32768 bytes, 3 entries
[   23.909454] usb-storage: Status code 0; transferred 32768/32768
[   23.909459] usb-storage: -- transfer complete
[   23.909464] usb-storage: Bulk data transfer result 0x0
[   23.909468] usb-storage: Attempting to get CSW...
[   23.909473] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.909572] usb-storage: Status code 0; transferred 13/13
[   23.909576] usb-storage: -- transfer complete
[   23.909580] usb-storage: Bulk status result = 0
[   23.909586] usb-storage: Bulk Status S 0x53425355 T 0x1b R 0 Stat 0x0
[   23.909593] usb-storage: scsi cmd done, result=0x0
[   23.909600] usb-storage: *** thread sleeping.
[   23.914186] usb-storage: queuecommand called
[   23.914221] usb-storage: *** thread awakened.
[   23.914227] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.914232] usb-storage:  00 00 00 00 00 00
[   23.914246] usb-storage: Bulk Command S 0x43425355 T 0x1c L 0 F 0 Trg 0 LUN 0 CL 6
[   23.914253] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.914342] usb-storage: Status code 0; transferred 31/31
[   23.914348] usb-storage: -- transfer complete
[   23.914352] usb-storage: Bulk command transfer result=0
[   23.914357] usb-storage: Attempting to get CSW...
[   23.914362] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.914575] usb-storage: Status code 0; transferred 13/13
[   23.914580] usb-storage: -- transfer complete
[   23.914584] usb-storage: Bulk status result = 0
[   23.914590] usb-storage: Bulk Status S 0x53425355 T 0x1c R 0 Stat 0x0
[   23.914599] usb-storage: scsi cmd done, result=0x0
[   23.914607] usb-storage: *** thread sleeping.
[   23.914683] usb-storage: queuecommand called
[   23.914696] usb-storage: *** thread awakened.
[   23.914702] usb-storage: Command INQUIRY (6 bytes)
[   23.914706] usb-storage:  12 00 00 00 fe 00
[   23.914718] usb-storage: Bulk Command S 0x43425355 T 0x1d L 254 F 128 Trg 0 LUN 0 CL 6
[   23.914725] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.914827] usb-storage: Status code 0; transferred 31/31
[   23.914832] usb-storage: -- transfer complete
[   23.914836] usb-storage: Bulk command transfer result=0
[   23.914842] usb-storage: usb_stor_bulk_transfer_sglist: xfer 254 bytes, 1 entries
[   23.915077] usb-storage: Status code -121; transferred 36/254
[   23.915082] usb-storage: -- short read transfer
[   23.915087] usb-storage: Bulk data transfer result 0x1
[   23.915091] usb-storage: Attempting to get CSW...
[   23.915096] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.915323] usb-storage: Status code 0; transferred 13/13
[   23.915328] usb-storage: -- transfer complete
[   23.915332] usb-storage: Bulk status result = 0
[   23.915338] usb-storage: Bulk Status S 0x53425355 T 0x1d R 218 Stat 0x0
[   23.915344] usb-storage: scsi cmd done, result=0x0
[   23.915350] usb-storage: *** thread sleeping.
[   23.915541] usb-storage: queuecommand called
[   23.915561] usb-storage: *** thread awakened.
[   23.915567] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.915571] usb-storage:  00 00 00 00 00 00
[   23.915583] usb-storage: Bulk Command S 0x43425355 T 0x1e L 0 F 0 Trg 0 LUN 0 CL 6
[   23.915590] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.915705] usb-storage: Status code 0; transferred 31/31
[   23.915710] usb-storage: -- transfer complete
[   23.915714] usb-storage: Bulk command transfer result=0
[   23.915719] usb-storage: Attempting to get CSW...
[   23.915724] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.915946] usb-storage: Status code 0; transferred 13/13
[   23.915951] usb-storage: -- transfer complete
[   23.915955] usb-storage: Bulk status result = 0
[   23.915961] usb-storage: Bulk Status S 0x53425355 T 0x1e R 0 Stat 0x0
[   23.915967] usb-storage: scsi cmd done, result=0x0
[   23.915973] usb-storage: *** thread sleeping.
[   23.916013] usb-storage: queuecommand called
[   23.916027] usb-storage: *** thread awakened.
[   23.916032] usb-storage: Command INQUIRY (6 bytes)
[   23.916036] usb-storage:  12 01 00 00 fe 00
[   23.916048] usb-storage: Bulk Command S 0x43425355 T 0x1f L 254 F 128 Trg 0 LUN 0 CL 6
[   23.916055] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.916201] usb-storage: Status code 0; transferred 31/31
[   23.916206] usb-storage: -- transfer complete
[   23.916210] usb-storage: Bulk command transfer result=0
[   23.916217] usb-storage: usb_stor_bulk_transfer_sglist: xfer 254 bytes, 1 entries
[   23.916452] usb-storage: Status code -121; transferred 36/254
[   23.916457] usb-storage: -- short read transfer
[   23.916462] usb-storage: Bulk data transfer result 0x1
[   23.916466] usb-storage: Attempting to get CSW...
[   23.916471] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.916696] usb-storage: Status code 0; transferred 13/13
[   23.916701] usb-storage: -- transfer complete
[   23.916705] usb-storage: Bulk status result = 0
[   23.916712] usb-storage: Bulk Status S 0x53425355 T 0x1f R 218 Stat 0x0
[   23.916717] usb-storage: scsi cmd done, result=0x0
[   23.916723] usb-storage: *** thread sleeping.
[   23.930643] usb-storage: queuecommand called
[   23.930675] usb-storage: *** thread awakened.
[   23.930681] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.930686] usb-storage:  00 00 00 00 00 00
[   23.930702] usb-storage: Bulk Command S 0x43425355 T 0x20 L 0 F 0 Trg 0 LUN 0 CL 6
[   23.930709] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.930838] usb-storage: Status code 0; transferred 31/31
[   23.930843] usb-storage: -- transfer complete
[   23.930848] usb-storage: Bulk command transfer result=0
[   23.930853] usb-storage: Attempting to get CSW...
[   23.930858] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.930953] usb-storage: Status code 0; transferred 13/13
[   23.930958] usb-storage: -- transfer complete
[   23.930963] usb-storage: Bulk status result = 0
[   23.930969] usb-storage: Bulk Status S 0x53425355 T 0x20 R 0 Stat 0x0
[   23.930975] usb-storage: scsi cmd done, result=0x0
[   23.930983] usb-storage: *** thread sleeping.
[   23.933452] usb-storage: queuecommand called
[   23.933477] usb-storage: *** thread awakened.
[   23.933484] usb-storage: Command READ_10 (10 bytes)
[   23.933488] usb-storage:  28 00 00 d2 4d be 00 00 08 00
[   23.933508] usb-storage: Bulk Command S 0x43425355 T 0x21 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.933516] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.933585] usb-storage: Status code 0; transferred 31/31
[   23.933590] usb-storage: -- transfer complete
[   23.933594] usb-storage: Bulk command transfer result=0
[   23.933604] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.934345] usb-storage: Status code 0; transferred 4096/4096
[   23.934352] usb-storage: -- transfer complete
[   23.934358] usb-storage: Bulk data transfer result 0x0
[   23.934362] usb-storage: Attempting to get CSW...
[   23.934367] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.934446] usb-storage: Status code 0; transferred 13/13
[   23.934451] usb-storage: -- transfer complete
[   23.934455] usb-storage: Bulk status result = 0
[   23.934461] usb-storage: Bulk Status S 0x53425355 T 0x21 R 0 Stat 0x0
[   23.934469] usb-storage: scsi cmd done, result=0x0
[   23.934478] usb-storage: *** thread sleeping.
[   23.934644] usb-storage: queuecommand called
[   23.934665] usb-storage: *** thread awakened.
[   23.934671] usb-storage: Command READ_10 (10 bytes)
[   23.934675] usb-storage:  28 00 00 00 00 3e 00 00 08 00
[   23.934694] usb-storage: Bulk Command S 0x43425355 T 0x22 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.934701] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.934828] usb-storage: Status code 0; transferred 31/31
[   23.934833] usb-storage: -- transfer complete
[   23.934837] usb-storage: Bulk command transfer result=0
[   23.934844] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.935467] usb-storage: Status code 0; transferred 4096/4096
[   23.935473] usb-storage: -- transfer complete
[   23.935478] usb-storage: Bulk data transfer result 0x0
[   23.935483] usb-storage: Attempting to get CSW...
[   23.935488] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.935577] usb-storage: Status code 0; transferred 13/13
[   23.935586] usb-storage: -- transfer complete
[   23.935590] usb-storage: Bulk status result = 0
[   23.935596] usb-storage: Bulk Status S 0x53425355 T 0x22 R 0 Stat 0x0
[   23.935603] usb-storage: scsi cmd done, result=0x0
[   23.935610] usb-storage: *** thread sleeping.
[   23.935643] usb-storage: queuecommand called
[   23.935799] usb-storage: *** thread awakened.
[   23.935808] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.935813] usb-storage:  00 00 00 00 00 00
[   23.935825] usb-storage: Bulk Command S 0x43425355 T 0x23 L 0 F 0 Trg 0 LUN 0 CL 6
[   23.935832] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.935959] usb-storage: Status code 0; transferred 31/31
[   23.935964] usb-storage: -- transfer complete
[   23.935968] usb-storage: Bulk command transfer result=0
[   23.935973] usb-storage: Attempting to get CSW...
[   23.935978] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.936196] usb-storage: Status code 0; transferred 13/13
[   23.936200] usb-storage: -- transfer complete
[   23.936204] usb-storage: Bulk status result = 0
[   23.936210] usb-storage: Bulk Status S 0x53425355 T 0x23 R 0 Stat 0x0
[   23.936216] usb-storage: scsi cmd done, result=0x0
[   23.936223] usb-storage: *** thread sleeping.
[   23.936242] usb-storage: queuecommand called
[   23.936251] usb-storage: *** thread awakened.
[   23.936256] usb-storage: Command READ_10 (10 bytes)
[   23.936260] usb-storage:  28 00 00 00 00 46 00 00 20 00
[   23.936278] usb-storage: Bulk Command S 0x43425355 T 0x24 L 16384 F 128 Trg 0 LUN 0 CL 10
[   23.936284] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.936324] usb-storage: Status code 0; transferred 31/31
[   23.936328] usb-storage: -- transfer complete
[   23.936333] usb-storage: Bulk command transfer result=0
[   23.936342] usb-storage: usb_stor_bulk_transfer_sglist: xfer 16384 bytes, 2 entries
[   23.937573] usb-storage: Status code 0; transferred 16384/16384
[   23.937579] usb-storage: -- transfer complete
[   23.937584] usb-storage: Bulk data transfer result 0x0
[   23.937588] usb-storage: Attempting to get CSW...
[   23.937593] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.937693] usb-storage: Status code 0; transferred 13/13
[   23.937697] usb-storage: -- transfer complete
[   23.937702] usb-storage: Bulk status result = 0
[   23.937707] usb-storage: Bulk Status S 0x53425355 T 0x24 R 0 Stat 0x0
[   23.937713] usb-storage: scsi cmd done, result=0x0
[   23.937719] usb-storage: *** thread sleeping.
[   23.937748] usb-storage: queuecommand called
[   23.937825] usb-storage: *** thread awakened.
[   23.937833] usb-storage: Command INQUIRY (6 bytes)
[   23.937837] usb-storage:  12 00 00 00 fe 00
[   23.937849] usb-storage: Bulk Command S 0x43425355 T 0x25 L 254 F 128 Trg 0 LUN 0 CL 6
[   23.937856] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.937951] usb-storage: Status code 0; transferred 31/31
[   23.937955] usb-storage: -- transfer complete
[   23.937960] usb-storage: Bulk command transfer result=0
[   23.937966] usb-storage: usb_stor_bulk_transfer_sglist: xfer 254 bytes, 1 entries
[   23.938198] usb-storage: Status code -121; transferred 36/254
[   23.938203] usb-storage: -- short read transfer
[   23.938207] usb-storage: Bulk data transfer result 0x1
[   23.938212] usb-storage: Attempting to get CSW...
[   23.938217] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.938443] usb-storage: Status code 0; transferred 13/13
[   23.938448] usb-storage: -- transfer complete
[   23.938452] usb-storage: Bulk status result = 0
[   23.938458] usb-storage: Bulk Status S 0x53425355 T 0x25 R 218 Stat 0x0
[   23.938464] usb-storage: scsi cmd done, result=0x0
[   23.938470] usb-storage: *** thread sleeping.
[   23.938489] usb-storage: queuecommand called
[   23.938498] usb-storage: *** thread awakened.
[   23.938503] usb-storage: Command READ_10 (10 bytes)
[   23.938507] usb-storage:  28 00 00 d2 4e 46 00 00 02 00
[   23.938522] usb-storage: Bulk Command S 0x43425355 T 0x26 L 1024 F 128 Trg 0 LUN 0 CL 10
[   23.938529] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.938625] usb-storage: Status code 0; transferred 31/31
[   23.938630] usb-storage: -- transfer complete
[   23.938635] usb-storage: Bulk command transfer result=0
[   23.938641] usb-storage: usb_stor_bulk_transfer_sglist: xfer 1024 bytes, 1 entries
[   23.939081] usb-storage: Status code 0; transferred 1024/1024
[   23.939087] usb-storage: -- transfer complete
[   23.939092] usb-storage: Bulk data transfer result 0x0
[   23.939096] usb-storage: Attempting to get CSW...
[   23.939101] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.939194] usb-storage: Status code 0; transferred 13/13
[   23.939199] usb-storage: -- transfer complete
[   23.939203] usb-storage: Bulk status result = 0
[   23.939209] usb-storage: Bulk Status S 0x53425355 T 0x26 R 0 Stat 0x0
[   23.939215] usb-storage: scsi cmd done, result=0x0
[   23.939222] usb-storage: *** thread sleeping.
[   23.939248] usb-storage: queuecommand called
[   23.939380] usb-storage: *** thread awakened.
[   23.939388] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.939392] usb-storage:  00 00 00 00 00 00
[   23.939404] usb-storage: Bulk Command S 0x43425355 T 0x27 L 0 F 0 Trg 0 LUN 0 CL 6
[   23.939411] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.939576] usb-storage: Status code 0; transferred 31/31
[   23.939580] usb-storage: -- transfer complete
[   23.939585] usb-storage: Bulk command transfer result=0
[   23.939589] usb-storage: Attempting to get CSW...
[   23.939594] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.939817] usb-storage: Status code 0; transferred 13/13
[   23.939822] usb-storage: -- transfer complete
[   23.939826] usb-storage: Bulk status result = 0
[   23.939832] usb-storage: Bulk Status S 0x53425355 T 0x27 R 0 Stat 0x0
[   23.939838] usb-storage: scsi cmd done, result=0x0
[   23.939844] usb-storage: *** thread sleeping.
[   23.939858] usb-storage: queuecommand called
[   23.939866] usb-storage: *** thread awakened.
[   23.939872] usb-storage: Command READ_10 (10 bytes)
[   23.939876] usb-storage:  28 00 00 d2 4e 06 00 00 08 00
[   23.939891] usb-storage: Bulk Command S 0x43425355 T 0x28 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.939898] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.939950] usb-storage: Status code 0; transferred 31/31
[   23.939955] usb-storage: -- transfer complete
[   23.939959] usb-storage: Bulk command transfer result=0
[   23.939965] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.940446] usb-storage: Status code 0; transferred 4096/4096
[   23.940451] usb-storage: -- transfer complete
[   23.940455] usb-storage: Bulk data transfer result 0x0
[   23.940460] usb-storage: Attempting to get CSW...
[   23.940465] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.940569] usb-storage: Status code 0; transferred 13/13
[   23.940574] usb-storage: -- transfer complete
[   23.940578] usb-storage: Bulk status result = 0
[   23.940584] usb-storage: Bulk Status S 0x53425355 T 0x28 R 0 Stat 0x0
[   23.940590] usb-storage: scsi cmd done, result=0x0
[   23.940597] usb-storage: *** thread sleeping.
[   23.940616] usb-storage: queuecommand called
[   23.940679] usb-storage: *** thread awakened.
[   23.940686] usb-storage: Command INQUIRY (6 bytes)
[   23.940690] usb-storage:  12 01 00 00 fe 00
[   23.940702] usb-storage: Bulk Command S 0x43425355 T 0x29 L 254 F 128 Trg 0 LUN 0 CL 6
[   23.940709] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.940827] usb-storage: Status code 0; transferred 31/31
[   23.940832] usb-storage: -- transfer complete
[   23.940836] usb-storage: Bulk command transfer result=0
[   23.940842] usb-storage: usb_stor_bulk_transfer_sglist: xfer 254 bytes, 1 entries
[   23.941073] usb-storage: Status code -121; transferred 36/254
[   23.941078] usb-storage: -- short read transfer
[   23.941083] usb-storage: Bulk data transfer result 0x1
[   23.941087] usb-storage: Attempting to get CSW...
[   23.941092] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.941318] usb-storage: Status code 0; transferred 13/13
[   23.941322] usb-storage: -- transfer complete
[   23.941326] usb-storage: Bulk status result = 0
[   23.941332] usb-storage: Bulk Status S 0x53425355 T 0x29 R 218 Stat 0x0
[   23.941338] usb-storage: scsi cmd done, result=0x0
[   23.941344] usb-storage: *** thread sleeping.
[   23.941362] usb-storage: queuecommand called
[   23.941370] usb-storage: *** thread awakened.
[   23.941375] usb-storage: Command READ_10 (10 bytes)
[   23.941379] usb-storage:  28 00 00 d2 4d 46 00 00 08 00
[   23.941395] usb-storage: Bulk Command S 0x43425355 T 0x2a L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.941401] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.941450] usb-storage: Status code 0; transferred 31/31
[   23.941458] usb-storage: -- transfer complete
[   23.941462] usb-storage: Bulk command transfer result=0
[   23.941469] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.941963] usb-storage: Status code 0; transferred 4096/4096
[   23.941969] usb-storage: -- transfer complete
[   23.941974] usb-storage: Bulk data transfer result 0x0
[   23.941979] usb-storage: Attempting to get CSW...
[   23.941984] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.942070] usb-storage: Status code 0; transferred 13/13
[   23.942075] usb-storage: -- transfer complete
[   23.942079] usb-storage: Bulk status result = 0
[   23.942085] usb-storage: Bulk Status S 0x53425355 T 0x2a R 0 Stat 0x0
[   23.942091] usb-storage: scsi cmd done, result=0x0
[   23.942098] usb-storage: *** thread sleeping.
[   23.942217] usb-storage: queuecommand called
[   23.942232] usb-storage: *** thread awakened.
[   23.942238] usb-storage: Command READ_10 (10 bytes)
[   23.942242] usb-storage:  28 00 00 d2 4e 36 00 00 08 00
[   23.942258] usb-storage: Bulk Command S 0x43425355 T 0x2b L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.942265] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.942326] usb-storage: Status code 0; transferred 31/31
[   23.942330] usb-storage: -- transfer complete
[   23.942335] usb-storage: Bulk command transfer result=0
[   23.942341] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.942840] usb-storage: Status code 0; transferred 4096/4096
[   23.942847] usb-storage: -- transfer complete
[   23.942852] usb-storage: Bulk data transfer result 0x0
[   23.942857] usb-storage: Attempting to get CSW...
[   23.942862] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.942948] usb-storage: Status code 0; transferred 13/13
[   23.942953] usb-storage: -- transfer complete
[   23.942957] usb-storage: Bulk status result = 0
[   23.942963] usb-storage: Bulk Status S 0x53425355 T 0x2b R 0 Stat 0x0
[   23.942973] usb-storage: scsi cmd done, result=0x0
[   23.942981] usb-storage: *** thread sleeping.
[   23.943094] usb-storage: queuecommand called
[   23.943113] usb-storage: *** thread awakened.
[   23.943119] usb-storage: Command READ_10 (10 bytes)
[   23.943123] usb-storage:  28 00 00 d2 4c b6 00 00 08 00
[   23.943141] usb-storage: Bulk Command S 0x43425355 T 0x2c L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.943148] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.943199] usb-storage: Status code 0; transferred 31/31
[   23.943204] usb-storage: -- transfer complete
[   23.943208] usb-storage: Bulk command transfer result=0
[   23.943214] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.943718] usb-storage: Status code 0; transferred 4096/4096
[   23.943725] usb-storage: -- transfer complete
[   23.943732] usb-storage: Bulk data transfer result 0x0
[   23.943736] usb-storage: Attempting to get CSW...
[   23.943741] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.943820] usb-storage: Status code 0; transferred 13/13
[   23.943825] usb-storage: -- transfer complete
[   23.943830] usb-storage: Bulk status result = 0
[   23.943836] usb-storage: Bulk Status S 0x53425355 T 0x2c R 0 Stat 0x0
[   23.943843] usb-storage: scsi cmd done, result=0x0
[   23.943850] usb-storage: *** thread sleeping.
[   23.944526] usb-storage: queuecommand called
[   23.944550] usb-storage: *** thread awakened.
[   23.944557] usb-storage: Command READ_10 (10 bytes)
[   23.944561] usb-storage:  28 00 00 00 00 66 00 00 40 00
[   23.944578] usb-storage: Bulk Command S 0x43425355 T 0x2d L 32768 F 128 Trg 0 LUN 0 CL 10
[   23.944585] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.944708] usb-storage: Status code 0; transferred 31/31
[   23.944714] usb-storage: -- transfer complete
[   23.944720] usb-storage: Bulk command transfer result=0
[   23.944727] usb-storage: usb_stor_bulk_transfer_sglist: xfer 32768 bytes, 3 entries
[   23.946707] usb-storage: Status code 0; transferred 32768/32768
[   23.946712] usb-storage: -- transfer complete
[   23.946717] usb-storage: Bulk data transfer result 0x0
[   23.946722] usb-storage: Attempting to get CSW...
[   23.946727] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.946818] usb-storage: Status code 0; transferred 13/13
[   23.946823] usb-storage: -- transfer complete
[   23.946827] usb-storage: Bulk status result = 0
[   23.946833] usb-storage: Bulk Status S 0x53425355 T 0x2d R 0 Stat 0x0
[   23.946840] usb-storage: scsi cmd done, result=0x0
[   23.946847] usb-storage: *** thread sleeping.
[   23.946905] usb-storage: queuecommand called
[   23.946943] usb-storage: *** thread awakened.
[   23.946948] usb-storage: Command TEST_UNIT_READY (6 bytes)
[   23.946953] usb-storage:  00 00 00 00 00 00
[   23.946967] usb-storage: Bulk Command S 0x43425355 T 0x2e L 0 F 0 Trg 0 LUN 0 CL 6
[   23.946974] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.947076] usb-storage: Status code 0; transferred 31/31
[   23.947080] usb-storage: -- transfer complete
[   23.947085] usb-storage: Bulk command transfer result=0
[   23.947089] usb-storage: Attempting to get CSW...
[   23.947094] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.947317] usb-storage: Status code 0; transferred 13/13
[   23.947322] usb-storage: -- transfer complete
[   23.947326] usb-storage: Bulk status result = 0
[   23.947332] usb-storage: Bulk Status S 0x53425355 T 0x2e R 0 Stat 0x0
[   23.947337] usb-storage: scsi cmd done, result=0x0
[   23.947343] usb-storage: *** thread sleeping.
[   23.950389] usb-storage: queuecommand called
[   23.950411] usb-storage: *** thread awakened.
[   23.950417] usb-storage: Command READ_10 (10 bytes)
[   23.950422] usb-storage:  28 00 00 ee cf c8 00 00 08 00
[   23.950439] usb-storage: Bulk Command S 0x43425355 T 0x2f L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.950447] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.950583] usb-storage: Status code 0; transferred 31/31
[   23.950588] usb-storage: -- transfer complete
[   23.950593] usb-storage: Bulk command transfer result=0
[   23.950599] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.951199] usb-storage: Status code 0; transferred 4096/4096
[   23.951203] usb-storage: -- transfer complete
[   23.951208] usb-storage: Bulk data transfer result 0x0
[   23.951212] usb-storage: Attempting to get CSW...
[   23.951217] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.951319] usb-storage: Status code 0; transferred 13/13
[   23.951323] usb-storage: -- transfer complete
[   23.951328] usb-storage: Bulk status result = 0
[   23.951333] usb-storage: Bulk Status S 0x53425355 T 0x2f R 0 Stat 0x0
[   23.951340] usb-storage: scsi cmd done, result=0x0
[   23.951348] usb-storage: *** thread sleeping.
[   23.951463] usb-storage: queuecommand called
[   23.951480] usb-storage: *** thread awakened.
[   23.951486] usb-storage: Command READ_10 (10 bytes)
[   23.951490] usb-storage:  28 00 00 d2 4e 48 00 00 08 00
[   23.951505] usb-storage: Bulk Command S 0x43425355 T 0x30 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.951512] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.951575] usb-storage: Status code 0; transferred 31/31
[   23.951579] usb-storage: -- transfer complete
[   23.951584] usb-storage: Bulk command transfer result=0
[   23.951590] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.952069] usb-storage: Status code 0; transferred 4096/4096
[   23.952074] usb-storage: -- transfer complete
[   23.952078] usb-storage: Bulk data transfer result 0x0
[   23.952082] usb-storage: Attempting to get CSW...
[   23.952087] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.952192] usb-storage: Status code 0; transferred 13/13
[   23.952196] usb-storage: -- transfer complete
[   23.952201] usb-storage: Bulk status result = 0
[   23.952206] usb-storage: Bulk Status S 0x53425355 T 0x30 R 0 Stat 0x0
[   23.952212] usb-storage: scsi cmd done, result=0x0
[   23.952218] usb-storage: *** thread sleeping.
[   23.952319] usb-storage: queuecommand called
[   23.952336] usb-storage: *** thread awakened.
[   23.952341] usb-storage: Command READ_10 (10 bytes)
[   23.952345] usb-storage:  28 00 00 d2 4e 50 00 00 20 00
[   23.952361] usb-storage: Bulk Command S 0x43425355 T 0x31 L 16384 F 128 Trg 0 LUN 0 CL 10
[   23.952368] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.952447] usb-storage: Status code 0; transferred 31/31
[   23.952452] usb-storage: -- transfer complete
[   23.952456] usb-storage: Bulk command transfer result=0
[   23.952462] usb-storage: usb_stor_bulk_transfer_sglist: xfer 16384 bytes, 1 entries
[   23.953443] usb-storage: Status code 0; transferred 16384/16384
[   23.953448] usb-storage: -- transfer complete
[   23.953452] usb-storage: Bulk data transfer result 0x0
[   23.953457] usb-storage: Attempting to get CSW...
[   23.953462] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.953567] usb-storage: Status code 0; transferred 13/13
[   23.953571] usb-storage: -- transfer complete
[   23.953576] usb-storage: Bulk status result = 0
[   23.953581] usb-storage: Bulk Status S 0x53425355 T 0x31 R 0 Stat 0x0
[   23.953587] usb-storage: scsi cmd done, result=0x0
[   23.953596] usb-storage: *** thread sleeping.
[   23.953680] usb-storage: queuecommand called
[   23.953699] usb-storage: *** thread awakened.
[   23.953704] usb-storage: Command READ_10 (10 bytes)
[   23.953708] usb-storage:  28 00 00 ee d0 58 00 00 04 00
[   23.953723] usb-storage: Bulk Command S 0x43425355 T 0x32 L 2048 F 128 Trg 0 LUN 0 CL 10
[   23.953730] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.953823] usb-storage: Status code 0; transferred 31/31
[   23.953827] usb-storage: -- transfer complete
[   23.953832] usb-storage: Bulk command transfer result=0
[   23.953838] usb-storage: usb_stor_bulk_transfer_sglist: xfer 2048 bytes, 1 entries
[   23.954193] usb-storage: Status code 0; transferred 2048/2048
[   23.954198] usb-storage: -- transfer complete
[   23.954202] usb-storage: Bulk data transfer result 0x0
[   23.954207] usb-storage: Attempting to get CSW...
[   23.954212] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.954318] usb-storage: Status code 0; transferred 13/13
[   23.954323] usb-storage: -- transfer complete
[   23.954327] usb-storage: Bulk status result = 0
[   23.954333] usb-storage: Bulk Status S 0x53425355 T 0x32 R 0 Stat 0x0
[   23.954339] usb-storage: scsi cmd done, result=0x0
[   23.954345] usb-storage: *** thread sleeping.
[   23.954461] usb-storage: queuecommand called
[   23.954477] usb-storage: *** thread awakened.
[   23.954482] usb-storage: Command READ_10 (10 bytes)
[   23.954486] usb-storage:  28 00 00 ee d0 18 00 00 08 00
[   23.954501] usb-storage: Bulk Command S 0x43425355 T 0x33 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.954508] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.954572] usb-storage: Status code 0; transferred 31/31
[   23.954576] usb-storage: -- transfer complete
[   23.954581] usb-storage: Bulk command transfer result=0
[   23.954587] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.955066] usb-storage: Status code 0; transferred 4096/4096
[   23.955071] usb-storage: -- transfer complete
[   23.955075] usb-storage: Bulk data transfer result 0x0
[   23.955079] usb-storage: Attempting to get CSW...
[   23.955084] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.955191] usb-storage: Status code 0; transferred 13/13
[   23.955195] usb-storage: -- transfer complete
[   23.955200] usb-storage: Bulk status result = 0
[   23.955205] usb-storage: Bulk Status S 0x53425355 T 0x33 R 0 Stat 0x0
[   23.955211] usb-storage: scsi cmd done, result=0x0
[   23.955217] usb-storage: *** thread sleeping.
[   23.955278] usb-storage: queuecommand called
[   23.955293] usb-storage: *** thread awakened.
[   23.955298] usb-storage: Command READ_10 (10 bytes)
[   23.955302] usb-storage:  28 00 00 ee cf 58 00 00 08 00
[   23.955318] usb-storage: Bulk Command S 0x43425355 T 0x34 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.955324] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.955448] usb-storage: Status code 0; transferred 31/31
[   23.955453] usb-storage: -- transfer complete
[   23.955457] usb-storage: Bulk command transfer result=0
[   23.955463] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.955817] usb-storage: Status code 0; transferred 4096/4096
[   23.955821] usb-storage: -- transfer complete
[   23.955826] usb-storage: Bulk data transfer result 0x0
[   23.955830] usb-storage: Attempting to get CSW...
[   23.955835] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.955942] usb-storage: Status code 0; transferred 13/13
[   23.955947] usb-storage: -- transfer complete
[   23.955951] usb-storage: Bulk status result = 0
[   23.955957] usb-storage: Bulk Status S 0x53425355 T 0x34 R 0 Stat 0x0
[   23.955963] usb-storage: scsi cmd done, result=0x0
[   23.955968] usb-storage: *** thread sleeping.
[   23.956032] usb-storage: queuecommand called
[   23.956047] usb-storage: *** thread awakened.
[   23.956052] usb-storage: Command READ_10 (10 bytes)
[   23.956056] usb-storage:  28 00 00 ee d0 48 00 00 08 00
[   23.956073] usb-storage: Bulk Command S 0x43425355 T 0x35 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.956079] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.956195] usb-storage: Status code 0; transferred 31/31
[   23.956200] usb-storage: -- transfer complete
[   23.956204] usb-storage: Bulk command transfer result=0
[   23.956210] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.956566] usb-storage: Status code 0; transferred 4096/4096
[   23.956571] usb-storage: -- transfer complete
[   23.956575] usb-storage: Bulk data transfer result 0x0
[   23.956580] usb-storage: Attempting to get CSW...
[   23.956585] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.956690] usb-storage: Status code 0; transferred 13/13
[   23.956695] usb-storage: -- transfer complete
[   23.956699] usb-storage: Bulk status result = 0
[   23.956705] usb-storage: Bulk Status S 0x53425355 T 0x35 R 0 Stat 0x0
[   23.956711] usb-storage: scsi cmd done, result=0x0
[   23.956716] usb-storage: *** thread sleeping.
[   23.956771] usb-storage: queuecommand called
[   23.956785] usb-storage: *** thread awakened.
[   23.956790] usb-storage: Command READ_10 (10 bytes)
[   23.956794] usb-storage:  28 00 00 ee ce c8 00 00 08 00
[   23.956809] usb-storage: Bulk Command S 0x43425355 T 0x36 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.956816] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.956945] usb-storage: Status code 0; transferred 31/31
[   23.956950] usb-storage: -- transfer complete
[   23.956954] usb-storage: Bulk command transfer result=0
[   23.956960] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.957315] usb-storage: Status code 0; transferred 4096/4096
[   23.957320] usb-storage: -- transfer complete
[   23.957324] usb-storage: Bulk data transfer result 0x0
[   23.957329] usb-storage: Attempting to get CSW...
[   23.957334] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.957440] usb-storage: Status code 0; transferred 13/13
[   23.957444] usb-storage: -- transfer complete
[   23.957448] usb-storage: Bulk status result = 0
[   23.957456] usb-storage: Bulk Status S 0x53425355 T 0x36 R 0 Stat 0x0
[   23.957462] usb-storage: scsi cmd done, result=0x0
[   23.957468] usb-storage: *** thread sleeping.
[   23.957529] usb-storage: queuecommand called
[   23.957544] usb-storage: *** thread awakened.
[   23.957549] usb-storage: Command READ_10 (10 bytes)
[   23.957553] usb-storage:  28 00 00 ee d0 50 00 00 08 00
[   23.957569] usb-storage: Bulk Command S 0x43425355 T 0x37 L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.957575] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.957699] usb-storage: Status code 0; transferred 31/31
[   23.957704] usb-storage: -- transfer complete
[   23.957708] usb-storage: Bulk command transfer result=0
[   23.957714] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.958067] usb-storage: Status code 0; transferred 4096/4096
[   23.958071] usb-storage: -- transfer complete
[   23.958076] usb-storage: Bulk data transfer result 0x0
[   23.958080] usb-storage: Attempting to get CSW...
[   23.958085] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.958190] usb-storage: Status code 0; transferred 13/13
[   23.958195] usb-storage: -- transfer complete
[   23.958199] usb-storage: Bulk status result = 0
[   23.958205] usb-storage: Bulk Status S 0x53425355 T 0x37 R 0 Stat 0x0
[   23.958211] usb-storage: scsi cmd done, result=0x0
[   23.958216] usb-storage: *** thread sleeping.
[   23.958543] usb-storage: queuecommand called
[   23.958563] usb-storage: *** thread awakened.
[   23.958611] usb-storage: Command READ_10 (10 bytes)
[   23.958616] usb-storage:  28 00 00 d2 4e 70 00 00 c0 00
[   23.958632] usb-storage: Bulk Command S 0x43425355 T 0x38 L 98304 F 128 Trg 0 LUN 0 CL 10
[   23.958638] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.958696] usb-storage: Status code 0; transferred 31/31
[   23.958700] usb-storage: -- transfer complete
[   23.958705] usb-storage: Bulk command transfer result=0
[   23.958711] usb-storage: usb_stor_bulk_transfer_sglist: xfer 98304 bytes, 4 entries
[   23.963825] usb-storage: Status code 0; transferred 98304/98304
[   23.963829] usb-storage: -- transfer complete
[   23.963834] usb-storage: Bulk data transfer result 0x0
[   23.963838] usb-storage: Attempting to get CSW...
[   23.963843] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.963941] usb-storage: Status code 0; transferred 13/13
[   23.963945] usb-storage: -- transfer complete
[   23.963950] usb-storage: Bulk status result = 0
[   23.963956] usb-storage: Bulk Status S 0x53425355 T 0x38 R 0 Stat 0x0
[   23.963962] usb-storage: scsi cmd done, result=0x0
[   23.963968] usb-storage: *** thread sleeping.
[   23.964532] usb-storage: queuecommand called
[   23.964557] usb-storage: *** thread awakened.
[   23.964563] usb-storage: Command READ_10 (10 bytes)
[   23.964567] usb-storage:  28 00 00 d2 4f 30 00 00 f0 00
[   23.964585] usb-storage: Bulk Command S 0x43425355 T 0x39 L 122880 F 128 Trg 0 LUN 0 CL 10
[   23.964593] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.964698] usb-storage: Status code 0; transferred 31/31
[   23.964703] usb-storage: -- transfer complete
[   23.964707] usb-storage: Bulk command transfer result=0
[   23.964715] usb-storage: usb_stor_bulk_transfer_sglist: xfer 122880 bytes, 2 entries
[   23.971069] usb-storage: Status code 0; transferred 122880/122880
[   23.971074] usb-storage: -- transfer complete
[   23.971079] usb-storage: Bulk data transfer result 0x0
[   23.971083] usb-storage: Attempting to get CSW...
[   23.971088] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.971188] usb-storage: Status code 0; transferred 13/13
[   23.971193] usb-storage: -- transfer complete
[   23.971197] usb-storage: Bulk status result = 0
[   23.971203] usb-storage: Bulk Status S 0x53425355 T 0x39 R 0 Stat 0x0
[   23.971209] usb-storage: scsi cmd done, result=0x0
[   23.971216] usb-storage: *** thread sleeping.
[   23.971283] usb-storage: queuecommand called
[   23.971296] usb-storage: *** thread awakened.
[   23.971301] usb-storage: Command READ_10 (10 bytes)
[   23.971305] usb-storage:  28 00 00 d2 50 20 00 00 10 00
[   23.971320] usb-storage: Bulk Command S 0x43425355 T 0x3a L 8192 F 128 Trg 0 LUN 0 CL 10
[   23.971327] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.971443] usb-storage: Status code 0; transferred 31/31
[   23.971448] usb-storage: -- transfer complete
[   23.971452] usb-storage: Bulk command transfer result=0
[   23.971458] usb-storage: usb_stor_bulk_transfer_sglist: xfer 8192 bytes, 1 entries
[   23.972065] usb-storage: Status code 0; transferred 8192/8192
[   23.972070] usb-storage: -- transfer complete
[   23.972074] usb-storage: Bulk data transfer result 0x0
[   23.972078] usb-storage: Attempting to get CSW...
[   23.972083] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.972189] usb-storage: Status code 0; transferred 13/13
[   23.972194] usb-storage: -- transfer complete
[   23.972198] usb-storage: Bulk status result = 0
[   23.972204] usb-storage: Bulk Status S 0x53425355 T 0x3a R 0 Stat 0x0
[   23.972209] usb-storage: scsi cmd done, result=0x0
[   23.972215] usb-storage: *** thread sleeping.
[   23.972230] usb-storage: queuecommand called
[   23.972238] usb-storage: *** thread awakened.
[   23.972243] usb-storage: Command READ_10 (10 bytes)
[   23.972247] usb-storage:  28 00 00 d2 50 48 00 00 08 00
[   23.972263] usb-storage: Bulk Command S 0x43425355 T 0x3b L 4096 F 128 Trg 0 LUN 0 CL 10
[   23.972270] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[   23.972317] usb-storage: Status code 0; transferred 31/31
[   23.972322] usb-storage: -- transfer complete
[   23.972326] usb-storage: Bulk command transfer result=0
[   23.972332] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[   23.972814] usb-storage: Status code 0; transferred 4096/4096
[   23.972819] usb-storage: -- transfer complete
[   23.972823] usb-storage: Bulk data transfer result 0x0
[   23.972828] usb-storage: Attempting to get CSW...
[   23.972833] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[   23.972938] usb-storage: Status code 0; transferred 13/13
[   23.972943] usb-storage: -- transfer complete
[   23.972947] usb-storage: Bulk status result = 0
[   23.972953] usb-storage: Bulk Status S 0x53425355 T 0x3b R 0 Stat 0x0
[   23.972958] usb-storage: scsi cmd done, result=0x0
[   23.972964] usb-storage: *** thread sleeping.
[   24.464229] fuse init (API version 7.9)

--y0ulUmNC+osPPQO6--
