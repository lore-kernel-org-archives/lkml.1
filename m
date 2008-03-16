Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbYCPIei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbYCPIei (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 04:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYCPIe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 04:34:27 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:57842 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbYCPIeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 04:34:20 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay.
Date: Sun, 16 Mar 2008 09:34:13 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <47D5320E.8020107@gmail.com>
In-Reply-To: <47D5320E.8020107@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_FuN3Hz3akWLsk6a"
Message-Id: <200803160934.13873.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_FuN3Hz3akWLsk6a
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I tried three more kernels.

2.6.25-rc5
2.6.23.17
and
2.6.23.11

and I get the same result with all three of them which is puzzling for me,=
=20
because once 2.6.23.11 was ok and first came the timeouts then the timeouts=
=20
and then the hardware changes (PATA harddisk replaced with SATA harddisk).

this is with 2.6.25-rc5 on a coldboot:

    1.360551] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf=
=20
impl IDE mode
[    1.360551] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[    1.360551] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.360553] scsi0 : ahci
[    1.360567] scsi1 : ahci
[    1.360578] scsi2 : ahci
[    1.360591] scsi3 : ahci
[    1.360597] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0=20
irq 315
[    1.360597] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0=20
irq 315
[    1.360597] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0=20
irq 315
[    1.360597] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0=20
irq 315
[    1.794389] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   31.794187] ata1.00: qc timeout (cmd 0xec)
[   31.794187] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[   31.794187] ata1: failed to recover some devices, retrying in 5 secs
[   37.431961] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   37.432460] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   37.432460] ata1.00: 312581808 sectors, multi 16: LBA48
[   37.432990] ata1.00: configured for UDMA/133
[   38.064932] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   38.085423] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   38.085423] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   38.087332] ata2.00: configured for UDMA/133
[   38.404590] ata3: SATA link down (SStatus 0 SControl 300)
[   38.724459] ata4: SATA link down (SStatus 0 SControl 300)
[   38.923769] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ: 0 ANSI: 5
[   38.923781] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   38.923781] sd 0:0:0:0: [sda] Write Protect is off
[   38.923782] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   38.923782] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   38.923782] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   38.923782] sd 0:0:0:0: [sda] Write Protect is off
[   38.923782] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   38.923782] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   38.923782]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   38.756509] sd 0:0:0:0: [sda] Attached SCSI disk
[   38.756520] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10=20
PQ: 0 ANSI: 5
[   38.756526] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   38.756526] sd 1:0:0:0: [sdb] Write Protect is off
[   38.756526] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   38.756526] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   38.756526] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   38.756526] sd 1:0:0:0: [sdb] Write Protect is off
[   38.756526] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   38.756526] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   38.756526]  sdb: sdb1 sdb2

complete dmesgs are attached. Please ignore the kernel names. After=20
doing 'make oldconfig' I forgot to remove the 'reiser4_ahci_debug' part. Al=
l=20
three kernels are built from unpatched sources.
All I did was copying the config of 2.6.24 and doing make oldconfig.

If  there is something I could/should try/do please tell me so.

Gl=FCck Auf,
Volker

--Boundary-00=_FuN3Hz3akWLsk6a
Content-Type: text/plain;
  charset="iso-8859-15";
  name="dmesg_2.6.23.11_coldboot"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.23.11_coldboot"

