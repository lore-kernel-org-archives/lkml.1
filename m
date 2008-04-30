Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYD3Blr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYD3Blr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 21:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYD3Blf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 21:41:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35755 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbYD3Ble (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 21:41:34 -0400
Date: Wed, 30 Apr 2008 11:41:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: upstream build failure: v4l/dvb
Message-Id: <20080430114124.45017177.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Apr_2008_11_41_24_+1000_9=Z2P.X_RP9a4Ahi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Apr_2008_11_41_24_+1000_9=Z2P.X_RP9a4Ahi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (Linus' tree, x86_64 allmodconfig) fails like
this:

ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
ERROR: "tda829x_probe" [drivers/media/video/tuner.ko] undefined!
ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!

Reverting commit 149ef72deeba57078216c9fa678baff392295853 ("Rename common
tuner Kconfig names to use the same") makes the build work again.

Also, note that this commit has no Signed-off-by ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Apr_2008_11_41_24_+1000_9=Z2P.X_RP9a4Ahi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIF85MTgG2atn1QN8RAnOJAJ4wjtcSRHJz0UnjNVrxexvObJlskACfZ5mW
Gs4sjcbcRL+spOznjzeY5/8=
=uj4i
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Apr_2008_11_41_24_+1000_9=Z2P.X_RP9a4Ahi--
