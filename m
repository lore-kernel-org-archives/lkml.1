Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbZFWAgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbZFWAgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZFWAgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:36:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50450 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZFWAgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:36:09 -0400
Date: Tue, 23 Jun 2009 10:36:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: origin tree build warning
Message-Id: <20090623103604.9d60b2d8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Jun_2009_10_36_04_+1000_d1BnpUbfX/b4lTX."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Jun_2009_10_36_04_+1000_d1BnpUbfX/b4lTX.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/mfd/ab3100-core.c:563: warning: initialization from incompatible po=
inter type

Introduced by commit 14fa56917d73d823538151b0429d98211fa439c1 ("mfd: add
U300 AB3100 core support").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Jun_2009_10_36_04_+1000_d1BnpUbfX/b4lTX.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpAI3QACgkQjjKRsyhoI8zI7ACgmaDOEX9rNXXC+vVQGwBPaVMq
458An0FWTiU5v9WMBXHsVcKbIn2RMVCC
=sNsS
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Jun_2009_10_36_04_+1000_d1BnpUbfX/b4lTX.--