[    0.000000] Linux version 2.6.23.11 (root@energy) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Sun Mar 16 09:07:15 CET 2008
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
[    0.000000]   DMA zone: 753 pages reserved
[    0.000000]   DMA zone: 3190 pages, LIFO batch:0
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
[    0.000000] PERCPU: Allocating 29416 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 1030622
[    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[   30.622165] time.c: Detected 3013.887 MHz processor.
[   30.625985] Console: colour VGA+ 80x25
[   30.625987] console [tty6] enabled
[   30.630562] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[   30.632903] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   30.633672] Checking aperture...
[   30.633710] CPU 0: aperture @ ec8a000000 size 32 MB
[   30.633747] Aperture too small (32 MB)
[   30.639571] No AGP bridge found
[   30.639606] Your BIOS doesn't leave a aperture memory hole
[   30.639644] Please enable the IOMMU option in the BIOS setup
[   30.639682] This costs you 64 MB of RAM
[   30.664870] Mapping aperture over 65536 KB of RAM @ 8000000
[   30.688055] Memory: 4050348k/4980736k available (1882k kernel code, 143028k reserved, 592k data, 172k init)
[   30.688125] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   30.768661] Calibrating delay using timer specific routine.. 6034.64 BogoMIPS (lpj=10053828)
[   30.768753] Mount-cache hash table entries: 256
[   30.768858] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   30.768898] CPU: L2 Cache: 1024K (64 bytes/line)
[   30.768936] CPU: Physical Processor ID: 0
[   30.768972] CPU: Processor Core ID: 0
[   30.769025] SMP alternatives: switching to UP code
[   30.769342] ACPI: Core revision 20070126
[   30.804508] Using local APIC timer interrupts.
[   30.837651] result 12557871
[   30.837686] Detected 12.557 MHz APIC timer.
[   30.838540] SMP alternatives: switching to SMP code
[   30.838744] Booting processor 1/2 APIC 0x1
[   30.849067] Initializing CPU#1
[   30.931859] Calibrating delay using timer specific routine.. 6030.01 BogoMIPS (lpj=10046417)
[   30.931863] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   30.931865] CPU: L2 Cache: 1024K (64 bytes/line)
[   30.931866] CPU: Physical Processor ID: 0
[   30.931867] CPU: Processor Core ID: 1
[   30.931948] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   30.934954] Brought up 2 CPUs
[   30.935431] NET: Registered protocol family 16
[   30.935540] ACPI: bus type pci registered
[   30.935622] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   30.935661] PCI: Not using MMCONFIG.
[   30.935698] PCI: Using configuration type 1
[   30.938097] ACPI: EC: Look up EC in DSDT
[   30.941714] ACPI: Interpreter enabled
[   30.941751] ACPI: (supports S0 S1 S3 S4 S5)
[   30.941921] ACPI: Using IOAPIC for interrupt routing
[   30.942217] Error attaching device data
[   30.942256] Error attaching device data
[   30.942294] Error attaching device data
[   30.942333] Error attaching device data
[   30.948094] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   30.948609] PCI: Transparent bridge - 0000:00:08.0
[   30.948925] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   30.949068] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   30.949178] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   30.949243] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   30.949307] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   30.949371] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   30.953746] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[   30.954101] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[   30.954453] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[   30.954829] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[   30.955224] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[   30.955601] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   30.955952] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[   30.956328] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   30.956679] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   30.957029] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[   30.957405] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   30.957756] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[   30.958133] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
[   30.958525] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   30.958876] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
[   30.959254] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   30.959605] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
[   30.960008] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[   30.960385] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disabled.
[   30.960762] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disabled.
[   30.961092] Linux Plug and Play Support v0.97 (c) Adam Belay
[   30.961143] pnp: PnP ACPI init
[   30.961183] ACPI: bus type pnp registered
[   30.964050] pnp: PnP ACPI: found 13 devices
[   30.964087] ACPI: ACPI bus type pnp unregistered
[   30.964202] SCSI subsystem initialized
[   30.964262] libata version 2.21 loaded.
[   30.964313] usbcore: registered new interface driver usbfs
[   30.964367] usbcore: registered new interface driver hub
[   30.964424] usbcore: registered new device driver usb
[   30.964508] PCI: Using ACPI for IRQ routing
[   30.964546] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   30.974899] PCI-DMA: Disabling AGP.
[   30.975639] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   30.975680] PCI-DMA: using GART IOMMU.
[   30.975719] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   30.975877] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   30.976015] hpet0: 3 32-bit timers, 25000000 Hz
[   30.978189] Time: hpet clocksource has been installed.
[   30.988213] pnp: 00:05: ioport range 0x4d0-0x4d1 has been reserved
[   30.988252] pnp: 00:05: ioport range 0x800-0x80f has been reserved
[   30.988291] pnp: 00:05: ioport range 0x2000-0x207f has been reserved
[   30.988330] pnp: 00:05: ioport range 0x2080-0x20ff has been reserved
[   30.988369] pnp: 00:05: ioport range 0x2400-0x247f has been reserved
[   30.988409] pnp: 00:05: ioport range 0x2480-0x24ff has been reserved
[   30.991788] pnp: 00:05: ioport range 0x2800-0x287f has been reserved
[   30.991827] pnp: 00:05: ioport range 0x2880-0x28ff has been reserved
[   30.991867] pnp: 00:05: ioport range 0x2c00-0x2c7f has been reserved
[   30.991906] pnp: 00:05: ioport range 0x2c80-0x2cff has been reserved
[   30.991945] pnp: 00:05: iomem range 0x0-0x0 could not be reserved
[   30.991984] pnp: 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[   30.992028] pnp: 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[   30.992075] pnp: 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[   30.992125] pnp: 00:0a: ioport range 0x290-0x29f has been reserved
[   30.992167] pnp: 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[   30.992210] pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   30.992249] pnp: 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   30.992288] pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   30.992327] pnp: 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
[   30.992367] pnp: 00:0c: iomem range 0xff380000-0xffffffff could not be reserved
[   30.992592] PCI: Bridge: 0000:00:08.0
[   30.992629]   IO window: d000-dfff
[   30.992666]   MEM window: f9f00000-f9ffffff
[   30.992703]   PREFETCH window: f0000000-f00fffff
[   30.992741] PCI: Bridge: 0000:00:0b.0
[   30.992778]   IO window: c000-cfff
[   30.992814]   MEM window: f9e00000-f9efffff
[   30.992851]   PREFETCH window: disabled.
[   30.992888] PCI: Bridge: 0000:00:0c.0
[   30.992924]   IO window: disabled.
[   30.992960]   MEM window: disabled.
[   30.992996]   PREFETCH window: disabled.
[   30.993033] PCI: Bridge: 0000:00:0d.0
[   30.993069]   IO window: e000-efff
[   30.993106]   MEM window: fa000000-febfffff
[   30.993143]   PREFETCH window: d0000000-dfffffff
[   30.993180] PCI: Bridge: 0000:00:0e.0
[   30.993216]   IO window: disabled.
[   30.993253]   MEM window: disabled.
[   30.993289]   PREFETCH window: disabled.
[   30.993331] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   30.993340] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   30.993345] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   30.993350] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   30.993356] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   30.993362] NET: Registered protocol family 2
[   31.028086] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   31.028576] TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
[   31.029738] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   31.030207] TCP: Hash tables configured (established 131072 bind 65536)
[   31.030246] TCP reno registered
[   31.042427] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[   31.042477] io scheduler noop registered
[   31.042515] io scheduler cfq registered (default)
[   31.043197] Boot video device is 0000:04:00.0
[   31.043310] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   31.043327] assign_interrupt_mode Found MSI capability
[   31.043381] Allocate Port Service[0000:00:0b.0:pcie00]
[   31.043425] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   31.043440] assign_interrupt_mode Found MSI capability
[   31.043489] Allocate Port Service[0000:00:0c.0:pcie00]
[   31.043528] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   31.043544] assign_interrupt_mode Found MSI capability
[   31.043592] Allocate Port Service[0000:00:0d.0:pcie00]
[   31.043632] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   31.043648] assign_interrupt_mode Found MSI capability
[   31.043696] Allocate Port Service[0000:00:0e.0:pcie00]
[   31.043888] input: Power Button (FF) as /class/input/input0
[   31.043926] ACPI: Power Button (FF) [PWRF]
[   31.044017] input: Power Button (CM) as /class/input/input1
[   31.044055] ACPI: Power Button (CM) [PWRB]
[   31.044196] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
[   31.044302] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
[   31.048381] Real Time Clock Driver v1.12ac
[   31.048495] hpet_resources: 0xfed00000 is busy
[   31.048506] Linux agpgart interface v0.102
[   31.048679] ahci 0000:00:0a.0: version 2.3
[   31.048870] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   31.048914] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[   32.052676] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl IDE mode
[   32.052728] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[   32.052768] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   32.052974] scsi0 : ahci
[   32.053072] scsi1 : ahci
[   32.053141] scsi2 : ahci
[   32.053208] scsi3 : ahci
[   32.053268] ata1: SATA max UDMA/133 cmd 0xffffc20000020100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   32.053318] ata2: SATA max UDMA/133 cmd 0xffffc20000020180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   32.053368] ata3: SATA max UDMA/133 cmd 0xffffc20000020200 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   32.053418] ata4: SATA max UDMA/133 cmd 0xffffc20000020280 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   32.528024] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   62.463855] ata1.00: qc timeout (cmd 0xec)
[   62.463893] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   63.438325] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   63.439125] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   63.439165] ata1.00: 312581808 sectors, multi 16: LBA48 
[   63.439793] ata1.00: configured for UDMA/133
[   63.439831] ata1: EH pending after completion, repeating EH (cnt=4)
[   63.913919] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   63.934676] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   63.934715] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   63.936701] ata2.00: configured for UDMA/133
[   64.249827] ata3: SATA link down (SStatus 0 SControl 300)
[   64.562456] ata4: SATA link down (SStatus 0 SControl 300)
[   64.562784] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 PQ: 0 ANSI: 5
[   64.562887] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   64.562931] sd 0:0:0:0: [sda] Write Protect is off
[   64.562970] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   64.562979] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   64.563050] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   64.563093] sd 0:0:0:0: [sda] Write Protect is off
[   64.563131] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   64.563138] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   64.563187]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   64.592670] sd 0:0:0:0: [sda] Attached SCSI disk
[   64.592782] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[   64.592875] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   64.592920] sd 1:0:0:0: [sdb] Write Protect is off
[   64.592957] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   64.592965] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   64.593029] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   64.593072] sd 1:0:0:0: [sdb] Write Protect is off
[   64.593109] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   64.593117] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   64.593166]  sdb: sdb1 sdb2
[   64.652294] sd 1:0:0:0: [sdb] Attached SCSI disk
[   64.652423] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   64.655085] serio: i8042 KBD port at 0x60,0x64 irq 1
[   64.655125] serio: i8042 AUX port at 0x60,0x64 irq 12
[   64.655291] usbcore: registered new interface driver usbhid
[   64.655329] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   64.655374] TCP cubic registered
[   64.655411] NET: Registered protocol family 1
[   64.655461] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.00.00)
[   64.655306] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   64.655345] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   64.655384] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   64.655421] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   64.655459] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   64.655497] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   64.655535] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   64.655574] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   64.681657] input: AT Translated Set 2 keyboard as /class/input/input2
[   64.780188] ReiserFS: sda3: found reiserfs format "3.6" with standard journal
[   64.780231] ReiserFS: sda3: using ordered data mode
[   64.789761] ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   64.790673] ReiserFS: sda3: checking transaction log (sda3)
[   64.825756] ReiserFS: sda3: Using r5 hash to sort names
[   64.825806] VFS: Mounted root (reiserfs filesystem) readonly.
[   64.825855] Freeing unused kernel memory: 172k freed
[   69.427873] ReiserFS: sda3: switching to journaled data mode
[   70.187872] r8169 Gigabit Ethernet driver 2.2LK loaded
[   70.188142] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   70.188150] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
[   70.188164] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   70.188344] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, XID 38000000 IRQ 19
[   70.191321] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   70.191331] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
[   70.191560] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   70.191565] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   70.191600] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   70.191627] ehci_hcd 0000:00:02.1: debug port 1
[   70.191630] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   70.191639] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   70.203321] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   70.203413] usb usb1: configuration #1 chosen from 1 choice
[   70.203430] hub 1-0:1.0: USB hub found
[   70.203436] hub 1-0:1.0: 10 ports detected
[   70.532346] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   70.656924] usb 1-3: configuration #1 chosen from 1 choice
[   70.657125] hub 1-3:1.0: USB hub found
[   70.659802] hub 1-3:1.0: 4 ports detected
[   70.689828] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
[   70.958571] usb 1-3.1: new low speed USB device using ehci_hcd and address 3
[   71.054162] usb 1-3.1: configuration #1 chosen from 1 choice
[   71.065216] input: Logitech USB Receiver as /class/input/input3
[   71.065229] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   71.071526] input: Logitech USB Receiver as /class/input/input4
[   71.071543] input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   72.249652] mice: PS/2 mouse device common for all mice
[   73.353925] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   73.353935] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 (level, low) -> IRQ 18
[   73.356700] Audigy2 value: Special config.
[   75.274992] w83627ehf: Found W83627EHG chip at 0x290
[   76.594832] r8169: eth0: link up
[   77.004133] NET: Registered protocol family 17

