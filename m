Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYIOQRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYIOQRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 12:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYIOQQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 12:16:50 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57529 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbYIOQQu (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 12:16:50 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: 2.6.27-rc6-mmotm0913 build error - fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221495403_46396P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Sep 2008 12:16:43 -0400
Message-ID: <48256.1221495403@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221495403_46396P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Trying to build 2.6.27-rc6-mmotm0913 dies a horrid death:

  CC      fs/sysfs/dir.o
fs/sysfs/dir.c: In function =E2=80=98sysfs_mv_dir=E2=80=99:
fs/sysfs/dir.c:993: error: implicit declaration of function =E2=80=98__sy=
sfs_get_dentry=E2=80=99
fs/sysfs/dir.c:993: warning: assignment makes pointer from integer withou=
t a cast
make=5B2=5D: *** =5Bfs/sysfs/dir.o=5D Error 1
make=5B1=5D: *** =5Bfs/sysfs=5D Error 2
make: *** =5Bfs=5D Error 2


Diagnosis: Andrew added fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.pa=
tch,
but somebody (Eric? was touching a lot of sysfs) in linux-next.patch adde=
d a
new user in sysfs_mv_dir.

Looks like people need to get on the same page about that patch?



--==_Exmh_1221495403_46396P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIzoprcC3lWbTT17ARAhe1AJ9aMBYb6GJzdq3jGf3BDlXyoST+vQCbBbgq
s1Que5WrYf4O9DxI9UJGVWM=
=7uQ0
-----END PGP SIGNATURE-----

--==_Exmh_1221495403_46396P--
