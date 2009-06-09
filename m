Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZFIBLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZFIBLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 21:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZFIBLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 21:11:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55581 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZFIBLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 21:11:14 -0400
Date: Tue, 9 Jun 2009 11:11:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: linux-next: manual merge of the vfs tree with the nilfs tree
Message-Id: <20090609111114.2e879a50.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_11_11_14_+1000_FuzmG_qXgXNQWKwD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_11_11_14_+1000_FuzmG_qXgXNQWKwD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflicts in
fs/nilfs2/super.c between commits from the nilfs tree and similar commits
from the vfs tree.

The vfs and nilfs trees have different versions of the following patches:

nilfs2: get rid of sget use for checking if current mount is present
nilfs2: simplify remaining sget() use
nilfs2: correct exclusion control in nilfs_remount function

And the vfs tree has further commits that affect this files as well.

For now, I have used the vfs tree version.  Please sort this out.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Jun_2009_11_11_14_+1000_FuzmG_qXgXNQWKwD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkottrIACgkQjjKRsyhoI8zleQCbBFRDFFhXAAEdaZuTeUrtuHvO
XP0AoKrZyz+Vo1rwNunGSA8vk+6Hg8Sg
=tqwG
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_11_11_14_+1000_FuzmG_qXgXNQWKwD--
