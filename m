Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbYBJRAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbYBJRAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYBJRAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:00:43 -0500
Received: from h1137427.serverkompetenz.net ([85.214.91.45]:46921 "EHLO
	h1137427.serverkompetenz.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbYBJRAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:00:42 -0500
Subject: Re: pata_cs5536 hangs on boot with hdd attached
From: Gregor Radtke <mail@g-radtke.name>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, Tim Kunschke <beatmeistah@web.de>
In-Reply-To: <yq163x47wsy.fsf@sermon.lab.mkp.net>
References: <1202158828.6229.22.camel@desktop.ein-elch.local>
	 <yq163x47wsy.fsf@sermon.lab.mkp.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mPraXf9Om/qb3anqbxpi"
Date: Sun, 10 Feb 2008 18:00:29 +0100
Message-Id: <1202662829.6418.8.camel@desktop.ein-elch.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mPraXf9Om/qb3anqbxpi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 05.02.2008, 01:16 -0500 schrieb Martin K. Petersen:=20
> Try booting your pata_cs5536 kernel with libata.dma=3D0

hmm.. boots perfectly, of course somewhat slow.
dmesg output:

[   26.728891] Driver 'sd' needs updating - please use bus_type methods
[   26.748371] scsi0 : pata_cs5536
[   26.758052] scsi1 : pata_cs5536
[   26.767672] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00
irq 14
[   26.788551] ata2: DUMMY
[   26.975641] ata1.00: CFA: SanDisk SDCFH-1024, HDX 4.04, max MWDMA2
[   26.994194] ata1.00: 2001888 sectors, multi 0: LBA
[   27.011257] ata1.01: ATA-8: SAMSUNG HM160HC, LQ100-10, max UDMA/100
[   27.030069] ata1.01: 312581808 sectors, multi 0: LBA48
[   27.045774] ata1.01: limited to UDMA/33 due to 40-wire cable
[   27.063457] ata1.00: configured for PIO4
[   27.116887] ata1.01: configured for PIO4
[   27.128995] scsi 0:0:0:0: Direct-Access     ATA      SanDisk SDCFH-10
HDX  PQ: 0 ANSI: 5
[   27.153703] sd 0:0:0:0: [sda] 2001888 512-byte hardware sectors (1025
MB)
[   27.174096] sd 0:0:0:0: [sda] Write Protect is off
[   27.188485] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   27.188561] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   27.216134] sd 0:0:0:0: [sda] 2001888 512-byte hardware sectors (1025
MB)
[   27.236528] sd 0:0:0:0: [sda] Write Protect is off
[   27.250894] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   27.250968] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   27.278351]  sda: sda1
[   27.288400] sd 0:0:0:0: [sda] Attached SCSI removable disk
[   27.305230] scsi 0:0:1:0: Direct-Access     ATA      SAMSUNG HM160HC
LQ10 PQ: 0 ANSI: 5
[   27.329903] sd 0:0:1:0: [sdb] 312581808 512-byte hardware sectors
(160042 MB)
[   27.351336] sd 0:0:1:0: [sdb] Write Protect is off
[   27.365720] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   27.365795] sd 0:0:1:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   27.393050] sd 0:0:1:0: [sdb] 312581808 512-byte hardware sectors
(160042 MB)
[   27.414491] sd 0:0:1:0: [sdb] Write Protect is off
[   27.428862] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   27.428935] sd 0:0:1:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   27.456050]  sdb: sdb1 < sdb5 sdb6 sdb7 >
[   28.083349] sd 0:0:1:0: [sdb] Attached SCSI disk

>=20
> I also suggest you try a kernel with pata_amd compiled in instead of
> pata_cs5536.  Slight timings aside there shouldn't be any functional
> difference between the way the two drivers configure things.  But let
> us know how that goes.  And include the diff of the relevant portion
> of the boot logs.

that works, too, and even better than pata_cs5536 with libata.dma=3D0 -
because dma works :)

dmesg output:
[   14.365798] Driver 'sd' needs updating - please use bus_type methods
[   14.385071] pata_amd 0000:00:0f.2: version 0.3.10
[   14.385352] scsi0 : pata_amd
[   14.394242] scsi1 : pata_amd
[   14.403081] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00
irq 14
[   14.423967] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08
irq 15
[   14.619249] ata1.00: CFA: SanDisk SDCFH-1024, HDX 4.04, max MWDMA2
[   14.637795] ata1.00: 2001888 sectors, multi 0: LBA
[   14.654317] ata1.01: ATA-8: SAMSUNG HM160HC, LQ100-10, max UDMA/100
[   14.673119] ata1.01: 312581808 sectors, multi 0: LBA48
[   14.688830] ata1.01: limited to UDMA/33 due to 40-wire cable
[   14.706587] ata1.00: configured for MWDMA2
[   14.760432] ata1.01: configured for UDMA/33
[   14.773092] ata2: port disabled. ignoring.
[   14.773427] scsi 0:0:0:0: Direct-Access     ATA      SanDisk SDCFH-10
HDX  PQ: 0 ANSI: 5
[   14.798135] sd 0:0:0:0: [sda] 2001888 512-byte hardware sectors (1025
MB)
[   14.818530] sd 0:0:0:0: [sda] Write Protect is off
[   14.832914] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   14.832990] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   14.860562] sd 0:0:0:0: [sda] 2001888 512-byte hardware sectors (1025
MB)
[   14.880958] sd 0:0:0:0: [sda] Write Protect is off
[   14.895327] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   14.895400] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   14.922781]  sda: sda1
[   14.931057] sd 0:0:0:0: [sda] Attached SCSI removable disk
[   14.947893] scsi 0:0:1:0: Direct-Access     ATA      SAMSUNG HM160HC
LQ10 PQ: 0 ANSI: 5
[   14.972560] sd 0:0:1:0: [sdb] 312581808 512-byte hardware sectors
(160042 MB)
[   14.993998] sd 0:0:1:0: [sdb] Write Protect is off
[   15.008384] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   15.008459] sd 0:0:1:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   15.035725] sd 0:0:1:0: [sdb] 312581808 512-byte hardware sectors
(160042 MB)
[   15.057154] sd 0:0:1:0: [sdb] Write Protect is off
[   15.071527] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   15.071599] sd 0:0:1:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   15.098715]  sdb: sdb1 < sdb5 sdb6 sdb7 >
[   15.717582] sd 0:0:1:0: [sdb] Attached SCSI disk

>=20
> Finally - which drive is it?
>=20

tested with two different drives:
Hitachi Travelstar IC25N060ATMR04-0
and
SAMSUNG HM160HC

--=20
Jabber: elch@ein-elch.de        PGP: 0x63FC728D
Tel: 0170/238 30 53    http://www.g-radtke.name


--=-mPraXf9Om/qb3anqbxpi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHry2ti3HX/2P8co0RAqdfAJ9zReCqKuDJKovwMu35onI+gn/qeQCeOfFT
kmstXQACny2YGK6N/g+VrdY=
=cAuC
-----END PGP SIGNATURE-----

--=-mPraXf9Om/qb3anqbxpi--