--Boundary-00=_FuN3Hz3akWLsk6a
Content-Type: text/plain;
  charset="iso-8859-15";
  name="dmesg_2.6.23.17_coldboot"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.23.17_coldboot"

[    0.000000] Linux version 2.6.23.17reiser4_ahci_debug (root@energy) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Sun Mar 16 08:58:43 CET 2008
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
[    0.000000]   DMA zone: 753 pages reserved
[    0.000000]   DMA zone: 3190 pages, LIFO batch:0
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
[    0.000000] PERCPU: Allocating 29416 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 1030622
[    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[   31.402615] time.c: Detected 3013.892 MHz processor.
[   31.406434] Console: colour VGA+ 80x25
[   31.406437] console [tty6] enabled
[   31.411020] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[   31.413367] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   31.414137] Checking aperture...
[   31.414175] CPU 0: aperture @ ecc8000000 size 32 MB
[   31.414213] Aperture too small (32 MB)
[   31.420024] No AGP bridge found
[   31.420060] Your BIOS doesn't leave a aperture memory hole
[   31.420098] Please enable the IOMMU option in the BIOS setup
[   31.420136] This costs you 64 MB of RAM
[   31.445349] Mapping aperture over 65536 KB of RAM @ 8000000
[   31.468560] Memory: 4050348k/4980736k available (1884k kernel code, 143028k reserved, 594k data, 172k init)
[   31.468631] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   31.549110] Calibrating delay using timer specific routine.. 6034.64 BogoMIPS (lpj=10053826)
[   31.549201] Mount-cache hash table entries: 256
[   31.549307] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   31.549347] CPU: L2 Cache: 1024K (64 bytes/line)
[   31.549385] CPU: Physical Processor ID: 0
[   31.549422] CPU: Processor Core ID: 0
[   31.549475] SMP alternatives: switching to UP code
[   31.549789] ACPI: Core revision 20070126
[   31.584959] Using local APIC timer interrupts.
[   31.618102] result 12557890
[   31.618137] Detected 12.557 MHz APIC timer.
[   31.618990] SMP alternatives: switching to SMP code
[   31.619195] Booting processor 1/2 APIC 0x1
[   31.629517] Initializing CPU#1
[   31.712306] Calibrating delay using timer specific routine.. 6030.02 BogoMIPS (lpj=10046445)
[   31.712310] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   31.712311] CPU: L2 Cache: 1024K (64 bytes/line)
[   31.712313] CPU: Physical Processor ID: 0
[   31.712314] CPU: Processor Core ID: 1
[   31.712394] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   31.715403] Brought up 2 CPUs
[   31.715881] NET: Registered protocol family 16
[   31.715991] ACPI: bus type pci registered
[   31.716073] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   31.716111] PCI: Not using MMCONFIG.
[   31.716148] PCI: Using configuration type 1
[   31.718415] ACPI: EC: Look up EC in DSDT
[   31.721791] ACPI: Interpreter enabled
[   31.721829] ACPI: (supports S0 S1 S3 S4 S5)
[   31.721998] ACPI: Using IOAPIC for interrupt routing
[   31.722283] Error attaching device data
[   31.722322] Error attaching device data
[   31.722361] Error attaching device data
[   31.722400] Error attaching device data
[   31.727700] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   31.728178] PCI: Transparent bridge - 0000:00:08.0
[   31.728490] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   31.728624] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   31.728745] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   31.728803] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   31.728861] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   31.728918] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   31.732915] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[   31.733257] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[   31.733594] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[   31.733956] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[   31.734318] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[   31.734681] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   31.735017] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[   31.735380] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   31.735717] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   31.736053] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[   31.736416] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   31.736752] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[   31.737114] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
[   31.737476] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   31.737812] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
[   31.738175] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   31.738511] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
[   31.738914] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[   31.739276] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disabled.
[   31.739639] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disabled.
[   31.739995] Linux Plug and Play Support v0.97 (c) Adam Belay
[   31.740047] pnp: PnP ACPI init
[   31.740086] ACPI: bus type pnp registered
[   31.742695] pnp: PnP ACPI: found 13 devices
[   31.742732] ACPI: ACPI bus type pnp unregistered
[   31.742848] SCSI subsystem initialized
[   31.742906] libata version 2.21 loaded.
[   31.742954] usbcore: registered new interface driver usbfs
[   31.743007] usbcore: registered new interface driver hub
[   31.743065] usbcore: registered new device driver usb
[   31.743147] PCI: Using ACPI for IRQ routing
[   31.743185] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   31.758673] PCI-DMA: Disabling AGP.
[   31.759406] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   31.759448] PCI-DMA: using GART IOMMU.
[   31.759486] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   31.759645] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   31.759783] hpet0: 3 32-bit timers, 25000000 Hz
[   31.762200] Time: hpet clocksource has been installed.
[   31.768662] pnp: 00:05: iomem range 0x0-0x0 could not be reserved
[   31.768702] pnp: 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[   31.768745] pnp: 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[   31.768792] pnp: 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[   31.772200] pnp: 00:0a: ioport range 0x290-0x29f has been reserved
[   31.772241] pnp: 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[   31.772284] pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   31.772323] pnp: 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   31.772362] pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   31.772401] pnp: 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
[   31.772618] PCI: Bridge: 0000:00:08.0
[   31.772655]   IO window: d000-dfff
[   31.772692]   MEM window: f9f00000-f9ffffff
[   31.772729]   PREFETCH window: f0000000-f00fffff
[   31.772768] PCI: Bridge: 0000:00:0b.0
[   31.772804]   IO window: c000-cfff
[   31.772841]   MEM window: f9e00000-f9efffff
[   31.772877]   PREFETCH window: disabled.
[   31.772914] PCI: Bridge: 0000:00:0c.0
[   31.772950]   IO window: disabled.
[   31.772986]   MEM window: disabled.
[   31.773022]   PREFETCH window: disabled.
[   31.773060] PCI: Bridge: 0000:00:0d.0
[   31.773096]   IO window: e000-efff
[   31.773132]   MEM window: fa000000-febfffff
[   31.773169]   PREFETCH window: d0000000-dfffffff
[   31.773207] PCI: Bridge: 0000:00:0e.0
[   31.773243]   IO window: disabled.
[   31.773279]   MEM window: disabled.
[   31.773316]   PREFETCH window: disabled.
[   31.773358] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   31.773367] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   31.773372] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   31.773377] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   31.773382] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   31.773387] NET: Registered protocol family 2
[   31.808535] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   31.809025] TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
[   31.810182] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   31.810645] TCP: Hash tables configured (established 131072 bind 65536)
[   31.810685] TCP reno registered
[   31.822871] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[   31.822919] io scheduler noop registered
[   31.822957] io scheduler cfq registered (default)
[   31.823635] Boot video device is 0000:04:00.0
[   31.823749] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   31.823767] assign_interrupt_mode Found MSI capability
[   31.823820] Allocate Port Service[0000:00:0b.0:pcie00]
[   31.823864] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   31.823880] assign_interrupt_mode Found MSI capability
[   31.823929] Allocate Port Service[0000:00:0c.0:pcie00]
[   31.823968] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   31.823984] assign_interrupt_mode Found MSI capability
[   31.824031] Allocate Port Service[0000:00:0d.0:pcie00]
[   31.824070] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   31.824086] assign_interrupt_mode Found MSI capability
[   31.824134] Allocate Port Service[0000:00:0e.0:pcie00]
[   31.824331] input: Power Button (FF) as /class/input/input0
[   31.824370] ACPI: Power Button (FF) [PWRF]
[   31.824467] input: Power Button (CM) as /class/input/input1
[   31.824505] ACPI: Power Button (CM) [PWRB]
[   31.824645] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
[   31.824750] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
[   31.855387] Real Time Clock Driver v1.12ac
[   31.855497] hpet_resources: 0xfed00000 is busy
[   31.855510] Linux agpgart interface v0.102
[   31.855681] ahci 0000:00:0a.0: version 2.3
[   31.855857] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   31.855900] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[   32.859729] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl IDE mode
[   32.859782] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[   32.859822] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   32.860029] scsi0 : ahci
[   32.860130] scsi1 : ahci
[   32.860198] scsi2 : ahci
[   32.860266] scsi3 : ahci
[   32.860326] ata1: SATA max UDMA/133 cmd 0xffffc20000020100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   32.860377] ata2: SATA max UDMA/133 cmd 0xffffc20000020180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   32.860427] ata3: SATA max UDMA/133 cmd 0xffffc20000020200 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   32.860477] ata4: SATA max UDMA/133 cmd 0xffffc20000020280 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   33.335080] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   63.270911] ata1.00: qc timeout (cmd 0xec)
[   63.270949] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   64.245381] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   64.246192] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   64.246232] ata1.00: 312581808 sectors, multi 16: LBA48 
[   64.246848] ata1.00: configured for UDMA/133
[   64.246885] ata1: EH pending after completion, repeating EH (cnt=4)
[   64.720974] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   64.741732] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   64.741772] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   64.743751] ata2.00: configured for UDMA/133
[   65.056884] ata3: SATA link down (SStatus 0 SControl 300)
[   65.369512] ata4: SATA link down (SStatus 0 SControl 300)
[   65.369839] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 PQ: 0 ANSI: 5
[   65.369941] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   65.369985] sd 0:0:0:0: [sda] Write Protect is off
[   65.370024] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   65.370033] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   65.370104] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   65.370147] sd 0:0:0:0: [sda] Write Protect is off
[   65.370184] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   65.370192] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   65.370241]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   65.398814] sd 0:0:0:0: [sda] Attached SCSI disk
[   65.398929] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[   65.399023] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   65.399066] sd 1:0:0:0: [sdb] Write Protect is off
[   65.399104] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   65.399111] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   65.399174] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   65.399217] sd 1:0:0:0: [sdb] Write Protect is off
[   65.399255] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   65.399263] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   65.399311]  sdb: sdb1 sdb2
[   65.404062] sd 1:0:0:0: [sdb] Attached SCSI disk
[   65.404202] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   65.406763] serio: i8042 KBD port at 0x60,0x64 irq 1
[   65.406802] serio: i8042 AUX port at 0x60,0x64 irq 12
[   65.439680] usbcore: registered new interface driver usbhid
[   65.439719] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   65.439763] TCP cubic registered
[   65.439800] NET: Registered protocol family 1
[   65.439850] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.00.00)
[   65.439700] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   65.439739] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   65.439777] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   65.439815] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   65.439853] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   65.439891] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   65.439929] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   65.439967] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   65.465337] input: AT Translated Set 2 keyboard as /class/input/input2
[   65.569737] ReiserFS: sda3: found reiserfs format "3.6" with standard journal
[   65.569782] ReiserFS: sda3: using ordered data mode
[   65.579310] ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   65.580258] ReiserFS: sda3: checking transaction log (sda3)
[   65.615306] ReiserFS: sda3: Using r5 hash to sort names
[   65.615357] VFS: Mounted root (reiserfs filesystem) readonly.
[   65.615408] Freeing unused kernel memory: 172k freed
[   70.172353] ReiserFS: sda3: switching to journaled data mode
[   71.668052] r8169 Gigabit Ethernet driver 2.2LK loaded
[   71.668284] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   71.668292] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
[   71.668305] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   71.668482] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, XID 38000000 IRQ 19
[   71.671464] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   71.671474] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
[   71.671706] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   71.671711] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   71.671742] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   71.671771] ehci_hcd 0000:00:02.1: debug port 1
[   71.671774] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   71.671783] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   71.682195] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   71.685421] usb usb1: configuration #1 chosen from 1 choice
[   71.685495] hub 1-0:1.0: USB hub found
[   71.685502] hub 1-0:1.0: 10 ports detected
[   72.017873] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   72.142424] usb 1-3: configuration #1 chosen from 1 choice
[   72.143974] hub 1-3:1.0: USB hub found
[   72.144262] hub 1-3:1.0: 4 ports detected
[   72.160810] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
[   72.443882] usb 1-3.1: new low speed USB device using ehci_hcd and address 3
[   72.539843] usb 1-3.1: configuration #1 chosen from 1 choice
[   72.551132] input: Logitech USB Receiver as /class/input/input3
[   72.716389] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   72.722292] input: Logitech USB Receiver as /class/input/input4
[   72.926078] input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   73.960227] mice: PS/2 mouse device common for all mice
[   75.108931] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   75.108941] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 (level, low) -> IRQ 18
[   75.111700] Audigy2 value: Special config.
[   77.011602] w83627ehf: Found W83627EHG chip at 0x290
[   78.457978] r8169: eth0: link up
[   78.457986] r8169: eth0: link up
[   79.251462] NET: Registered protocol family 17

