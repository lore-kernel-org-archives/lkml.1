Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbZE0Dkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbZE0Dkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZE0Dko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:40:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40334 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755703AbZE0Dkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:40:43 -0400
Date: Wed, 27 May 2009 13:40:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: mtd tree build failure
Message-Id: <20090527134040.941b38a7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_May_2009_13_40_40_+1000_TQwY8zmJIPAJJXU1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_May_2009_13_40_40_+1000_TQwY8zmJIPAJJXU1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/mtd/maps/dilnetpc.c: In function 'init_dnpc':
drivers/mtd/maps/dilnetpc.c:448: error: 'struct mtd_partition' has no membe=
r named 'mtdp'
drivers/mtd/maps/dilnetpc.c:449: error: 'struct mtd_partition' has no membe=
r named 'mtdp'
drivers/mtd/maps/dilnetpc.c:450: error: 'struct mtd_partition' has no membe=
r named 'mtdp'
drivers/mtd/maps/dilnetpc.c:451: error: 'struct mtd_partition' has no membe=
r named 'mtdp'

Caused by commit b90cf6681f4f6263920616e7ca2fd09130e4143a ("[MTD] Remove
option for add_mtd_partitions() to not register partitions.").  The
comment in that commit even says that it will cause this breakage, so why
hasn't this been fixed?

I have used the mtd tree from next-20090526 for today. =20
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_May_2009_13_40_40_+1000_TQwY8zmJIPAJJXU1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoctjgACgkQjjKRsyhoI8xrhwCeNQcOWe68eD43vFswmRpQv8kc
64EAnAzF3i6fuDFGWD2c5inbD/vRYST5
=DTfa
-----END PGP SIGNATURE-----

--Signature=_Wed__27_May_2009_13_40_40_+1000_TQwY8zmJIPAJJXU1--
