Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbXFILVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbXFILVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 07:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbXFILVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 07:21:31 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:53464 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbXFILVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 07:21:30 -0400
Date: Sat, 9 Jun 2007 13:21:24 +0200
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: libata limiting to UDMA/33 instead of UDMA/100
Message-ID: <20070609132124.247a6646@laptop.hypervisor.org>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_CGICMCo6JjNisIaIVvSC=u0";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_CGICMCo6JjNisIaIVvSC=u0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

After switching an older machine over from the PDC20265 PATA driver to the
libata driver pata_pdc202xx_old my HDDs are now limited to UDMA/33. With the
old driver they were happily running with UDMA/100.

I'm including the relevant kernel output for both cases below.

Cheers,

	- Udo



Linux version 2.6.19 (root@desktop) (gcc version 4.1.2) #2 PREEMPT Tue Apr =
24 00:43:48 CEST 2007
[...]
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx
PDC20265: IDE controller at PCI slot 0000:00:11.0
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKB] -> GSI 10 (level, low) -=
> IRQ 10
PDC20265: chipset revision 2
PDC20265: ROM enabled at 0x40100000
PDC20265: 100% native mode on irq 10
PDC20265: (U)DMA Burst Bit ENABLED Primary PCI Mode Secondary PCI Mode.
    ide0: BM-DMA at 0x8000-0x8007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x8008-0x800f, BIOS settings: hdc:pio, hdd:pio
hda: IBM-DTLA-307030, ATA DISK drive
hdb: IC35L120AVV207-0, ATA DISK drive
ide0 at 0x9400-0x9407,0x9002 on irq 10
VP_IDE: IDE controller at PCI slot 0000:00:04.1
VP_IDE: chipset revision 16
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c686a (rev 22) IDE UDMA66 controller on pci0000:00:04.1
    ide2: BM-DMA at 0xd800-0xd807, BIOS settings: hde:pio, hdf:DMA
    ide3: BM-DMA at 0xd808-0xd80f, BIOS settings: hdg:pio, hdh:pio
hde: IOMEGA ZIP 100 ATAPI, ATAPI FLOPPY drive
hdf: PLEXTOR CD-R PX-W1210A, ATAPI CD/DVD-ROM drive
ide2 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
hda: 60036480 sectors (30738 MB) w/1916KiB Cache, CHS=3D59560/16/63, UDMA(1=
00)
hda: cache flushes not supported
 hda: hda1
hdb: max request size: 128KiB
hdb: 241254720 sectors (123522 MB) w/1821KiB Cache, CHS=3D16383/255/63, UDM=
A(100)
hdb: cache flushes supported
 hdb: hdb1 hdb2 hdb3 < hdb5 hdb6 hdb7 hdb8 hdb9 hdb10 hdb11 >
hdf: ATAPI 32X CD-ROM CD-R/RW drive, 2048kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
hde: No disk in drive
hde: 98304kB, 96/64/32 CHS, 4096 kBps, 512 sector size, 2941 rpm


Linux version 2.6.22-rc4 (root@desktop) (gcc version 4.1.2) #1 PREEMPT Sat =
Jun 9 04:02:34 CEST 2007
[...]
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKB] -> GSI 10 (level, low) -=
> IRQ 10
scsi0 : pata_pdc202xx_old
scsi1 : pata_pdc202xx_old
ata1: PATA max UDMA/100 cmd 0x00019400 ctl 0x00019002 bmdma 0x00018000 irq 0
ata2: PATA max UDMA/100 cmd 0x00018800 ctl 0x00018402 bmdma 0x00018008 irq 0
ata1.00: ata_hpa_resize 1: sectors =3D 60036480, hpa_sectors =3D 60036480
ata1.00: ATA-5: IBM-DTLA-307030, TX4OA5AA, max UDMA/100
ata1.00: 60036480 sectors, multi 16: LBA=20
ata1.01: ata_hpa_resize 1: sectors =3D 241254720, hpa_sectors =3D 241254720
ata1.01: ATA-6: IC35L120AVV207-0, V24OA63A, max UDMA/100
ata1.01: 241254720 sectors, multi 16: LBA48=20
ata1.00: limited to UDMA/33 due to 40-wire cable
ata1.01: limited to UDMA/33 due to 40-wire cable
ata1.00: ata_hpa_resize 1: sectors =3D 60036480, hpa_sectors =3D 60036480
ata1.00: configured for UDMA/33
ata1.01: ata_hpa_resize 1: sectors =3D 241254720, hpa_sectors =3D 241254720
ata1.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      IBM-DTLA-307030  TX4O PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 60036480 512-byte hardware sectors (30739 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] 60036480 512-byte hardware sectors (30739 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:1:0: Direct-Access     ATA      IC35L120AVV207-0 V24O PQ: 0 ANSI: 5
sd 0:0:1:0: [sdb] 241254720 512-byte hardware sectors (123522 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:1:0: [sdb] 241254720 512-byte hardware sectors (123522 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 sdb11 >
sd 0:0:1:0: [sdb] Attached SCSI disk
sd 0:0:1:0: Attached scsi generic sg1 type 0
scsi2 : pata_via
scsi3 : pata_via
ata3: PATA max UDMA/66 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001d800 irq 14
ata4: PATA max UDMA/66 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001d808 irq 15
ata3.00: ATAPI, max PIO2, CDB intr
ata3.01: ATAPI, max MWDMA2
ata3.00: configured for PIO2
ata3.01: configured for MWDMA2
scsi 2:0:0:0: Direct-Access     IOMEGA   ZIP 100          14.A PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] Attached SCSI removable disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 2:0:1:0: CD-ROM            PLEXTOR  CD-R   PX-W1210A 1.10 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:1:0: Attached scsi generic sg3 type 5

--Sig_CGICMCo6JjNisIaIVvSC=u0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGao01nhRzXSM7nSkRAloaAJ9ZJvDcxKBQkOVc6/1pj5j4BgBYNQCeLpuP
e5LUpySgalu7u08TeYNL83Y=
=xpfD
-----END PGP SIGNATURE-----

--Sig_CGICMCo6JjNisIaIVvSC=u0--
