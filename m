Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0BAAHU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 19:07:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53242 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab0BAAHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:07:18 -0500
Date: Mon, 1 Feb 2010 11:07:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>
Subject: linux-next: crypto-current tree build warning
Message-Id: <20100201110709.9de06b42.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Feb_2010_11_07_09_+1100_Q4.BPQ=nUB.g.ZSU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Feb_2010_11_07_09_+1100_Q4.BPQ=nUB.g.ZSU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/char/random.c: In function 'random_write':
drivers/char/random.c:1104: warning: unused variable 'inode'

Introduced by commit b9b06a1fda275559492f8b083927fde4cec641dc ("random:
drop weird m_time/a_time manipulation") which removed the last usage of
"inode".
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Feb_2010_11_07_09_+1100_Q4.BPQ=nUB.g.ZSU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktmGy0ACgkQjjKRsyhoI8wm/gCgohOcjPKAcx0E6tWEKbnwHoDv
Z7UAn2cJAzV7q6VLsknyZvJx/0rznJSS
=suIe
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Feb_2010_11_07_09_+1100_Q4.BPQ=nUB.g.ZSU--
