Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbYDNFvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbYDNFvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 01:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYDNFvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 01:51:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55918 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbYDNFvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 01:51:03 -0400
Date: Mon, 14 Apr 2008 15:50:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: ext4 merge conflict
Message-Id: <20080414155051.00af1167.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Apr_2008_15_50_51_+1000_I5nZRmVtYlgjrhxC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Apr_2008_15_50_51_+1000_I5nZRmVtYlgjrhxC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

Today's linux-tree merge of the ext4 tree got a new conflict in
fs/jbd2/revoke.c between commit 1076d17ac70d1bb28fadc6f4bd96977b56897025
("jbd/jbd2 NULL noise") from Linus' tree and
e898f3154d78d1520265aade0992981866d827fb ("jbd2: tidy up revoke cache
initialisation and destruction") from the ext4 tree.  It was simple to
fix up but you should check it anyway.  You could resolve this conflict
yourself by pulling Linus' current tree into yours.

This, of course, is another example of a trivial non-bug fixup that was
merged into Linus' tree after rc7 when it could just as easily been sent
to the subsystem maintainer and waited until 2.6.26.  And, in fact, the
spot that was fixed in Al's patch that caused the conflict has been
removed in the ext4 tree.  Oh, well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Apr_2008_15_50_51_+1000_I5nZRmVtYlgjrhxC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIAvC/TgG2atn1QN8RAlkuAJwPqcmXgita78M9J3jJ372ezFUFMgCeJMIS
bc95VtVFQoFTliM7vfYFIVE=
=2eUk
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Apr_2008_15_50_51_+1000_I5nZRmVtYlgjrhxC--
