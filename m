Return-Path: <linux-kernel-owner+w=401wt.eu-S1750808AbXBSJsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750808AbXBSJsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 04:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXBSJsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 04:48:40 -0500
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:51375 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbXBSJsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 04:48:39 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen with pata_amd
Date: Mon, 19 Feb 2007 10:48:34 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200702171413.47877.prakash@punnoor.de> <200702171605.29544.prakash@punnoor.de> <200702181644.42594.prakash@punnoor.de>
In-Reply-To: <200702181644.42594.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5923527.335v31aNaX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702191048.35133.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5923527.335v31aNaX
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Sonntag 18 Februar 2007 schrieb Prakash Punnoor:
> Am Samstag 17 Februar 2007 schrieb Prakash Punnoor:
> > Am Samstag 17 Februar 2007 schrieb Prakash Punnoor:
> > > Hi,
> > >
> > > I tried a cat /dev/sdb1 >/dev/null from a Sandisk Extreme III CF card
> > > connected via cf to IDE adapteer to onboard ide of nforce c51. I am
> > > usinf 2.6.20 on x86_64. For a few seconds it worked but then it dropp=
ed
> > > to pio4:
> > >
> > > ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > > ata3.00: (BMDMA stat 0x65)
> > > ata3.00: cmd c8/00:80:1f:7d:01/00:00:00:00:00/e0 tag 0 cdb 0x0 data
> > > 65536 in res 58/00:00:9e:7d:01/00:00:00:00:00/e0 Emask 0x2 (HSM
> > > violation) ata3: soft resetting port
> > > ata3.00: simplex DMA is claimed by other device, disabling DMA
> > > ata3.00: configured for PIO4
> > > ata3: EH complete
> > > SCSI device sdb: 2001888 512-byte hdwr sectors (1025 MB)
> > > sdb: Write Protect is off
> > > sdb: Mode Sense: 00 3a 00 00
> > > SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
> > > support DPO or FUA
>
> [...]
>
> > The ide driver worked better - for a short time and then this happens:
> >
> > hda: dma_intr: status=3D0x58 { DriveReady SeekComplete DataRequest }
> > ide: failed opcode was: unknown
> > hda: DMA disabled
>
> I connected the cf to ide adapter to an ide to sata adapter and using this
> combination on sata_nv makes no troubkes whatsoever. So what goues wrong
> with pata_amd/amd ide driver? BTW, I found specs for the cf card on the
> sandisk website. Perhaps someone wants to check whether the amd drivers
> deal corretcly with the true ide mode implemented in the cf card?
>
> http://www.sandisk.com/Assets/File/OEM/Manuals/ProdManCFlashv11.0.pdf

=46or what it's worth: I tried the cd-ide adapter with the sandisk cf on an=
other=20
machine with ide uli/ali driver and here I don't have any problems as well.=
=20
So everything points to amd driver...

=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart5923527.335v31aNaX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.2 (GNU/Linux)

iD8DBQBF2XJzxU2n/+9+t5gRAugJAJ436ePJnOZlkldFImDytvOLmEzG9wCdF0xH
BckS9TMokR+yHNx5jf40XDU=
=A4IT
-----END PGP SIGNATURE-----

--nextPart5923527.335v31aNaX--
