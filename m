Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbZGHDJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbZGHDJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 23:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbZGHDJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 23:09:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43561 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756942AbZGHDJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 23:09:28 -0400
Date: Wed, 8 Jul 2009 13:09:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: ubi tree build warnings
Message-Id: <20090708130921.a361f6d2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Jul_2009_13_09_21_+1000_GMrqR7ySMmqQLiD+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jul_2009_13_09_21_+1000_GMrqR7ySMmqQLiD+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next build (x86_64 allmodconfig) produced these warnings:

drivers/mtd/ubi/io.c: In function 'nor_erase_prepare':
drivers/mtd/ubi/io.c:484: warning: passing argument 5 of 'ubi->mtd->write' =
from incompatible pointer type
drivers/mtd/ubi/io.c:484: note: expected 'const u_char *' but argument is o=
f type 'uint32_t *'
drivers/mtd/ubi/io.c:486: warning: format '%zd' expects type 'signed size_t=
', but argument 5 has type 'int'
drivers/mtd/ubi/io.c:486: warning: too many arguments for format
drivers/mtd/ubi/io.c:493: warning: passing argument 5 of 'ubi->mtd->write' =
from incompatible pointer type
drivers/mtd/ubi/io.c:493: note: expected 'const u_char *' but argument is o=
f type 'uint32_t *'

Introduced by commit ebf53f421308c2f59c9bcbad4c5c297a0d00199a ("UBI: fix
NOR flash recovery").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__8_Jul_2009_13_09_21_+1000_GMrqR7ySMmqQLiD+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpUDeEACgkQjjKRsyhoI8xcPQCgrdliRS42dKGPQerclHFg4UUK
sSQAnjYO1SSBh/JCypbkNmb+H8HlWcdg
=MO8a
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jul_2009_13_09_21_+1000_GMrqR7ySMmqQLiD+--
