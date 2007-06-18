Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbXFRIFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbXFRIFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbXFRIFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:05:37 -0400
Received: from smtp-0-1.linuxrulz.org ([64.191.81.102]:52906 "EHLO
	smtp-0-1.linuxrulz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbXFRIFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:05:35 -0400
Message-ID: <46763CB4.9040301@lbsd.net>
Date: Mon, 18 Jun 2007 08:05:08 +0000
From: Nigel Kukard <nkukard@lbsd.net>
User-Agent: Thunderbird 2.0.0.0 (X11/20070421)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA problems
References: <8vX5T-4hg-5@gated-at.bofh.it> <8w0n1-15u-27@gated-at.bofh.it> <467173C4.1050500@lbsd.net> <46717BE2.3000703@garzik.org>
In-Reply-To: <46717BE2.3000703@garzik.org>
X-Enigmail-Version: 0.95.0
OpenPGP: id=27702C4E;
	url=pgpkeys.mit.edu
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig18CA8E540A828F5BC08240F8"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig18CA8E540A828F5BC08240F8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

Ok ... second part of my problem. Where should I look in trying to debug
the below problem...

Regards
Nigel

Jun 18 07:59:56 nigel-m2v kernel: ata2.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x2 frozen
Jun 18 07:59:56 nigel-m2v kernel: ata2.00: cmd
ca/00:08:bf:ab:68/00:00:00:00:00/e8 tag 0 cdb 0x0 data 4096 out
Jun 18 07:59:56 nigel-m2v kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun 18 07:59:56 nigel-m2v kernel: ata2: soft resetting port
Jun 18 07:59:56 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 18 07:59:56 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 18 07:59:56 nigel-m2v kernel: ata2.00: configured for UDMA/133
Jun 18 07:59:56 nigel-m2v kernel: ata2: EH complete
Jun 18 08:00:26 nigel-m2v kernel: rtc: lost 7740 interrupts
Jun 18 08:00:26 nigel-m2v kernel: ata2.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x2 frozen
Jun 18 08:00:26 nigel-m2v kernel: ata2.00: cmd
ca/00:08:bf:ab:68/00:00:00:00:00/e8 tag 0 cdb 0x0 data 4096 out
Jun 18 08:00:26 nigel-m2v kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun 18 08:00:26 nigel-m2v kernel: ata2: soft resetting port
Jun 18 08:00:26 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 18 08:00:27 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 18 08:00:27 nigel-m2v kernel: ata2.00: configured for UDMA/133
Jun 18 08:00:27 nigel-m2v kernel: ata2: EH complete
Jun 18 08:00:57 nigel-m2v kernel: rtc: lost 7741 interrupts
Jun 18 08:00:57 nigel-m2v kernel: ata2.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x2 frozen
Jun 18 08:00:57 nigel-m2v kernel: ata2.00: cmd
ca/00:08:bf:ab:68/00:00:00:00:00/e8 tag 0 cdb 0x0 data 4096 out
Jun 18 08:00:57 nigel-m2v kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun 18 08:00:57 nigel-m2v kernel: ata2: soft resetting port
Jun 18 08:00:57 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 18 08:00:57 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 18 08:00:57 nigel-m2v kernel: ata2.00: configured for UDMA/133
Jun 18 08:00:57 nigel-m2v kernel: ata2: EH complete
Jun 18 08:01:27 nigel-m2v kernel: rtc: lost 7740 interrupts
Jun 18 08:01:27 nigel-m2v kernel: ata2.00: limiting speed to UDMA/100:PIO=
4
Jun 18 08:01:27 nigel-m2v kernel: ata2.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x2 frozen
Jun 18 08:01:27 nigel-m2v kernel: ata2.00: cmd
ca/00:08:bf:ab:68/00:00:00:00:00/e8 tag 0 cdb 0x0 data 4096 out
Jun 18 08:01:27 nigel-m2v kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun 18 08:01:27 nigel-m2v kernel: ata2: soft resetting port
Jun 18 08:01:27 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 18 08:01:27 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 18 08:01:27 nigel-m2v kernel: ata2.00: configured for UDMA/100
Jun 18 08:01:27 nigel-m2v kernel: ata2: EH complete
Jun 18 08:01:57 nigel-m2v kernel: rtc: lost 7740 interrupts
Jun 18 08:01:57 nigel-m2v kernel: ata2.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x2 frozen
Jun 18 08:01:57 nigel-m2v kernel: ata2.00: cmd
ca/00:08:bf:ab:68/00:00:00:00:00/e8 tag 0 cdb 0x0 data 4096 out
Jun 18 08:01:57 nigel-m2v kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun 18 08:01:57 nigel-m2v kernel: ata2: soft resetting port
Jun 18 08:01:57 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 18 08:01:57 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 18 08:01:57 nigel-m2v kernel: ata2.00: configured for UDMA/100
Jun 18 08:01:57 nigel-m2v kernel: ata2: EH complete
Jun 18 08:02:27 nigel-m2v kernel: rtc: lost 7741 interrupts
Jun 18 08:02:27 nigel-m2v kernel: ata2.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x2 frozen
Jun 18 08:02:27 nigel-m2v kernel: ata2.00: cmd
ca/00:08:bf:ab:68/00:00:00:00:00/e8 tag 0 cdb 0x0 data 4096 out
Jun 18 08:02:27 nigel-m2v kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun 18 08:02:27 nigel-m2v kernel: ata2: soft resetting port
Jun 18 08:02:27 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 18 08:02:27 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 18 08:02:28 nigel-m2v kernel: ata2.00: configured for UDMA/100
Jun 18 08:02:28 nigel-m2v kernel: sd 3:0:0:0: SCSI error: return code =3D=

0x08000002
Jun 18 08:02:28 nigel-m2v kernel: sda: Current [descriptor]: sense key=3D=
0xb
Jun 18 08:02:28 nigel-m2v kernel:     ASC=3D0x0 ASCQ=3D0x0
Jun 18 08:02:28 nigel-m2v kernel: Descriptor sense data with sense
descriptors (in hex):
Jun 18 08:02:28 nigel-m2v kernel:         72 0b 00 00 00 00 00 0c 00 0a
80 00 00 00 00 00
Jun 18 08:02:28 nigel-m2v kernel:         00 00 00 00
Jun 18 08:02:28 nigel-m2v kernel: end_request: I/O error, dev sda,
sector 141077439
Jun 18 08:02:28 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 17634672
Jun 18 08:02:28 nigel-m2v kernel: lost page write due to I/O error on sda=
1
Jun 18 08:02:28 nigel-m2v kernel: ata2: EH complete



--------------enig18CA8E540A828F5BC08240F8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGdjy0KoUGSidwLE4RAlPtAJ0TMBh67uQEleU8qyV/p31wadL4pQCgqsvg
0f8rE+WtRQqhZfliCZuKS78=
=koF3
-----END PGP SIGNATURE-----

--------------enig18CA8E540A828F5BC08240F8--
