Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYAZJKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYAZJKT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYAZJJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:09:56 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:53276 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbYAZJJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:09:54 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] drop linux/ufs_fs.h from userspace export
Date: Sat, 26 Jan 2008 04:09:52 -0500
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12136113.VBfNKxVX8p";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801260409.53276.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart12136113.VBfNKxVX8p
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Per previous discussions about cleaning up ufs_fs.h, people just want this
straight up dropped from userspace export.  The only remaining consumer (si=
lo)
has been fixed a while ago to not rely on this header.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
=2D--
 include/linux/Kbuild   |    1 -
 include/linux/ufs_fs.h |    6 ------
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index bd694f7..4076575 100644
=2D-- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -337,7 +337,6 @@ unifdef-y +=3D tty.h
 unifdef-y +=3D types.h
 unifdef-y +=3D udf_fs_i.h
 unifdef-y +=3D udp.h
=2Dunifdef-y +=3D ufs_fs.h
 unifdef-y +=3D uinput.h
 unifdef-y +=3D uio.h
 unifdef-y +=3D unistd.h
diff --git a/include/linux/ufs_fs.h b/include/linux/ufs_fs.h
index 10b854d..46e4a8d 100644
=2D-- a/include/linux/ufs_fs.h
+++ b/include/linux/ufs_fs.h
@@ -35,16 +35,10 @@
 #include <linux/stat.h>
 #include <linux/fs.h>
=20
=2D#ifndef __KERNEL__
=2Dtypedef __u64 __fs64;
=2Dtypedef __u32 __fs32;
=2Dtypedef __u16 __fs16;
=2D#else
 #include <asm/div64.h>
 typedef __u64 __bitwise __fs64;
 typedef __u32 __bitwise __fs32;
 typedef __u16 __bitwise __fs16;
=2D#endif
=20
 #define UFS_BBLOCK 0
 #define UFS_BBSIZE 8192
=2D-=20
1.5.3.8

--nextPart12136113.VBfNKxVX8p
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR5r44UFjO5/oN/WBAQIjdhAA4A8UQUlLyVH157QDlocscIxDOC43bWyb
o/w/XFzj5Ja7f9jOSRggL7Y3MB+HMPAn8jMVs+6WS7mQAaHejdzYf3TPb3tGCw8L
clkHSB9HyE5zx5ZoxiGN71+zCvQoZJ2B5aKpKqti4vWMFGsFyhWZ7EUPPTWi/6OH
Q+XHlLD47+FOno2lrWk/WOeD2wobFAPgILOitEo6rQRknnPJHbRmgI5KNjEm0iiu
nZclj+JCUFkmyzoW19gUohycuCouGBscdIgo4o4kzQdE7/4WpkrC/z1LD/LU4Ez3
1YkNX16Vb+6M+ki+AxvG4hOiOedez4BxxNVMo2GKhNSj1CiLySq3q+gbxaCqBA7d
PG14cwelFOHGxGQNipoidU90aQp28CfhsTJHE/MEySJbVvi9x7LGSkopxOvTweA1
HYXignEs6gWw4Jdt7eKWLJHkrSWsGFB/xY1SjDhB3kG0zndqdMactifNIXkITXtU
GDXba0ZDeUBEoXOK8SLKroddEHBOe8BkrSoYnu7+0K7FooEMg7T/UmauFF0v+RJZ
M9GAfr5we10egc5AwrR/mQGDzKvGOXhRRpLMtBoEdFQH41qvx0pXZFACULQEooiD
fsgd7+7ZEnGs5SnACW+7yaZ2lBXZ4hidNdqyR2PyfPQnjDl5oqkdITYpCavgZbTq
XITLIP5eAB4=
=Bs2y
-----END PGP SIGNATURE-----

--nextPart12136113.VBfNKxVX8p--
