Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0CDEqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 23:46:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35137 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab0CDEqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 23:46:33 -0500
Date: Thu, 4 Mar 2010 15:46:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: linux-next: manual merge of the fsnotify tree with the vfs tree
Message-Id: <20100304154625.f152123e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Mar_2010_15_46_25_+1100_sPX3l7Lbk8vOvRxE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Mar_2010_15_46_25_+1100_sPX3l7Lbk8vOvRxE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the fsnotify tree got a conflict in
include/linux/fsnotify.h between commit
cccc6bba3f771ef29b33e4f79e70ebc3dba245b0 ("Lose the first argument of
audit_inode_child()") from the vfs tree and commits
a65c9effb4c7b86d032b5188ddbd0e2e583cb81b ("inotify: remove inotify in
kernel interface"), 76864b426a99a3d08aa53e554ddc748ac49ca633 ("Lose the
first argument of audit_inode_child()") and
7278f4df3bfbc7934fc590d8a5707d3a8ee3d866 ("fsnotify: use unsigned char *
for dentry->d_name.name") from the fsnotify tree.

This has come about partly because, when you rebased and linearized your
tree, you included inline the two patches from Al that he had put in a
separate branch for you to merge.  You should have just remerged Al's
for-fsnotify branch at the appropriate place in your tree.

I fixed it up (again) and can carry this for a while.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Mar_2010_15_46_25_+1100_sPX3l7Lbk8vOvRxE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuPOyEACgkQjjKRsyhoI8zuiACfUm4IbiN8PjeXKGwlTWKLc0t5
GK8An1g9u9G2JzKMAQptXP8Lu/iQl9U7
=lPVt
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Mar_2010_15_46_25_+1100_sPX3l7Lbk8vOvRxE--
