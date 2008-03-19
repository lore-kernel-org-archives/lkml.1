Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYCSTqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYCSTqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbYCSTcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:32:18 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:59179 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755553AbYCSTcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:32:05 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Wed, 19 Mar 2008 08:53:09 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <47E087DF.7070101@gmail.com> <47E0883A.9010507@gmail.com>
In-Reply-To: <47E0883A.9010507@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mZM4HjSQaeFVPKY"
Message-Id: <200803190853.10030.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_mZM4HjSQaeFVPKY
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
On Mittwoch, 19. M=E4rz 2008, Tejun Heo wrote:
> Tejun Heo wrote:

> Just in case, here's the updated patch.

I tried your patch (on freshly unpacked sources).

non-raid setting in bios,

coldboot:

[   37.123980] ahci 0000:00:0a.0: version 3.0
[   37.124155] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   37.124199] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
=20
(level, low) -> IRQ 23
[   37.124533] ahci 0000:00:0a.0: controller can't do PMP, turning off CAP_=
PMP
[   38.124731] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
impl IDE mode
[   38.124780] ahci 0000:00:0a.0: flags: 64bit sntf led clo pio
[   38.124819] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   38.125020] scsi0 : ahci
[   38.125116] scsi1 : ahci
[   38.125182] scsi2 : ahci
[   38.125248] scsi3 : ahci
[   38.125337] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0=20
irq 315
[   38.125384] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0=20
irq 315
[   38.125432] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0=20
irq 315
[   38.125479] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0=20
irq 315
[   38.597035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   38.597732] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   38.597775] ata1.00: 312581808 sectors, multi 16: LBA48
[   38.598405] ata1.00: configured for UDMA/133
[   39.069342] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   39.084225] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   39.084264] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   39.086268] ata2.00: configured for UDMA/133
[   39.405277] ata3: SATA link down (SStatus 0 SControl 300)
[   39.724583] ata4: SATA link down (SStatus 0 SControl 300)
[   39.724672] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ: 0 ANSI: 5
[   39.724782] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   39.724826] sd 0:0:0:0: [sda] Write Protect is off
[   39.724864] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   39.724872] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   39.724942] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   39.724985] sd 0:0:0:0: [sda] Write Protect is off
[   39.725023] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   39.725030] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   39.725079]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   39.763787] sd 0:0:0:0: [sda] Attached SCSI disk
[   39.763923] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10=20
PQ: 0 ANSI: 5
[   39.764032] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   39.764077] sd 1:0:0:0: [sdb] Write Protect is off
[   39.764115] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   39.764124] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   39.764194] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   39.764237] sd 1:0:0:0: [sdb] Write Protect is off
[   39.764275] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   39.764283] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   39.764332]  sdb: sdb1 sdb2
[   39.793043] sd 1:0:0:0: [sdb] Attached SCSI disk

reboot:
[   39.522696] ahci 0000:00:0a.0: version 3.0
[   39.522871] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   39.522914] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
=20
(level, low) -> IRQ 23
[   39.523247] ahci 0000:00:0a.0: controller can't do PMP, turning off CAP_=
PMP
[   40.523447] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
impl IDE mode
[   40.523496] ahci 0000:00:0a.0: flags: 64bit sntf led clo pio
[   40.523535] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   40.523737] scsi0 : ahci
[   40.523832] scsi1 : ahci
[   40.523898] scsi2 : ahci
[   40.523964] scsi3 : ahci
[   40.524053] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0=20
irq 315
[   40.524100] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0=20
irq 315
[   40.524148] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0=20
irq 315
[   40.524195] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0=20
irq 315
[   40.995751] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   40.996374] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   40.996416] ata1.00: 312581808 sectors, multi 16: LBA48
[   40.997049] ata1.00: configured for UDMA/133
[   41.468058] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   41.471873] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   41.471913] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   41.473917] ata2.00: configured for UDMA/133
[   41.790689] ata3: SATA link down (SStatus 0 SControl 300)
[   42.109995] ata4: SATA link down (SStatus 0 SControl 300)
[   42.110084] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ: 0 ANSI: 5
[   42.110194] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   42.110238] sd 0:0:0:0: [sda] Write Protect is off
[   42.110276] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   42.110284] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   42.110354] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   42.110397] sd 0:0:0:0: [sda] Write Protect is off
[   42.110435] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   42.110442] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   42.110492]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   42.140153] sd 0:0:0:0: [sda] Attached SCSI disk
[   42.140289] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10=20
PQ: 0 ANSI: 5
[   42.140398] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   42.140443] sd 1:0:0:0: [sdb] Write Protect is off
[   42.140481] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   42.140489] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   42.140559] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[   42.140602] sd 1:0:0:0: [sdb] Write Protect is off
[   42.140639] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   42.140647] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   42.140696]  sdb: sdb1 sdb2
[   42.167607] sd 1:0:0:0: [sdb] Attached SCSI disk