--Boundary-00=_FuN3Hz3akWLsk6a
Content-Type: text/plain;
  charset="iso-8859-15";
  name="dmesg_2.6.25_rc5_coldboot"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.25_rc5_coldboot"

[    0.000000] Linux version 2.6.25-rc5reiser4_ahci_debug (root@energy) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Sun Mar 16 08:44:10 CET 2008
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
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-50c113] TEXT DATA BSS
[    0.000000] early res: 3 [9fc00-a0bff] EBDA
[    0.000000] early res: 4 [8000-dfff] PGTABLE
[    0.000000] No mptable found.
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 on node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 on node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 on node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 on node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 on node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 on node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 on node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 on node 0
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
[    0.000000]   DMA zone: 790 pages reserved
[    0.000000]   DMA zone: 3153 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
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
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 00000000cffc0000
[    0.000000] PM: Registered nosave memory: 00000000cffc0000 - 00000000cfff0000
[    0.000000] PM: Registered nosave memory: 00000000cfff0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ff380000
[    0.000000] PM: Registered nosave memory: 00000000ff380000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 32576 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1030585
[    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000002] time.c: Detected 3013.889 MHz processor.
[    0.000011] spurious 8259A interrupt: IRQ7.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty6] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003333] Checking aperture...
[    0.003333] Node 0: aperture @ ecc8000000 size 32 MB
[    0.003333] Aperture beyond 4GB. Ignoring.
[    0.003333] No AGP bridge found
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ c000000
[    0.003333] Memory: 4048020k/4980736k available (1962k kernel code, 144868k reserved, 639k data, 192k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.083330] Calibrating delay using timer specific routine.. 6034.73 BogoMIPS (lpj=10053972)
[    0.083419] Mount-cache hash table entries: 256
[    0.083537] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.083577] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.083615] CPU: Physical Processor ID: 0
[    0.083651] CPU: Processor Core ID: 0
[    0.083701] ACPI: Core revision 20070126
[    0.122329] Using local APIC timer interrupts.
[    0.123326] APIC timer calibration result 12557874
[    0.123327] Detected 12.557 MHz APIC timer.
[    0.123429] Booting processor 1/2 APIC 0x1
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6030.95 BogoMIPS (lpj=10046322)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.216844] Brought up 2 CPUs
[    0.217290] net_namespace: 304 bytes
[    0.217406] NET: Registered protocol family 16
[    0.217492] ACPI: bus type pci registered
[    0.217568] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[    0.217607] PCI: Not using MMCONFIG.
[    0.217644] PCI: Using configuration type 1
[    0.220669] ACPI: EC: Look up EC in DSDT
[    0.225009] ACPI: Interpreter enabled
[    0.225046] ACPI: (supports S0 S1 S3 S4 S5)
[    0.225217] ACPI: Using IOAPIC for interrupt routing
[    0.225395] ACPI: Error attaching device data
[    0.225435] ACPI: Error attaching device data
[    0.225474] ACPI: Error attaching device data
[    0.225514] ACPI: Error attaching device data
[    0.231309] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.231834] PCI: Transparent bridge - 0000:00:08.0
[    0.232089] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.232232] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.232339] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.232404] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.232469] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.232533] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.237379] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[    0.237745] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[    0.238110] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.238501] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.238891] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[    0.239282] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.239646] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[    0.240118] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[    0.240482] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[    0.240846] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[    0.241237] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.241601] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    0.241992] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
[    0.242382] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.242747] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
[    0.243140] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[    0.243500] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
[    0.243917] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[    0.244308] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disabled.
[    0.244699] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disabled.
[    0.245029] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.245077] pnp: PnP ACPI init
[    0.245116] ACPI: bus type pnp registered
[    0.248367] pnp: PnP ACPI: found 13 devices
[    0.248405] ACPI: ACPI bus type pnp unregistered
[    0.248541] SCSI subsystem initialized
[    0.248607] libata version 3.00 loaded.
[    0.248669] usbcore: registered new interface driver usbfs
[    0.248727] usbcore: registered new interface driver hub
[    0.248790] usbcore: registered new device driver usb
[    0.248899] PCI: Using ACPI for IRQ routing
[    0.248937] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.266666] PCI-DMA: Disabling AGP.
[    0.266666] PCI-DMA: aperture base @ c000000 size 65536 KB
[    0.266666] PCI-DMA: using GART IOMMU.
[    0.266666] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.266666] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.266666] hpet0: 3 32-bit timers, 25000000 Hz
[    0.266666] Time: hpet clocksource has been installed.
[    0.266675] Switched to high resolution mode on CPU 0
[    0.056681] Switched to high resolution mode on CPU 1
[    0.276738] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.276738] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.276738] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.276738] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.276738] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.276738] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.276738] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.276738] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.276738] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.276738] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.276738] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.276738] system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[    0.276744] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.276792] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.276843] system 00:0a: ioport range 0x290-0x29f has been reserved
[    0.276886] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.276929] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.276968] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.277008] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.277053] system 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
[    0.277101] system 00:0c: iomem range 0xff380000-0xffffffff could not be reserved
[    0.277547] PCI: Bridge: 0000:00:08.0
[    0.277584]   IO window: d000-dfff
[    0.277622]   MEM window: 0xf9f00000-0xf9ffffff
[    0.277660]   PREFETCH window: disabled.
[    0.277698] PCI: Bridge: 0000:00:0b.0
[    0.277735]   IO window: c000-cfff
[    0.277772]   MEM window: 0xf9e00000-0xf9efffff
[    0.277809]   PREFETCH window: disabled.
[    0.277847] PCI: Bridge: 0000:00:0c.0
[    0.277883]   IO window: disabled.
[    0.277920]   MEM window: disabled.
[    0.277956]   PREFETCH window: disabled.
[    0.277994] PCI: Bridge: 0000:00:0d.0
[    0.278030]   IO window: e000-efff
[    0.278067]   MEM window: 0xfa000000-0xfebfffff
[    0.278105]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.278145] PCI: Bridge: 0000:00:0e.0
[    0.278181]   IO window: disabled.
[    0.278218]   MEM window: disabled.
[    0.278254]   PREFETCH window: disabled.
[    0.278298] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    0.278307] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.278312] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.278317] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.278322] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.278329] NET: Registered protocol family 2
[    0.313402] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.313402] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.313402] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.313402] TCP: Hash tables configured (established 262144 bind 65536)
[    0.313402] TCP reno registered
[    0.323700] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.323700] io scheduler noop registered
[    0.323700] io scheduler cfq registered (default)
[    0.323700] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.323700] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.323700] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.323700] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.323700] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.323700] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.323700] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.323700] pci 0000:04:00.0: Boot video device
[    0.323708] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.323708] assign_interrupt_mode Found MSI capability
[    0.323708] Allocate Port Service[0000:00:0b.0:pcie00]
[    0.323715] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.323715] assign_interrupt_mode Found MSI capability
[    0.323715] Allocate Port Service[0000:00:0c.0:pcie00]
[    0.323722] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.323722] assign_interrupt_mode Found MSI capability
[    0.323722] Allocate Port Service[0000:00:0d.0:pcie00]
[    0.323728] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.323728] assign_interrupt_mode Found MSI capability
[    0.323728] Allocate Port Service[0000:00:0e.0:pcie00]
[    0.323768] input: Power Button (FF) as /class/input/input0
[    0.323768] ACPI: Power Button (FF) [PWRF]
[    0.323775] input: Power Button (CM) as /class/input/input1
[    0.323775] ACPI: Power Button (CM) [PWRB]
[    0.323807] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.323814] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.357188] Real Time Clock Driver v1.12ac
[    0.357193] hpet_resources: 0xfed00000 is busy
[    0.357198] Linux agpgart interface v0.103
[    0.357218] Driver 'sd' needs updating - please use bus_type methods
[    0.357224] ahci 0000:00:0a.0: version 3.0
[    0.357224] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.357224] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[    1.360551] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl IDE mode
[    1.360551] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[    1.360551] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.360553] scsi0 : ahci
[    1.360567] scsi1 : ahci
[    1.360578] scsi2 : ahci
[    1.360591] scsi3 : ahci
[    1.360597] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 irq 315
[    1.360597] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 irq 315
[    1.360597] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 irq 315
[    1.360597] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 irq 315
[    1.794389] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   31.794187] ata1.00: qc timeout (cmd 0xec)
[   31.794187] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   31.794187] ata1: failed to recover some devices, retrying in 5 secs
[   37.431961] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   37.432460] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   37.432460] ata1.00: 312581808 sectors, multi 16: LBA48 
[   37.432990] ata1.00: configured for UDMA/133
[   38.064932] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   38.085423] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   38.085423] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   38.087332] ata2.00: configured for UDMA/133
[   38.404590] ata3: SATA link down (SStatus 0 SControl 300)
[   38.724459] ata4: SATA link down (SStatus 0 SControl 300)
[   38.923769] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 PQ: 0 ANSI: 5
[   38.923781] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   38.923781] sd 0:0:0:0: [sda] Write Protect is off
[   38.923782] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   38.923782] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   38.923782] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   38.923782] sd 0:0:0:0: [sda] Write Protect is off
[   38.923782] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   38.923782] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   38.923782]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   38.756509] sd 0:0:0:0: [sda] Attached SCSI disk
[   38.756520] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[   38.756526] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   38.756526] sd 1:0:0:0: [sdb] Write Protect is off
[   38.756526] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   38.756526] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   38.756526] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   38.756526] sd 1:0:0:0: [sdb] Write Protect is off
[   38.756526] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   38.756526] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   38.756526]  sdb: sdb1 sdb2
[   38.764139] sd 1:0:0:0: [sdb] Attached SCSI disk
[   38.764155] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   38.764991] serio: i8042 KBD port at 0x60,0x64 irq 1
[   38.765032] serio: i8042 AUX port at 0x60,0x64 irq 12
[   38.800936] usbcore: registered new interface driver usbhid
[   38.800936] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   38.800936] TCP cubic registered
[   38.800936] NET: Registered protocol family 1
[   38.800941] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[   39.001176] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   39.001176] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   39.001176] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   39.001176] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   39.001176] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   39.001176] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   39.001176] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   39.001176] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   38.827869] input: AT Translated Set 2 keyboard as /class/input/input2
[   38.927469] ReiserFS: sda3: found reiserfs format "3.6" with standard journal
[   38.927469] ReiserFS: sda3: using ordered data mode
[   38.938639] ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   38.938639] ReiserFS: sda3: checking transaction log (sda3)
[   38.985103] ReiserFS: sda3: Using r5 hash to sort names
[   38.985103] VFS: Mounted root (reiserfs filesystem) readonly.
[   38.985103] Freeing unused kernel memory: 192k freed
[   39.528203] Clocksource tsc unstable (delta = -222095591 ns)
[   44.417159] ReiserFS: sda3: switching to journaled data mode
[   44.863238] r8169 Gigabit Ethernet driver 2.2LK loaded
[   44.863478] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   44.863484] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
[   44.863492] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   44.863863] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, XID 38000000 IRQ 314
[   45.340950] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
[   51.203233] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   51.203239] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 (level, low) -> IRQ 18
[   51.206554] Audigy2 value: Special config.
[   54.752474] w83627ehf: Found W83627EHG chip at 0x290
[   56.228630] r8169: eth0: link up
[   56.228630] r8169: eth0: link up
[   57.373494] NET: Registered protocol family 17

