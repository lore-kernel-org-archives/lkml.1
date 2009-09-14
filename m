Return-Path: <linux-kernel-owner+w=401wt.eu-S1751148AbZINE1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148AbZINE1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 00:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZINE1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 00:27:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35723 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZINE1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 00:27:39 -0400
Date: Mon, 14 Sep 2009 14:27:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ed Cashin <ecashin@coraid.com>
Subject: linux-next: block tree build failure
Message-Id: <20090914142729.beae34fd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Sep_2009_14_27_29_+1000_ggfQ=FqSK8p.8Qu2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Sep_2009_14_27_29_+1000_ggfQ=FqSK8p.8Qu2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/block/aoe/aoeblk.c: In function 'aoeblk_make_request':
drivers/block/aoe/aoeblk.c:175: error: implicit declaration of function 'bi=
o_barrier'

Caused by commit c1db2f19f1302e894fe9db818e08fb03e4a84df9 ("aoe: end
barrier bios with EOPNOTSUPP") interacting with commit
1f98a13f623e0ef666690a18c1250335fc6d7ef1 ("bio: first step in sanitizing
the bio->bi_rw flag testing").

I have used the version of the block tree from next-20090910 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Sep_2009_14_27_29_+1000_ggfQ=FqSK8p.8Qu2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqtxjEACgkQjjKRsyhoI8y8UQCeI50TkSmg2x9Xd91RD/BpPpP9
HnsAn0X5M3TLPYTalnDyWMAOQk2tDz3m
=D5EB
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Sep_2009_14_27_29_+1000_ggfQ=FqSK8p.8Qu2--
