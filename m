Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbZJEKAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbZJEKAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758779AbZJEKAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:00:54 -0400
Received: from mail.klingt.org ([86.59.21.178]:53009 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758770AbZJEKAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:00:53 -0400
Message-ID: <4AC9C373.80603@klingt.org>
Date: Mon, 05 Oct 2009 11:59:15 +0200
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Lightning/1.0pre Shredder/3.0pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.31-rc5 regression: hd don't show up
References: <h63737$b2a$1@ger.gmane.org> <4A852BC0.1090404@kernel.org> <4A8559D7.6090405@klingt.org> <4A8774E5.4070609@kernel.org> <4A87D9FC.9070408@klingt.org> <4A96460F.3020600@kernel.org> <4A965E3B.3000808@klingt.org> <4A966F7D.60707@kernel.org> <4A97B9C0.9090003@klingt.org> <4A9B7E1E.8060909@kernel.org> <4A9DAF78.4070703@klingt.org> <4A9DD6D9.50407@kernel.org> <4A9E371A.5040208@klingt.org> <4A9FCD8C.6010107@kernel.org> <4AA18F57.8030107@klingt.org> <4AA1ACF8.7030101@kernel.org> <4AA6C569.9090901@klingt.org> <4AB04B39.7030907@kernel.org> <4AB079FC.6000906@kernel.org> <4AB09562.3010501@klingt.org> <4AB0D34A.2010502@kernel.org> <4ABC44FE.5050904@kernel.org> <4ABC7543.90407@klingt.org> <4ABC7714.2030709@kernel.org> <4ABCADE2.1020300@klingt.org> <4ABCC3DB.1000202@kernel.org> <4AC58D9C.6010306@kernel.org> <4AC5AC0D.9020901@klingt.org> <4AC5C0DF.50706@kernel.org>
In-Reply-To: <4AC5C0DF.50706@kernel.org>
X-Enigmail-Version: 0.96a
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC52925939D52A96C3C919A80"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2b1 (klingt.org [127.0.0.1]); Mon, 05 Oct 2009 11:59:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC52925939D52A96C3C919A80
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>> since i have this kernel running, i didn't see any of these messages,
>> still, my hds always showed up ...
>> not sure, if this is related to your patch or if the buggy behavior,
>> just didn't occur ...
>=20
> Can you please reboot several times and see whether libata probing
> messages show anything interesting?

unfortunately, i didn't see any libata related messages, which could be=20
of interest ...=20
the relevant part looks mostly like this:

[    1.575438] libata version 3.00 loaded.
[    2.000903] ata_piix 0000:00:1f.2: version 2.13
[    2.000916] ata_piix 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) ->=
 IRQ 20
[    2.000978] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    2.001212] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.001255] scsi0 : ata_piix
[    2.001372] scsi1 : ata_piix
[    2.002491] ata1: SATA max UDMA/133 cmd 0xa000 ctl 0x9c00 bmdma 0x9480=
 irq 20
[    2.002555] ata2: SATA max UDMA/133 cmd 0x9880 ctl 0x9800 bmdma 0x9488=
 irq 20
[    2.002628] ata_piix 0000:00:1f.5: PCI INT B -> GSI 20 (level, low) ->=
 IRQ 20
[    2.002691] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    2.002920] ata_piix 0000:00:1f.5: setting latency timer to 64
[    2.002951] scsi2 : ata_piix
[    2.003034] scsi3 : ata_piix
[    2.004126] ata3: SATA max UDMA/133 cmd 0xb000 ctl 0xac00 bmdma 0xa480=
 irq 20
[    2.004188] ata4: SATA max UDMA/133 cmd 0xa880 ctl 0xa800 bmdma 0xa488=
 irq 20
[    2.516133] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.519253] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.536470] ata3.00: ATA-7: SAMSUNG HD753LJ, 1AA01112, max UDMA7
[    2.536536] ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/=
32)
[    2.556453] ata4.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.556528] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/3=
2)
[    2.556843] ata3.00: configured for UDMA/133
[    2.576492] ata4.00: configured for UDMA/133
[    2.856006] ata2.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.856081] ata2.01: SATA link down (SStatus 0 SControl 300)
[    2.856305] ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.856373] ata1.01: SATA link down (SStatus 0 SControl 300)
[    2.856437] ata1.01: link offline, clearing class 3 to NONE
[    2.876344] ata1.00: ATAPI: TSSTcorp CDDVDW SH-S223B, SB01, max UDMA/1=
00
[    2.876716] ata2.00: ATA-7: SAMSUNG HD103UJ, 1AA01118, max UDMA7
[    2.876782] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/=
32)
[    2.896332] ata2.00: configured for UDMA/133
[    2.916132] ata1.00: configured for UDMA/100

not sure, what this means, though ...

tim

--=20
tim@klingt.org
http://tim.klingt.org

Just what the hell is the experimental tradition?
  Morton Feldman


--------------enigC52925939D52A96C3C919A80
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrJw3MACgkQdL+4qsZfVsvrvQCeN+SKBDZWRBYfZIwr3GkkwCbB
UwoAn0BREj8e5pMFA8UMLa8FXWFy/L+d
=1B5+
-----END PGP SIGNATURE-----

--------------enigC52925939D52A96C3C919A80--
