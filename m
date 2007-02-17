Return-Path: <linux-kernel-owner+w=401wt.eu-S965275AbXBQPFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275AbXBQPFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 10:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965284AbXBQPFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 10:05:33 -0500
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:55415 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965275AbXBQPFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 10:05:33 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen with pata_amd
Date: Sat, 17 Feb 2007 16:05:25 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200702171413.47877.prakash@punnoor.de>
In-Reply-To: <200702171413.47877.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1581947.AJWQVqutpK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702171605.29544.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1581947.AJWQVqutpK
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Samstag 17 Februar 2007 schrieb Prakash Punnoor:
> Hi,
>
> I tried a cat /dev/sdb1 >/dev/null from a Sandisk Extreme III CF card
> connected via cf to IDE adapteer to onboard ide of nforce c51. I am usinf
> 2.6.20 on x86_64. For a few seconds it worked but then it dropped to pio4:
>
> ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata3.00: (BMDMA stat 0x65)
> ata3.00: cmd c8/00:80:1f:7d:01/00:00:00:00:00/e0 tag 0 cdb 0x0 data 65536
> in res 58/00:00:9e:7d:01/00:00:00:00:00/e0 Emask 0x2 (HSM violation) ata3:
> soft resetting port
> ata3.00: simplex DMA is claimed by other device, disabling DMA
> ata3.00: configured for PIO4
> ata3: EH complete
> SCSI device sdb: 2001888 512-byte hdwr sectors (1025 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 00 3a 00 00
> SCSI device sdb: write cache: enabled, read cache: enabled, doesn't suppo=
rt
> DPO or FUA
>
>
> While boot I get:
> sata_nv 0000:00:0e.0: version 3.2
> ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
> ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [APSI] -> GSI 22 (level, low)
> -> IRQ 22
> PCI: Setting latency timer of device 0000:00:0e.0 to 64
> ata1: SATA max UDMA/133 cmd 0x9F0 ctl 0xBF2 bmdma 0xE000 irq 22
> ata2: SATA max UDMA/133 cmd 0x970 ctl 0xB72 bmdma 0xE008 irq 22
> scsi0 : sata_nv
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: ATA-7, max UDMA/133, 586114704 sectors: LBA48 NCQ (depth 0/32)
> ata1.00: ata1: dev 0 multi count 1
> ata1.00: configured for UDMA/133
> scsi1 : sata_nv
> ata2: SATA link down (SStatus 0 SControl 300)
> ATA: abnormal status 0x7F on port 0x977
> scsi 0:0:0:0: Direct-Access     ATA      Maxtor 7V300F0   VA11 PQ: 0 ANSI:
> 5 SCSI device sda: 586114704 512-byte hdwr sectors (300091 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't suppo=
rt
> DPO or FUA
> SCSI device sda: 586114704 512-byte hdwr sectors (300091 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't suppo=
rt
> DPO or FUA
>  sda: sda1 sda2 < sda5 sda6 sda7 sda8 > sda3
> sd 0:0:0:0: Attached scsi disk sda
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> pata_amd 0000:00:0d.0: version 0.2.7
> PCI: Setting latency timer of device 0000:00:0d.0 to 64
> ata3: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xF400 irq 14
> ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xF408 irq 15
> scsi2 : pata_amd
> ata3.00: CFA, max MWDMA2, 2001888 sectors: LBA
> ata3.00: ata3: dev 0 multi count 0
> ata3.00: configured for MWDMA2
> scsi3 : pata_amd
> ata4: port disabled. ignoring.
> ata4: reset failed, giving up
> scsi 2:0:0:0: Direct-Access     ATA      SanDisk SDCFX-10 HDX  PQ: 0 ANSI:
> 5 SCSI device sdb: 2001888 512-byte hdwr sectors (1025 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 00 3a 00 00
> SCSI device sdb: write cache: enabled, read cache: enabled, doesn't suppo=
rt
> DPO or FUA
> SCSI device sdb: 2001888 512-byte hdwr sectors (1025 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 00 3a 00 00
> SCSI device sdb: write cache: enabled, read cache: enabled, doesn't suppo=
rt
> DPO or FUA
>  sdb: sdb1
> sd 2:0:0:0: Attached scsi removable disk sdb
> sd 2:0:0:0: Attached scsi generic sg1 type 0

The ide driver worked better - for a short time and then this happens:

hda: dma_intr: status=3D0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
hda: DMA disabled

Any idea?

=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1581947.AJWQVqutpK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.2 (GNU/Linux)

iD8DBQBF1xm5xU2n/+9+t5gRApDjAKDLrnmh9Hlk6xTX73qi9Te+vlhCGACdGwH+
bWCjLPOTvJ/+g/Acgca1K8Y=
=RehK
-----END PGP SIGNATURE-----

--nextPart1581947.AJWQVqutpK--