=46ull dmesgs attached.

Gl=FCck Auf
Volker

--Boundary-00=_mZM4HjSQaeFVPKY
Content-Type: text/plain;
  charset="iso-8859-15";
  name="dmesg_2.6.24.3reiser4ahci_no_srst_coldboot"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.24.3reiser4ahci_no_srst_coldboot"

[    0.000000] Linux version 2.6.24.3reiser4ahci_no_srst (root@energy) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Wed Mar 19 07:57:35 CET 2008
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
[   36.691985] Marking TSC unstable due to TSCs unsynchronized
[   36.691986] time.c: Detected 3013.887 MHz processor.
[   36.695815] Console: colour VGA+ 80x25
[   36.695817] console [tty6] enabled
[   36.700423] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[   36.702652] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   36.703423] Checking aperture...
[   36.703461] CPU 0: aperture @ ecc8000000 size 32 MB
[   36.703499] Aperture too small (32 MB)
[   36.709379] No AGP bridge found
[   36.709415] Your BIOS doesn't leave a aperture memory hole
[   36.709453] Please enable the IOMMU option in the BIOS setup
[   36.709491] This costs you 64 MB of RAM
[   36.734719] Mapping aperture over 65536 KB of RAM @ 8000000
[   36.758840] Memory: 4049948k/4980736k available (2192k kernel code, 143428k reserved, 681k data, 176k init)
[   36.758909] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   36.841634] Calibrating delay using timer specific routine.. 6034.68 BogoMIPS (lpj=10053897)
[   36.841727] Mount-cache hash table entries: 256
[   36.841834] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   36.841873] CPU: L2 Cache: 1024K (64 bytes/line)
[   36.841912] CPU: Physical Processor ID: 0
[   36.841948] CPU: Processor Core ID: 0
[   36.842001] SMP alternatives: switching to UP code
[   36.842364] ACPI: Core revision 20070126
[   36.877541] Using local APIC timer interrupts.
[   36.910685] APIC timer calibration result 12557870
[   36.910686] Detected 12.557 MHz APIC timer.
[   36.910772] SMP alternatives: switching to SMP code
[   36.911002] Booting processor 1/2 APIC 0x1
[   36.921189] Initializing CPU#1
[   37.003951] Calibrating delay using timer specific routine.. 6030.92 BogoMIPS (lpj=10046282)
[   37.003956] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   37.003957] CPU: L2 Cache: 1024K (64 bytes/line)
[   37.003959] CPU: Physical Processor ID: 0
[   37.003960] CPU: Processor Core ID: 1
[   37.004041] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   37.004029] Brought up 2 CPUs
[   37.004487] net_namespace: 120 bytes
[   37.004718] NET: Registered protocol family 16
[   37.004831] ACPI: bus type pci registered
[   37.004913] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   37.004952] PCI: Not using MMCONFIG.
[   37.004989] PCI: Using configuration type 1
[   37.007230] ACPI: EC: Look up EC in DSDT
[   37.010681] ACPI: Interpreter enabled
[   37.010719] ACPI: (supports S0 S1 S3 S4 S5)
[   37.010888] ACPI: Using IOAPIC for interrupt routing
[   37.011098] Error attaching device data
[   37.011137] Error attaching device data
[   37.011176] Error attaching device data
[   37.011214] Error attaching device data
[   37.016127] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   37.016652] PCI: Transparent bridge - 0000:00:08.0
[   37.016946] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   37.017078] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   37.017175] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   37.017230] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   37.017285] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   37.017340] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   37.021278] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[   37.021614] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[   37.021948] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[   37.022309] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[   37.022668] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[   37.023028] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   37.023362] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[   37.023721] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   37.024058] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   37.024392] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[   37.024752] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   37.025087] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[   37.025447] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
[   37.025807] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   37.026141] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
[   37.026502] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   37.026836] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
[   37.027233] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[   37.027594] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disabled.
[   37.027955] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disabled.
[   37.028273] Linux Plug and Play Support v0.97 (c) Adam Belay
[   37.028326] pnp: PnP ACPI init
[   37.028365] ACPI: bus type pnp registered
[   37.030905] pnp: PnP ACPI: found 13 devices
[   37.030943] ACPI: ACPI bus type pnp unregistered
[   37.031065] SCSI subsystem initialized
[   37.031122] libata version 3.00 loaded.
[   37.031172] usbcore: registered new interface driver usbfs
[   37.031227] usbcore: registered new interface driver hub
[   37.031284] usbcore: registered new device driver usb
[   37.031367] PCI: Using ACPI for IRQ routing
[   37.031405] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   37.040479] PCI-DMA: Disabling AGP.
[   37.041215] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   37.041257] PCI-DMA: using GART IOMMU.
[   37.041296] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   37.041455] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   37.041595] hpet0: 3 32-bit timers, 25000000 Hz
[   37.043764] Time: hpet clocksource has been installed.
[   37.043812] Switched to high resolution mode on CPU 0
[   37.043970] Switched to high resolution mode on CPU 1
[   37.050495] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[   37.050535] system 00:05: ioport range 0x800-0x80f has been reserved
[   37.050575] system 00:05: ioport range 0x2000-0x207f has been reserved
[   37.050614] system 00:05: ioport range 0x2080-0x20ff has been reserved
[   37.054014] system 00:05: ioport range 0x2400-0x247f has been reserved
[   37.054053] system 00:05: ioport range 0x2480-0x24ff has been reserved
[   37.054092] system 00:05: ioport range 0x2800-0x287f has been reserved
[   37.054131] system 00:05: ioport range 0x2880-0x28ff has been reserved
[   37.054171] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[   37.054210] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[   37.054250] system 00:05: iomem range 0x0-0x0 could not be reserved
[   37.054290] system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[   37.054333] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[   37.054381] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[   37.054432] system 00:0a: ioport range 0x290-0x29f has been reserved
[   37.054474] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[   37.054519] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   37.054558] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   37.054601] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   37.054641] system 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
[   37.054688] system 00:0c: iomem range 0xff380000-0xffffffff could not be reserved
[   37.054970] PCI: Bridge: 0000:00:08.0
[   37.055007]   IO window: d000-dfff
[   37.055044]   MEM window: f9f00000-f9ffffff
[   37.055081]   PREFETCH window: disabled.
[   37.055119] PCI: Bridge: 0000:00:0b.0
[   37.055155]   IO window: c000-cfff
[   37.055192]   MEM window: f9e00000-f9efffff
[   37.055229]   PREFETCH window: disabled.
[   37.055266] PCI: Bridge: 0000:00:0c.0
[   37.055302]   IO window: disabled.
[   37.055338]   MEM window: disabled.
[   37.055374]   PREFETCH window: disabled.
[   37.055411] PCI: Bridge: 0000:00:0d.0
[   37.055448]   IO window: e000-efff
[   37.055484]   MEM window: fa000000-febfffff
[   37.055521]   PREFETCH window: d0000000-dfffffff
[   37.055559] PCI: Bridge: 0000:00:0e.0
[   37.055595]   IO window: disabled.
[   37.055631]   MEM window: disabled.
[   37.055668]   PREFETCH window: disabled.
[   37.055711] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   37.055719] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   37.055724] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   37.055729] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   37.055733] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   37.055739] NET: Registered protocol family 2
[   37.087062] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   37.087659] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[   37.089081] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   37.089567] TCP: Hash tables configured (established 262144 bind 65536)
[   37.089607] TCP reno registered
[   37.097846] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[   37.097949] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[   37.097997] io scheduler noop registered
[   37.098035] io scheduler cfq registered (default)
[   37.098731] Boot video device is 0000:04:00.0
[   37.098833] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   37.098850] assign_interrupt_mode Found MSI capability
[   37.098904] Allocate Port Service[0000:00:0b.0:pcie00]
[   37.098946] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   37.098962] assign_interrupt_mode Found MSI capability
[   37.099010] Allocate Port Service[0000:00:0c.0:pcie00]
[   37.099047] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   37.099063] assign_interrupt_mode Found MSI capability
[   37.099111] Allocate Port Service[0000:00:0d.0:pcie00]
[   37.099148] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   37.099164] assign_interrupt_mode Found MSI capability
[   37.099212] Allocate Port Service[0000:00:0e.0:pcie00]
[   37.099387] input: Power Button (FF) as /class/input/input0
[   37.099425] ACPI: Power Button (FF) [PWRF]
[   37.099510] input: Power Button (CM) as /class/input/input1
[   37.099549] ACPI: Power Button (CM) [PWRB]
[   37.099683] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
[   37.099788] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
[   37.123685] Real Time Clock Driver v1.12ac
[   37.123804] hpet_resources: 0xfed00000 is busy
[   37.123821] Linux agpgart interface v0.102
[   37.123907] Driver 'sd' needs updating - please use bus_type methods
[   37.123980] ahci 0000:00:0a.0: version 3.0
[   37.124155] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   37.124199] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[   37.124533] ahci 0000:00:0a.0: controller can't do PMP, turning off CAP_PMP
[   38.124731] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl IDE mode
[   38.124780] ahci 0000:00:0a.0: flags: 64bit sntf led clo pio 
[   38.124819] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   38.125020] scsi0 : ahci
[   38.125116] scsi1 : ahci
[   38.125182] scsi2 : ahci
[   38.125248] scsi3 : ahci
[   38.125337] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 irq 315
[   38.125384] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 irq 315
[   38.125432] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 irq 315
[   38.125479] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 irq 315
[   38.597035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   38.597732] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   38.597775] ata1.00: 312581808 sectors, multi 16: LBA48 
[   38.598405] ata1.00: configured for UDMA/133
[   39.069342] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   39.084225] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   39.084264] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   39.086268] ata2.00: configured for UDMA/133
[   39.405277] ata3: SATA link down (SStatus 0 SControl 300)
[   39.724583] ata4: SATA link down (SStatus 0 SControl 300)
[   39.724672] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 PQ: 0 ANSI: 5
[   39.724782] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   39.724826] sd 0:0:0:0: [sda] Write Protect is off
[   39.724864] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   39.724872] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   39.724942] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   39.724985] sd 0:0:0:0: [sda] Write Protect is off
[   39.725023] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   39.725030] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   39.725079]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   39.763787] sd 0:0:0:0: [sda] Attached SCSI disk
[   39.763923] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[   39.764032] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   39.764077] sd 1:0:0:0: [sdb] Write Protect is off
[   39.764115] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   39.764124] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   39.764194] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   39.764237] sd 1:0:0:0: [sdb] Write Protect is off
[   39.764275] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   39.764283] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   39.764332]  sdb: sdb1 sdb2
[   39.793043] sd 1:0:0:0: [sdb] Attached SCSI disk
[   39.793181] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   39.795761] serio: i8042 KBD port at 0x60,0x64 irq 1
[   39.795800] serio: i8042 AUX port at 0x60,0x64 irq 12
[   39.822033] usbcore: registered new interface driver usbhid
[   39.822072] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   39.822116] TCP cubic registered
[   39.822155] NET: Registered protocol family 1
[   39.822210] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[   39.822187] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   39.822226] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   39.822265] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   39.822303] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   39.822341] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   39.822379] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   39.822417] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   39.822456] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   39.848293] input: AT Translated Set 2 keyboard as /class/input/input2
[   39.942989] ReiserFS: sda3: found reiserfs format "3.6" with standard journal
[   39.943032] ReiserFS: sda3: using ordered data mode
[   39.952565] ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   39.953453] ReiserFS: sda3: checking transaction log (sda3)
[   39.996872] ReiserFS: sda3: Using r5 hash to sort names
[   39.996923] VFS: Mounted root (reiserfs filesystem) readonly.
[   39.996972] Freeing unused kernel memory: 176k freed
[   40.878988] Clocksource tsc unstable (delta = -333079246 ns)
[   42.095345] ReiserFS: sda3: switching to journaled data mode
[   42.226791] r8169 Gigabit Ethernet driver 2.2LK loaded
[   42.226996] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   42.227002] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
[   42.227010] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   42.227158] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, XID 38000000 IRQ 314
[   42.239735] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   42.239745] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
[   42.239894] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   42.239897] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   42.239970] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   42.239992] ehci_hcd 0000:00:02.1: debug port 1
[   42.239994] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   42.240001] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   42.243080] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   42.243150] usb usb1: configuration #1 chosen from 1 choice
[   42.243165] hub 1-0:1.0: USB hub found
[   42.243170] hub 1-0:1.0: 10 ports detected
[   42.352456] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   42.394298] usb 1-3: configuration #1 chosen from 1 choice
[   42.394382] hub 1-3:1.0: USB hub found
[   42.394494] hub 1-3:1.0: 4 ports detected
[   42.398785] reiser4: sdb2: found disk format 4.0.0.
[   42.493443] usb 1-3.1: new low speed USB device using ehci_hcd and address 3
[   42.527871] usb 1-3.1: configuration #1 chosen from 1 choice
[   42.531596] input: Logitech USB Receiver as /class/input/input3
[   42.536888] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   42.539011] input: Logitech USB Receiver as /class/input/input4
[   42.552418] input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   42.561737] mice: PS/2 mouse device common for all mice
[   50.915448] reiser4: sda6: found disk format 4.0.0.
[   51.353992] reiser4: sdb1: found disk format 4.0.0.
[   51.733762] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
[   53.133822] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   53.133828] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 (level, low) -> IRQ 18
[   53.134923] Audigy2 value: Special config.
[   54.973693] w83627ehf: Found W83627EHG chip at 0x290
[   55.827810] r8169: eth0: link up
[   55.827816] r8169: eth0: link up
[   56.557555] NET: Registered protocol family 17

