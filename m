Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbZLPDwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbZLPDwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZLPDwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:52:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54581 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZLPDwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:52:47 -0500
Date: Wed, 16 Dec 2009 14:52:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: origin tree build warning
Message-Id: <20091216145241.0d5ef378.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Dec_2009_14_52_41_+1100_wIq=V.CjyYoWA4h9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Dec_2009_14_52_41_+1100_wIq=V.CjyYoWA4h9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

usr/include/linux/vt.h:89: userspace cannot call function or variable defin=
ed in the kernel

Introduced by commit 5ada918b82399eef3afd6a71e3637697d6bd719f ("vt:
introduce and use vt_kmsg_redirect() function").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Dec_2009_14_52_41_+1100_wIq=V.CjyYoWA4h9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksoWYkACgkQjjKRsyhoI8yahACfSiCgTAi11obOm2PrAdackgI2
fdgAoJeN+uVRJTGSVXfUS+IVFafEAt/b
=QEG3
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Dec_2009_14_52_41_+1100_wIq=V.CjyYoWA4h9--
