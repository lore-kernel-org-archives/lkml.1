Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab0BIFhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 00:37:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35004 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab0BIFha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 00:37:30 -0500
Date: Tue, 9 Feb 2010 16:37:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the fsnotify tree with the vfs tree
Message-Id: <20100209163724.96ae8aa7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Feb_2010_16_37_24_+1100_FwByYcbCvHUEKyZo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Feb_2010_16_37_24_+1100_FwByYcbCvHUEKyZo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the fsnotify tree got a conflict in
include/linux/audit.h between commit
cccc6bba3f771ef29b33e4f79e70ebc3dba245b0 ("Lose the first argument of
audit_inode_child()") from the vfs tree and commit
2df5764e29a813f6ba63be094ab8aadc704a78fd ("fsnotify: use unsigned char *
for dentry->d_name.name") from the fsnotify tree.

The former removed the bits changed by the latter, so I used the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Feb_2010_16_37_24_+1100_FwByYcbCvHUEKyZo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktw9JQACgkQjjKRsyhoI8x+UQCfeLjdCBS09UMtEYAoUv2iy22I
V40AnjcBomV0F/Iyjxw8mF6TtyHrw9ea
=3O3a
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Feb_2010_16_37_24_+1100_FwByYcbCvHUEKyZo--
