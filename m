Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0CJGhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 01:37:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57094 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab0CJGg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 01:36:58 -0500
Date: Wed, 10 Mar 2010 17:36:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: build warning after merge of the final tree (in Linus'
 tree)
Message-Id: <20100310173650.f0259c95.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Mar_2010_17_36_50_+1100_P6cj2W3vu9U_Olyn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Mar_2010_17_36_50_+1100_P6cj2W3vu9U_Olyn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joel,

After merging the scsi-post-merge tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

fs/ocfs2/xattr.c: In function 'ocfs2_create_empty_xattr_block':
fs/ocfs2/xattr.c:6535: warning: 'meta_ac' is used uninitialized in this fun=
ction

Introduced by commit d3981544d7a4ed276966cdd58fe2f5d6e8a585d9 ("ocfs2:
Set xattr block entries with ocfs2_xa_set()") which is now in Linus'
tree.  (Entered linux-next on March 1, 2010 and Linus' tree on March 4).

I am pretty certain that this warning indicates a bug.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Mar_2010_17_36_50_+1100_P6cj2W3vu9U_Olyn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuXPgIACgkQjjKRsyhoI8xLhwCcDzNrz0DlJALCpmqrrbCz3rzJ
RsYAn3rap4FqFAlCilJU1Yk2mvZD/79k
=Bh7i
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Mar_2010_17_36_50_+1100_P6cj2W3vu9U_Olyn--
