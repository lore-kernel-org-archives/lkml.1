Return-Path: <linux-kernel-owner+w=401wt.eu-S1767455AbXDEXzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767455AbXDEXzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 19:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767454AbXDEXzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 19:55:43 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32936 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767455AbXDEXzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 19:55:41 -0400
Subject: 2.6.21-rc5-mm4 initramfs Make Error
From: Zan Lynx <zlynx@acm.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: kai@germaschewski.name, Sam Larson <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tlzQ86sVzQl7PK69cBdz"
Date: Thu, 05 Apr 2007 23:55:36 +0000
Message-Id: <1175817336.7505.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tlzQ86sVzQl7PK69cBdz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I built a version of 2.6.21-rc5-mm4 with an initramfs and it built OK
the first time.

Then I made changes (applied a Reiser4 patch) and rebuilt, and got the
following error:

zephyr linux # make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
<stdin>:1356:2: warning: #warning syscall getcpu not implemented
<stdin>:1360:2: warning: #warning syscall epoll_pwait not implemented
<stdin>:1364:2: warning: #warning syscall lutimesat not implemented
<stdin>:1380:2: warning: #warning syscall revokeat not implemented
<stdin>:1384:2: warning: #warning syscall frevoke not implemented
  CHK     include/linux/compile.h
/usr/src/linux-2.6.21-rc5-mm4/usr/Makefile:41: *** target pattern contains =
no `%'.  Stop.
make: *** [usr] Error 2

I have this in the config:
CONFIG_INITRAMFS_SOURCE=3D"/initramfs"

/initramfs is the directory where I build my initramfs, which is just a
busybox setup, very simple.

# rm usr/.initramfs_data.*
seems to make it go again.
--=20
Zan Lynx <zlynx@acm.org>

--=-tlzQ86sVzQl7PK69cBdz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGFYx4G8fHaOLTWwgRAjVFAKCUYmgZJFqYLp4ysaTAiLNvb6ld8wCfYTRq
crGMeYlO0mx3Vkinc5x2ROA=
=Qo0U
-----END PGP SIGNATURE-----

--=-tlzQ86sVzQl7PK69cBdz--

