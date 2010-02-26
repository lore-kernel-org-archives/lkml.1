Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935005Ab0BZCF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 21:05:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40419 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934980Ab0BZCFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 21:05:25 -0500
Date: Fri, 26 Feb 2010 13:05:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the infiniband tree with the vfs tree
Message-Id: <20100226130518.94c5a5f8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Feb_2010_13_05_18_+1100_tBKt0T4jD4Jchka8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Feb_2010_13_05_18_+1100_tBKt0T4jD4Jchka8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the infiniband tree got a conflict in
drivers/infiniband/core/uverbs_main.c between commit
ce916e2b935f8b3402da1457ff23b9f9f786c09b ("switch infiniband uverbs to
anon_inodes") from the vfs tree and commit
4169c4a9735d6434c9e39fa81ae5517e3afd4cd8 ("IB/uverbs: Use anon_inodes
instead of private infinibandeventfs") from the infiniband tree.

These two commits purport to do something similar.  Someone should look
at them both and decide which one is right.  For now I have used the
version from the vfs tree - with the addition of the part from the
infiniband tree version that selects ANON_INODES in the Kconfig file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Feb_2010_13_05_18_+1100_tBKt0T4jD4Jchka8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuHLF4ACgkQjjKRsyhoI8zA6QCgrKAd1mAG6FMO3j7BD04JU5aC
fnEAniW23J7Z7Lc2/V2AiBDiv9hfDLTl
=C5Cg
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Feb_2010_13_05_18_+1100_tBKt0T4jD4Jchka8--