--Boundary-00=_mZM4HjSQaeFVPKY
Content-Type: text/plain;
  charset="iso-8859-15";
  name="dmesg_2.6.24.3reiser4ahci_no_srst_reboot"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.24.3reiser4ahci_no_srst_reboot"

[    0.000000] Linux version 2.6.24.3reiser4ahci_no_srst (root@energy) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Wed Mar 19 07:57:35 CET 2008
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
[   39.090700] Marking TSC unstable due to TSCs unsynchronized
[   39.090702] time.c: Detected 3013.888 MHz processor.
[   39.094534] Console: colour VGA+ 80x25
[   39.094536] console [tty6] enabled
[   39.099146] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[   39.101376] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   39.102148] Checking aperture...
[   39.102186] CPU 0: aperture @ 8000000 size 32 MB
[   39.102223] Aperture too small (32 MB)
[   39.108105] No AGP bridge found
[   39.108140] Your BIOS doesn't leave a aperture memory hole
[   39.108178] Please enable the IOMMU option in the BIOS setup
[   39.108216] This costs you 64 MB of RAM
[   39.133445] Mapping aperture over 65536 KB of RAM @ 8000000
[   39.157576] Memory: 4049948k/4980736k available (2192k kernel code, 143428k reserved, 681k data, 176k init)
[   39.157645] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   39.240351] Calibrating delay using timer specific routine.. 6034.68 BogoMIPS (lpj=10053897)
[   39.240444] Mount-cache hash table entries: 256
[   39.240551] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   39.240591] CPU: L2 Cache: 1024K (64 bytes/line)
[   39.240629] CPU: Physical Processor ID: 0
[   39.240665] CPU: Processor Core ID: 0
[   39.240718] SMP alternatives: switching to UP code
[   39.241081] ACPI: Core revision 20070126
[   39.276257] Using local APIC timer interrupts.
[   39.309401] APIC timer calibration result 12557874
[   39.309402] Detected 12.557 MHz APIC timer.
[   39.309488] SMP alternatives: switching to SMP code
[   39.309718] Booting processor 1/2 APIC 0x1
[   39.319858] Initializing CPU#1
[   39.402621] Calibrating delay using timer specific routine.. 6030.92 BogoMIPS (lpj=10046282)
[   39.402626] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   39.402627] CPU: L2 Cache: 1024K (64 bytes/line)
[   39.402629] CPU: Physical Processor ID: 0
[   39.402630] CPU: Processor Core ID: 1
[   39.402711] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   39.402745] Brought up 2 CPUs
[   39.403204] net_namespace: 120 bytes
[   39.403436] NET: Registered protocol family 16
[   39.403548] ACPI: bus type pci registered
[   39.403630] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   39.403669] PCI: Not using MMCONFIG.
[   39.403705] PCI: Using configuration type 1
[   39.405948] ACPI: EC: Look up EC in DSDT
[   39.409394] ACPI: Interpreter enabled
[   39.409432] ACPI: (supports S0 S1 S3 S4 S5)
[   39.409602] ACPI: Using IOAPIC for interrupt routing
[   39.409811] Error attaching device data
[   39.409850] Error attaching device data
[   39.409889] Error attaching device data
[   39.409928] Error attaching device data
[   39.414841] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   39.415367] PCI: Transparent bridge - 0000:00:08.0
[   39.415661] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   39.415792] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   39.415889] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   39.415944] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   39.415999] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   39.416055] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   39.419993] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[   39.420329] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[   39.420664] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[   39.421026] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[   39.421386] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[   39.421746] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   39.422081] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[   39.422441] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   39.422778] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   39.423113] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[   39.423474] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   39.423808] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[   39.424169] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
[   39.424529] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   39.424864] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
[   39.425225] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   39.425560] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
[   39.425958] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[   39.426318] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disabled.
[   39.426679] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disabled.
[   39.426998] Linux Plug and Play Support v0.97 (c) Adam Belay
[   39.427051] pnp: PnP ACPI init
[   39.427090] ACPI: bus type pnp registered
[   39.429629] pnp: PnP ACPI: found 13 devices
[   39.429666] ACPI: ACPI bus type pnp unregistered
[   39.429789] SCSI subsystem initialized
[   39.429845] libata version 3.00 loaded.
[   39.429896] usbcore: registered new interface driver usbfs
[   39.429952] usbcore: registered new interface driver hub
[   39.430009] usbcore: registered new device driver usb
[   39.430092] PCI: Using ACPI for IRQ routing
[   39.430130] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   39.439195] PCI-DMA: Disabling AGP.
[   39.439931] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   39.439973] PCI-DMA: using GART IOMMU.
[   39.440013] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   39.440171] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   39.440311] hpet0: 3 32-bit timers, 25000000 Hz
[   39.442480] Time: hpet clocksource has been installed.
[   39.442528] Switched to high resolution mode on CPU 0
[   39.442640] Switched to high resolution mode on CPU 1
[   39.449212] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[   39.449252] system 00:05: ioport range 0x800-0x80f has been reserved
[   39.449291] system 00:05: ioport range 0x2000-0x207f has been reserved
[   39.449331] system 00:05: ioport range 0x2080-0x20ff has been reserved
[   39.452732] system 00:05: ioport range 0x2400-0x247f has been reserved
[   39.452772] system 00:05: ioport range 0x2480-0x24ff has been reserved
[   39.452811] system 00:05: ioport range 0x2800-0x287f has been reserved
[   39.452850] system 00:05: ioport range 0x2880-0x28ff has been reserved
[   39.452890] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[   39.452929] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[   39.452969] system 00:05: iomem range 0x0-0x0 could not be reserved
[   39.453009] system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[   39.453053] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[   39.453100] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[   39.453151] system 00:0a: ioport range 0x290-0x29f has been reserved
[   39.453193] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[   39.453238] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   39.453278] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   39.453321] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   39.453361] system 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
[   39.453408] system 00:0c: iomem range 0xff380000-0xffffffff could not be reserved
[   39.453690] PCI: Bridge: 0000:00:08.0
[   39.453728]   IO window: d000-dfff
[   39.453765]   MEM window: f9f00000-f9ffffff
[   39.453802]   PREFETCH window: disabled.
[   39.453840] PCI: Bridge: 0000:00:0b.0
[   39.453876]   IO window: c000-cfff
[   39.453913]   MEM window: f9e00000-f9efffff
[   39.453950]   PREFETCH window: disabled.
[   39.453987] PCI: Bridge: 0000:00:0c.0
[   39.454023]   IO window: disabled.
[   39.454060]   MEM window: disabled.
[   39.454096]   PREFETCH window: disabled.
[   39.454133] PCI: Bridge: 0000:00:0d.0
[   39.454170]   IO window: e000-efff
[   39.454206]   MEM window: fa000000-febfffff
[   39.454243]   PREFETCH window: d0000000-dfffffff
[   39.454281] PCI: Bridge: 0000:00:0e.0
[   39.454317]   IO window: disabled.
[   39.454354]   MEM window: disabled.
[   39.454390]   PREFETCH window: disabled.
[   39.454433] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   39.454441] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   39.454446] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   39.454451] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   39.454456] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   39.454462] NET: Registered protocol family 2
[   39.485778] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   39.486375] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[   39.487800] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   39.488284] TCP: Hash tables configured (established 262144 bind 65536)
[   39.488324] TCP reno registered
[   39.496560] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[   39.496664] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[   39.496712] io scheduler noop registered
[   39.496750] io scheduler cfq registered (default)
[   39.497446] Boot video device is 0000:04:00.0
[   39.497548] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   39.497565] assign_interrupt_mode Found MSI capability
[   39.497619] Allocate Port Service[0000:00:0b.0:pcie00]
[   39.497661] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   39.497677] assign_interrupt_mode Found MSI capability
[   39.497725] Allocate Port Service[0000:00:0c.0:pcie00]
[   39.497762] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   39.497778] assign_interrupt_mode Found MSI capability
[   39.497826] Allocate Port Service[0000:00:0d.0:pcie00]
[   39.497864] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   39.497880] assign_interrupt_mode Found MSI capability
[   39.497928] Allocate Port Service[0000:00:0e.0:pcie00]
[   39.498102] input: Power Button (FF) as /class/input/input0
[   39.498141] ACPI: Power Button (FF) [PWRF]
[   39.498226] input: Power Button (CM) as /class/input/input1
[   39.498264] ACPI: Power Button (CM) [PWRB]
[   39.498398] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
[   39.498503] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
[   39.522401] Real Time Clock Driver v1.12ac
[   39.522520] hpet_resources: 0xfed00000 is busy
[   39.522537] Linux agpgart interface v0.102
[   39.522623] Driver 'sd' needs updating - please use bus_type methods
[   39.522696] ahci 0000:00:0a.0: version 3.0
[   39.522871] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   39.522914] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[   39.523247] ahci 0000:00:0a.0: controller can't do PMP, turning off CAP_PMP
[   40.523447] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl IDE mode
[   40.523496] ahci 0000:00:0a.0: flags: 64bit sntf led clo pio 
[   40.523535] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   40.523737] scsi0 : ahci
[   40.523832] scsi1 : ahci
[   40.523898] scsi2 : ahci
[   40.523964] scsi3 : ahci
[   40.524053] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 irq 315
[   40.524100] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 irq 315
[   40.524148] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 irq 315
[   40.524195] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 irq 315
[   40.995751] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   40.996374] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   40.996416] ata1.00: 312581808 sectors, multi 16: LBA48 
[   40.997049] ata1.00: configured for UDMA/133
[   41.468058] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   41.471873] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   41.471913] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   41.473917] ata2.00: configured for UDMA/133
[   41.790689] ata3: SATA link down (SStatus 0 SControl 300)
[   42.109995] ata4: SATA link down (SStatus 0 SControl 300)
[   42.110084] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 PQ: 0 ANSI: 5
[   42.110194] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   42.110238] sd 0:0:0:0: [sda] Write Protect is off
[   42.110276] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   42.110284] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   42.110354] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[   42.110397] sd 0:0:0:0: [sda] Write Protect is off
[   42.110435] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   42.110442] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   42.110492]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   42.140153] sd 0:0:0:0: [sda] Attached SCSI disk
[   42.140289] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[   42.140398] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   42.140443] sd 1:0:0:0: [sdb] Write Protect is off
[   42.140481] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   42.140489] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   42.140559] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[   42.140602] sd 1:0:0:0: [sdb] Write Protect is off
[   42.140639] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   42.140647] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   42.140696]  sdb: sdb1 sdb2
[   42.167607] sd 1:0:0:0: [sdb] Attached SCSI disk
[   42.167745] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   42.170531] serio: i8042 KBD port at 0x60,0x64 irq 1
[   42.170571] serio: i8042 AUX port at 0x60,0x64 irq 12
[   42.197421] usbcore: registered new interface driver usbhid
[   42.197459] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   42.197504] TCP cubic registered
[   42.197543] NET: Registered protocol family 1
[   42.197597] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[   42.197621] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   42.197660] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   42.197699] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   42.197737] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   42.197775] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   42.197813] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   42.197851] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   42.197890] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   42.224668] input: AT Translated Set 2 keyboard as /class/input/input2
[   42.319352] ReiserFS: sda3: found reiserfs format "3.6" with standard journal
[   42.319395] ReiserFS: sda3: using ordered data mode
[   42.328929] ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   42.329817] ReiserFS: sda3: checking transaction log (sda3)
[   42.373235] ReiserFS: sda3: Using r5 hash to sort names
[   42.373286] VFS: Mounted root (reiserfs filesystem) readonly.
[   42.373335] Freeing unused kernel memory: 176k freed
[   43.277704] Clocksource tsc unstable (delta = -333079178 ns)
[   44.475534] ReiserFS: sda3: switching to journaled data mode
[   44.609715] r8169 Gigabit Ethernet driver 2.2LK loaded
[   44.609920] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   44.609925] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
[   44.609934] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   44.610080] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, XID 38000000 IRQ 314
[   44.628294] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   44.628300] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
[   44.628468] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   44.628472] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   44.628547] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   44.628568] ehci_hcd 0000:00:02.1: debug port 1
[   44.628571] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   44.628576] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   44.637353] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   44.637437] usb usb1: configuration #1 chosen from 1 choice
[   44.637453] hub 1-0:1.0: USB hub found
[   44.637459] hub 1-0:1.0: 10 ports detected
[   44.746738] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   44.788570] usb 1-3: configuration #1 chosen from 1 choice
[   44.788654] hub 1-3:1.0: USB hub found
[   44.788766] hub 1-3:1.0: 4 ports detected
[   44.792882] reiser4: sdb2: found disk format 4.0.0.
[   44.887964] usb 1-3.1: new low speed USB device using ehci_hcd and address 3
[   44.922094] usb 1-3.1: configuration #1 chosen from 1 choice
[   44.925824] input: Logitech USB Receiver as /class/input/input3
[   44.932248] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   44.934322] input: Logitech USB Receiver as /class/input/input4
[   44.949978] input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   44.958863] mice: PS/2 mouse device common for all mice
[   53.303908] reiser4: sda6: found disk format 4.0.0.
[   53.750119] reiser4: sdb1: found disk format 4.0.0.
[   54.136067] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
[   55.658007] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   55.658013] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 (level, low) -> IRQ 18
[   55.659102] Audigy2 value: Special config.
[   57.257005] w83627ehf: Found W83627EHG chip at 0x290
[   58.250017] r8169: eth0: link up
[   58.250023] r8169: eth0: link up
[   58.784830] NET: Registered protocol family 17

--Boundary-00=_mZM4HjSQaeFVPKY--
