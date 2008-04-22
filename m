Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbYDVAb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbYDVAb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759668AbYDVAbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:31:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44189 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759576AbYDVAbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:31:18 -0400
Date: Tue, 22 Apr 2008 10:31:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Philipp Zabel <philipp.zabel@gmail.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: Linus' tree build breakage
Message-Id: <20080422103111.e1d38371.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta2 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Apr_2008_10_31_11_+1000_k1f/6PbVyBJ_AFsR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2008_10_31_11_+1000_k1f/6PbVyBJ_AFsR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/mfd/htc-pasic3.c:22:31: error: asm/arch/pxa-regs.h: No such file or=
 directory

I have reverted commit 5dc3339aa5ba29593ea57814049ddca8c12831c8 ("[ARM]
4964/1: htc-pasic3: MFD driver for PASIC3 LED control + DS1WM chip") as
the easiest thing.

Russell, this is why I would have liked you to participate in the
linux-next tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Apr_2008_10_31_11_+1000_k1f/6PbVyBJ_AFsR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIDTHUTgG2atn1QN8RAr45AJ9QbFfEWZOA3FXuQrAB0ZBPN2TUeACdF8Y+
deSgWEOdKCaW8wD3FXoZoiI=
=BqUK
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2008_10_31_11_+1000_k1f/6PbVyBJ_AFsR--
