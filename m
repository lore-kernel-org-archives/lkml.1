Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYCQHRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYCQHRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 03:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYCQHQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 03:16:58 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:65388 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYCQHQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 03:16:55 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Mon, 17 Mar 2008 08:16:50 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <47D5320E.8020107@gmail.com>
In-Reply-To: <47D5320E.8020107@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_irh3HthWUCWwT/r"
Message-Id: <200803170816.50597.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_irh3HthWUCWwT/r
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I tried some more stuff, replaced the cables, played with bios settings.

No change.

Then I updated to 2.6.24.3 - and no hangs or 'softreset' failures anymore.

[   38.151334] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
impl IDE mode
[   38.151386] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[   38.151425] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   38.151626] scsi0 : ahci
[   38.151722] scsi1 : ahci
[   38.151788] scsi2 : ahci
[   38.151853] scsi3 : ahci
[   38.151942] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0=20
irq 315
[   38.151990] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0=20
irq 315
[   38.152037] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0=20
irq 315
[   38.152085] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0=20
irq 315
[   38.783287] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   38.783915] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   38.783957] ata1.00: 312581808 sectors, multi 16: LBA48
[   38.784590] ata1.00: configured for UDMA/133
[   39.415249] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   39.435823] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   39.435862] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   39.437862] ata2.00: configured for UDMA/133
[   39.754512] ata3: SATA link down (SStatus 0 SControl 300)
[   40.073818] ata4: SATA link down (SStatus 0 SControl 300)
[   40.073907] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ: 0 ANSI: 5
[   40.074017] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   40.074061] sd 0:0:0:0: [sda] Write Protect is off
[   40.074099] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   40.074107] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   40.074178] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   40.074220] sd 0:0:0:0: [sda] Write Protect is off
[   40.074258] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   40.074265] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   40.074314]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   40.098590] sd 0:0:0:0: [sda] Attached SCSI disk
[   40.098725] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10=20
PQ: 0 ANSI: 5
[   40.098835] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   40.098879] sd 1:0:0:0: [sdb] Write Protect is off
[   40.098917] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   40.098926] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   40.098996] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   40.099039] sd 1:0:0:0: [sdb] Write Protect is off
[   40.099076] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   40.099084] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   40.099133]  sdb: sdb1 sdb2
[   40.109668] sd 1:0:0:0: [sdb] Attached SCSI disk

The only change to other kernels was making ehci-hcd modular.=20

I checked already, other kernels still have the IDENTITY error on coldboot =
and=20
the softreset failure on reboot even with the changed config.

2.6.24.2 and 2.6.24.3 both have the reiser4 patch added.

So
2.6.24.2 =3D bad
2.6.24.3 =3D good
2.6.25-rc5 =3D bad=20

Setting AHCI in bios still results in timeouts and harddisks not found.

Gl=FCck Auf,
Volker

--Boundary-00=_irh3HthWUCWwT/r
Content-Type: text/plain;
  charset="iso-8859-15";
  name="dmesg_2.6.24.3reiser4"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.24.3reiser4"