--Boundary-00=_FuN3Hz3akWLsk6a
Content-Type: text/plain;
  charset="iso-8859-15";
  name="dmesg_2.6.25_rc5_reboot"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.25_rc5_reboot"

[    0.000000] Linux version 2.6.25-rc5reiser4_ahci_debug (root@energy) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Sun Mar 16 08:44:10 CET 2008
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
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-50c113] TEXT DATA BSS
[    0.000000] early res: 3 [9fc00-a0bff] EBDA
[    0.000000] early res: 4 [8000-dfff] PGTABLE
[    0.000000] No mptable found.
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 on node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 on node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 on node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 on node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 on node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 on node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 on node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 on node 0
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
[    0.000000]   DMA zone: 790 pages reserved
[    0.000000]   DMA zone: 3153 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
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
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 00000000cffc0000
[    0.000000] PM: Registered nosave memory: 00000000cffc0000 - 00000000cfff0000
[    0.000000] PM: Registered nosave memory: 00000000cfff0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ff380000
[    0.000000] PM: Registered nosave memory: 00000000ff380000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 32576 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1030585
[    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000002] time.c: Detected 3013.876 MHz processor.
[    0.000011] spurious 8259A interrupt: IRQ7.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty6] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003333] Checking aperture...
[    0.003333] Node 0: aperture @ c000000 size 32 MB
[    0.003333] Aperture pointing to e820 RAM. Ignoring.
[    0.003333] No AGP bridge found
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ c000000
[    0.003333] Memory: 4048020k/4980736k available (1962k kernel code, 144868k reserved, 639k data, 192k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.083330] Calibrating delay using timer specific routine.. 6034.72 BogoMIPS (lpj=10053965)
[    0.083419] Mount-cache hash table entries: 256
[    0.083537] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.083577] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.083615] CPU: Physical Processor ID: 0
[    0.083652] CPU: Processor Core ID: 0
[    0.083701] ACPI: Core revision 20070126
[    0.122329] Using local APIC timer interrupts.
[    0.123326] APIC timer calibration result 12557820
[    0.123327] Detected 12.557 MHz APIC timer.
[    0.123430] Booting processor 1/2 APIC 0x1
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6030.95 BogoMIPS (lpj=10046334)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.216844] Brought up 2 CPUs
[    0.217291] net_namespace: 304 bytes
[    0.217406] NET: Registered protocol family 16
[    0.217493] ACPI: bus type pci registered
[    0.217569] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[    0.217608] PCI: Not using MMCONFIG.
[    0.217644] PCI: Using configuration type 1
[    0.220668] ACPI: EC: Look up EC in DSDT
[    0.225011] ACPI: Interpreter enabled
[    0.225049] ACPI: (supports S0 S1 S3 S4 S5)
[    0.225220] ACPI: Using IOAPIC for interrupt routing
[    0.225396] ACPI: Error attaching device data
[    0.225436] ACPI: Error attaching device data
[    0.225476] ACPI: Error attaching device data
[    0.225516] ACPI: Error attaching device data
[    0.231311] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.231837] PCI: Transparent bridge - 0000:00:08.0
[    0.232092] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.232235] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.232343] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.232408] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.232472] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.232536] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.237274] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[    0.237640] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[    0.238005] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.238396] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.238786] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[    0.239177] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.239541] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[    0.240053] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[    0.240418] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[    0.240781] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[    0.241171] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.241535] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    0.241926] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
[    0.242316] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.242681] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
[    0.243073] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[    0.243446] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
[    0.243863] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[    0.244254] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disabled.
[    0.244645] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disabled.
[    0.244973] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.245021] pnp: PnP ACPI init
[    0.245060] ACPI: bus type pnp registered
[    0.248237] pnp: PnP ACPI: found 13 devices
[    0.248274] ACPI: ACPI bus type pnp unregistered
[    0.248378] SCSI subsystem initialized
[    0.248447] libata version 3.00 loaded.
[    0.248485] usbcore: registered new interface driver usbfs
[    0.248535] usbcore: registered new interface driver hub
[    0.248590] usbcore: registered new device driver usb
[    0.248667] PCI: Using ACPI for IRQ routing
[    0.248705] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.266649] PCI-DMA: Disabling AGP.
[    0.266649] PCI-DMA: aperture base @ c000000 size 65536 KB
[    0.266649] PCI-DMA: using GART IOMMU.
[    0.266649] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.266649] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.266649] hpet0: 3 32-bit timers, 25000000 Hz
[    0.266649] Time: hpet clocksource has been installed.
[    0.266659] Switched to high resolution mode on CPU 0
[    0.060013] Switched to high resolution mode on CPU 1
[    0.280057] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.280057] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.280057] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.280057] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.280057] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.280057] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.280057] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.280057] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.280057] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.280057] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.280057] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.280057] system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[    0.280063] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.280111] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.280162] system 00:0a: ioport range 0x290-0x29f has been reserved
[    0.280205] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.280248] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.280287] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.280327] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.280369] system 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
[    0.280417] system 00:0c: iomem range 0xff380000-0xffffffff could not be reserved
[    0.280862] PCI: Bridge: 0000:00:08.0
[    0.280899]   IO window: d000-dfff
[    0.280937]   MEM window: 0xf9f00000-0xf9ffffff
[    0.280975]   PREFETCH window: disabled.
[    0.281013] PCI: Bridge: 0000:00:0b.0
[    0.281050]   IO window: c000-cfff
[    0.281087]   MEM window: 0xf9e00000-0xf9efffff
[    0.281124]   PREFETCH window: disabled.
[    0.281162] PCI: Bridge: 0000:00:0c.0
[    0.281198]   IO window: disabled.
[    0.281234]   MEM window: disabled.
[    0.281271]   PREFETCH window: disabled.
[    0.281309] PCI: Bridge: 0000:00:0d.0
[    0.281346]   IO window: e000-efff
[    0.281382]   MEM window: 0xfa000000-0xfebfffff
[    0.281420]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.281460] PCI: Bridge: 0000:00:0e.0
[    0.281496]   IO window: disabled.
[    0.281533]   MEM window: disabled.
[    0.281570]   PREFETCH window: disabled.
[    0.281613] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    0.281622] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.281627] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.281632] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.281637] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.281644] NET: Registered protocol family 2
[    0.316722] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.316722] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.316722] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.316722] TCP: Hash tables configured (established 262144 bind 65536)
[    0.316722] TCP reno registered
[    0.327021] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.327021] io scheduler noop registered
[    0.327021] io scheduler cfq registered (default)
[    0.327021] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.327021] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.327021] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.327021] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.327021] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.327021] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.327021] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.327021] pci 0000:04:00.0: Boot video device
[    0.327029] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.327029] assign_interrupt_mode Found MSI capability
[    0.327029] Allocate Port Service[0000:00:0b.0:pcie00]
[    0.327036] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.327036] assign_interrupt_mode Found MSI capability
[    0.327036] Allocate Port Service[0000:00:0c.0:pcie00]
[    0.327042] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.327042] assign_interrupt_mode Found MSI capability
[    0.327042] Allocate Port Service[0000:00:0d.0:pcie00]
[    0.327048] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.327048] assign_interrupt_mode Found MSI capability
[    0.327048] Allocate Port Service[0000:00:0e.0:pcie00]
[    0.327089] input: Power Button (FF) as /class/input/input0
[    0.327089] ACPI: Power Button (FF) [PWRF]
[    0.327096] input: Power Button (CM) as /class/input/input1
[    0.327096] ACPI: Power Button (CM) [PWRB]
[    0.327128] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.327135] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.360510] Real Time Clock Driver v1.12ac
[    0.360514] hpet_resources: 0xfed00000 is busy
[    0.360520] Linux agpgart interface v0.103
[    0.360539] Driver 'sd' needs updating - please use bus_type methods
[    0.360546] ahci 0000:00:0a.0: version 3.0
[    0.360546] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.360546] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[    1.363873] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl IDE mode
[    1.363873] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[    1.363873] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.363875] scsi0 : ahci
[    1.363888] scsi1 : ahci
[    1.363902] scsi2 : ahci
[    1.363915] scsi3 : ahci
[    1.363921] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 irq 315
[    1.363921] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 irq 315
[    1.363921] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 irq 315
[    1.363921] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 irq 315
[    6.813858] ata1: port is slow to respond, please be patient (Status 0xd0)
[   11.186680] ata1: softreset failed (device not ready)
[   11.819883] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   11.820376] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   11.820376] ata1.00: 312581808 sectors, multi 16: LBA48 
[   11.820958] ata1.00: configured for UDMA/133
[   12.452853] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   12.473346] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   12.473346] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   12.475248] ata2.00: configured for UDMA/133
[   12.792506] ata3: SATA link down (SStatus 0 SControl 300)
[   13.112373] ata4: SATA link down (SStatus 0 SControl 300)
[   13.310536] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 PQ: 0 ANSI: 5
[   13.310548] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   13.310548] sd 0:0:0:0: [sda] Write Protect is off
[   13.310548] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   13.310548] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.310548] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   13.310548] sd 0:0:0:0: [sda] Write Protect is off
[   13.310548] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   13.310548] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.310548]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   13.147225] sd 0:0:0:0: [sda] Attached SCSI disk
[   13.147386] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[   13.147518] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   13.147565] sd 1:0:0:0: [sdb] Write Protect is off
[   13.147603] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   13.147617] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.147694] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   13.147740] sd 1:0:0:0: [sdb] Write Protect is off
[   13.147778] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   13.147792] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.147841]  sdb: sdb1 sdb2
[   13.212325] sd 1:0:0:0: [sdb] Attached SCSI disk
[   13.212340] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   13.213940] serio: i8042 KBD port at 0x60,0x64 irq 1
[   13.213981] serio: i8042 AUX port at 0x60,0x64 irq 12
[   13.242367] usbcore: registered new interface driver usbhid
[   13.242367] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   13.242367] TCP cubic registered
[   13.242367] NET: Registered protocol family 1
[   13.242372] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[   13.436867] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   13.436867] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   13.436867] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   13.436867] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   13.436867] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   13.436867] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   13.436867] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   13.436867] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   13.275118] input: AT Translated Set 2 keyboard as /class/input/input2
[   13.374485] ReiserFS: sda3: found reiserfs format "3.6" with standard journal
[   13.374485] ReiserFS: sda3: using ordered data mode
[   13.386998] ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   13.387124] ReiserFS: sda3: checking transaction log (sda3)
[   13.433787] ReiserFS: sda3: Using r5 hash to sort names
[   13.433787] VFS: Mounted root (reiserfs filesystem) readonly.
[   13.433787] Freeing unused kernel memory: 192k freed
[   14.952162] Clocksource tsc unstable (delta = -320178577 ns)
[   18.738775] ReiserFS: sda3: switching to journaled data mode
[   19.243171] r8169 Gigabit Ethernet driver 2.2LK loaded
[   19.243411] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   19.243417] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
[   19.243425] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   19.246367] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, XID 38000000 IRQ 314
[   19.729548] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
[   23.365197] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   23.365203] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 (level, low) -> IRQ 18
[   23.368324] Audigy2 value: Special config.
[   26.095970] w83627ehf: Found W83627EHG chip at 0x290
[   27.767190] r8169: eth0: link up
[   27.767190] r8169: eth0: link up
[   29.015156] NET: Registered protocol family 17

--Boundary-00=_FuN3Hz3akWLsk6a--