[    0.000000] Linux version 2.6.24.3reiser4 (root@energy) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Sun Mar 16 20:32:58 CET 2008
[    0.000000] Command line: root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
[    0.000000] end_pfn_map = 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT       97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL 20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT       97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT       97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT       97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT       97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 853 pages reserved
[    0.000000]   DMA zone: 3090 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e6000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e6000 - 0000000000100000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffb0000 - 00000000cffc0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffc0000 - 00000000cfff0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cfff0000 - 00000000d0000000
[    0.000000] swsusp: Registered nosave memory region: 00000000d0000000 - 00000000fec00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec00000 - 00000000fec01000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec01000 - 00000000fee00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fee00000 - 00000000fef00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fef00000 - 00000000ff380000
[    0.000000] swsusp: Registered nosave memory region: 00000000ff380000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 31408 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1030522
[    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] hpet clockevent registered
[    0.000000] TSC calibrated against HPET
[   27.321929] Marking TSC unstable due to TSCs unsynchronized
[   27.321931] time.c: Detected 3013.888 MHz processor.
[   27.325755] Console: colour VGA+ 80x25
[   27.325757] console [tty6] enabled
[   27.330363] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[   27.332590] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   27.333357] Checking aperture...
[   27.333395] CPU 0: aperture @ ecc8000000 size 32 MB
[   27.333433] Aperture too small (32 MB)
[   27.339291] No AGP bridge found
[   27.339327] Your BIOS doesn't leave a aperture memory hole
[   27.339365] Please enable the IOMMU option in the BIOS setup
[   27.339403] This costs you 64 MB of RAM
[   27.364634] Mapping aperture over 65536 KB of RAM @ 8000000
[   27.388765] Memory: 4049948k/4980736k available (2192k kernel code, 143428k reserved, 681k data, 176k init)
[   27.388833] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   27.471580] Calibrating delay using timer specific routine.. 6034.70 BogoMIPS (lpj=10053931)
[   27.471673] Mount-cache hash table entries: 256
[   27.471780] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   27.471819] CPU: L2 Cache: 1024K (64 bytes/line)
[   27.471857] CPU: Physical Processor ID: 0
[   27.471894] CPU: Processor Core ID: 0
[   27.471947] SMP alternatives: switching to UP code
[   27.472310] ACPI: Core revision 20070126
[   27.507485] Using local APIC timer interrupts.
[   27.540630] APIC timer calibration result 12557876
[   27.540631] Detected 12.557 MHz APIC timer.
[   27.540716] SMP alternatives: switching to SMP code
[   27.540945] Booting processor 1/2 APIC 0x1
[   27.551054] Initializing CPU#1
[   27.633818] Calibrating delay using timer specific routine.. 6030.92 BogoMIPS (lpj=10046282)
[   27.633822] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   27.633824] CPU: L2 Cache: 1024K (64 bytes/line)
[   27.633826] CPU: Physical Processor ID: 0
[   27.633827] CPU: Processor Core ID: 1
[   27.633908] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   27.633973] Brought up 2 CPUs
[   27.634431] net_namespace: 120 bytes
[   27.634663] NET: Registered protocol family 16
[   27.634775] ACPI: bus type pci registered
[   27.634857] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   27.634896] PCI: Not using MMCONFIG.
[   27.634932] PCI: Using configuration type 1
[   27.637173] ACPI: EC: Look up EC in DSDT
[   27.640624] ACPI: Interpreter enabled
[   27.640662] ACPI: (supports S0 S1 S3 S4 S5)
[   27.640832] ACPI: Using IOAPIC for interrupt routing
[   27.641040] Error attaching device data
[   27.641080] Error attaching device data
[   27.641118] Error attaching device data
[   27.641157] Error attaching device data
[   27.646070] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   27.646594] PCI: Transparent bridge - 0000:00:08.0
[   27.646888] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   27.647020] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   27.647117] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   27.647173] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   27.647227] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   27.647283] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   27.651219] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[   27.651555] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[   27.651889] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[   27.652249] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[   27.652609] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[   27.652968] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   27.653301] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[   27.653661] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   27.653997] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   27.654331] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[   27.654690] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   27.655024] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[   27.655383] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
[   27.655744] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   27.656077] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
[   27.656437] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   27.656772] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
[   27.657169] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[   27.657528] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disabled.
[   27.657889] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disabled.
[   27.658207] Linux Plug and Play Support v0.97 (c) Adam Belay
[   27.658260] pnp: PnP ACPI init
[   27.658299] ACPI: bus type pnp registered
[   27.660838] pnp: PnP ACPI: found 13 devices
[   27.660875] ACPI: ACPI bus type pnp unregistered
[   27.660998] SCSI subsystem initialized
[   27.661055] libata version 3.00 loaded.
[   27.661105] usbcore: registered new interface driver usbfs
[   27.661161] usbcore: registered new interface driver hub
[   27.661218] usbcore: registered new device driver usb
[   27.661301] PCI: Using ACPI for IRQ routing
[   27.661339] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   27.670423] PCI-DMA: Disabling AGP.
[   27.671160] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   27.671202] PCI-DMA: using GART IOMMU.
[   27.671241] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   27.671400] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   27.671539] hpet0: 3 32-bit timers, 25000000 Hz
[   27.673708] Time: hpet clocksource has been installed.
[   27.673757] Switched to high resolution mode on CPU 0
[   27.673837] Switched to high resolution mode on CPU 1
[   27.680440] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[   27.680480] system 00:05: ioport range 0x800-0x80f has been reserved
[   27.680519] system 00:05: ioport range 0x2000-0x207f has been reserved
[   27.680559] system 00:05: ioport range 0x2080-0x20ff has been reserved
[   27.683951] system 00:05: ioport range 0x2400-0x247f has been reserved
[   27.683990] system 00:05: ioport range 0x2480-0x24ff has been reserved
[   27.684030] system 00:05: ioport range 0x2800-0x287f has been reserved
[   27.684069] system 00:05: ioport range 0x2880-0x28ff has been reserved
[   27.684108] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[   27.684148] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[   27.684187] system 00:05: iomem range 0x0-0x0 could not be reserved
[   27.684227] system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[   27.684271] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[   27.684318] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[   27.684369] system 00:0a: ioport range 0x290-0x29f has been reserved
[   27.684411] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[   27.684457] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   27.684496] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   27.684535] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   27.684579] system 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
[   27.684626] system 00:0c: iomem range 0xff380000-0xffffffff could not be reserved
[   27.684908] PCI: Bridge: 0000:00:08.0
[   27.684945]   IO window: d000-dfff
[   27.684982]   MEM window: f9f00000-f9ffffff
[   27.685020]   PREFETCH window: disabled.
[   27.685057] PCI: Bridge: 0000:00:0b.0
[   27.685094]   IO window: c000-cfff
[   27.685130]   MEM window: f9e00000-f9efffff
[   27.685167]   PREFETCH window: disabled.
[   27.685204] PCI: Bridge: 0000:00:0c.0
[   27.685240]   IO window: disabled.
[   27.685277]   MEM window: disabled.
[   27.685313]   PREFETCH window: disabled.
[   27.685350] PCI: Bridge: 0000:00:0d.0
[   27.685386]   IO window: e000-efff
[   27.685423]   MEM window: fa000000-febfffff
[   27.685460]   PREFETCH window: d0000000-dfffffff
[   27.685497] PCI: Bridge: 0000:00:0e.0
[   27.685534]   IO window: disabled.
[   27.685570]   MEM window: disabled.
[   27.685606]   PREFETCH window: disabled.
[   27.685649] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   27.685657] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   27.685662] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   27.685667] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   27.685672] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   27.685678] NET: Registered protocol family 2
[   27.717007] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   27.717603] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[   27.719026] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   27.719509] TCP: Hash tables configured (established 262144 bind 65536)
[   27.719549] TCP reno registered
[   27.727790] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[   27.727894] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[   27.727942] io scheduler noop registered
[   27.727980] io scheduler cfq registered (default)
[   27.728676] Boot video device is 0000:04:00.0
[   27.728779] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   27.728796] assign_interrupt_mode Found MSI capability
[   27.728849] Allocate Port Service[0000:00:0b.0:pcie00]
[   27.728891] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   27.728907] assign_interrupt_mode Found MSI capability
[   27.728955] Allocate Port Service[0000:00:0c.0:pcie00]
[   27.728992] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   27.729008] assign_interrupt_mode Found MSI capability
[   27.729056] Allocate Port Service[0000:00:0d.0:pcie00]
[   27.729094] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   27.729110] assign_interrupt_mode Found MSI capability
[   27.729158] Allocate Port Service[0000:00:0e.0:pcie00]
[   27.729331] input: Power Button (FF) as /class/input/input0
[   27.729369] ACPI: Power Button (FF) [PWRF]
[   27.729455] input: Power Button (CM) as /class/input/input1
[   27.729493] ACPI: Power Button (CM) [PWRB]
[   27.729627] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
[   27.729732] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
[   27.753629] Real Time Clock Driver v1.12ac
[   27.753749] hpet_resources: 0xfed00000 is busy
[   27.753766] Linux agpgart interface v0.102
[   27.753851] Driver 'sd' needs updating - please use bus_type methods
[   27.753925] ahci 0000:00:0a.0: version 3.0
[   27.754100] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   27.754143] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[   28.754676] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl IDE mode
[   28.754728] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[   28.754767] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   28.754969] scsi0 : ahci
[   28.755064] scsi1 : ahci
[   28.755130] scsi2 : ahci
[   28.755196] scsi3 : ahci
[   28.755284] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 irq 315
[   28.755332] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 irq 315
[   28.755379] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 irq 315
[   28.755426] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 irq 315
[   29.386629] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   29.387240] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   29.387283] ata1.00: 312581808 sectors, multi 16: LBA48 
[   29.387918] ata1.00: configured for UDMA/133
[   30.018591] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   30.039146] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   30.039186] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   30.041191] ata2.00: configured for UDMA/133
[   30.357854] ata3: SATA link down (SStatus 0 SControl 300)
[   30.677160] ata4: SATA link down (SStatus 0 SControl 300)
[   30.677249] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 PQ: 0 ANSI: 5
[   30.677359] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   30.677404] sd 0:0:0:0: [sda] Write Protect is off
[   30.677442] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   30.677450] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.677520] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   30.677563] sd 0:0:0:0: [sda] Write Protect is off
[   30.677601] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   30.677608] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.677657]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   30.713124] sd 0:0:0:0: [sda] Attached SCSI disk
[   30.713259] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[   30.713368] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   30.713412] sd 1:0:0:0: [sdb] Write Protect is off
[   30.713450] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   30.713459] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.713529] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   30.713572] sd 1:0:0:0: [sdb] Write Protect is off
[   30.713610] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   30.713617] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.713666]  sdb: sdb1 sdb2
[   30.720847] sd 1:0:0:0: [sdb] Attached SCSI disk
[   30.720984] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   30.723565] serio: i8042 KBD port at 0x60,0x64 irq 1
[   30.723604] serio: i8042 AUX port at 0x60,0x64 irq 12
[   30.757909] usbcore: registered new interface driver usbhid
[   30.757947] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   30.757991] TCP cubic registered
[   30.758030] NET: Registered protocol family 1
[   30.758087] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[   30.758143] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   30.758183] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   30.758221] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   30.758259] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   30.758297] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   30.758335] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   30.758373] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   30.758411] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   30.785840] input: AT Translated Set 2 keyboard as /class/input/input2
[   30.884040] ReiserFS: sda3: found reiserfs format "3.6" with standard journal
[   30.884083] ReiserFS: sda3: using ordered data mode
[   30.893590] ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   30.894500] ReiserFS: sda3: checking transaction log (sda3)
[   30.937895] ReiserFS: sda3: Using r5 hash to sort names
[   30.937946] VFS: Mounted root (reiserfs filesystem) readonly.
[   30.937996] Freeing unused kernel memory: 176k freed
[   31.240623] Clocksource tsc unstable (delta = -101952042 ns)
[   32.785186] ReiserFS: sda3: switching to journaled data mode
[   33.851423] r8169 Gigabit Ethernet driver 2.2LK loaded
[   33.851628] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   33.851633] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
[   33.851642] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   33.851789] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, XID 38000000 IRQ 314
[   33.855223] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   33.855229] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
[   33.855374] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   33.855377] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   33.855458] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   33.855480] ehci_hcd 0000:00:02.1: debug port 1
[   33.855483] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   33.855489] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   33.858684] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   33.858754] usb usb1: configuration #1 chosen from 1 choice
[   33.858768] hub 1-0:1.0: USB hub found
[   33.858773] hub 1-0:1.0: 10 ports detected
[   33.969146] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   33.994089] reiser4: sdb2: found disk format 4.0.0.
[   34.009535] usb 1-3: configuration #1 chosen from 1 choice
[   34.009727] hub 1-3:1.0: USB hub found
[   34.010451] hub 1-3:1.0: 4 ports detected
[   34.106728] usb 1-3.1: new low speed USB device using ehci_hcd and address 3
[   34.141157] usb 1-3.1: configuration #1 chosen from 1 choice
[   34.144754] input: Logitech USB Receiver as /class/input/input3
[   34.153515] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   34.155582] input: Logitech USB Receiver as /class/input/input4
[   34.160990] mice: PS/2 mouse device common for all mice
[   34.175696] input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   42.876614] reiser4: sda6: found disk format 4.0.0.
[   43.324415] reiser4: sdb1: found disk format 4.0.0.
[   43.741998] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
[   45.013198] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   45.013203] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 (level, low) -> IRQ 18
[   45.014300] Audigy2 value: Special config.
[   46.597359] w83627ehf: Found W83627EHG chip at 0x290
[   47.883333] r8169: eth0: link up
[   47.883342] r8169: eth0: link up
[   48.563063] NET: Registered protocol family 17
[   51.559910] nvidia: module license 'NVIDIA' taints kernel.
[   51.731619] ACPI: PCI Interrupt Link [LNED] enabled at IRQ 17
[   51.731627] ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNED] -> GSI 17 (level, low) -> IRQ 17
[   51.731632] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   51.731723] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  171.06  Wed Feb 20 09:02:26 PST 2008

--Boundary-00=_irh3HthWUCWwT/r--
