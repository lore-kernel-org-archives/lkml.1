Return-Path: <linux-kernel-owner+w=401wt.eu-S965451AbXBFBec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451AbXBFBec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 20:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965452AbXBFBec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 20:34:32 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:39021 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965451AbXBFBec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 20:34:32 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: geert@linux-m68k.org, zippel@linux-m68k.org, linux-m68k@vger.kernel.org
Date: Mon, 5 Feb 2007 20:34:44 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6358936.qhQqYfGYkC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702052034.45456.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6358936.qhQqYfGYkC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

we don't actually use anything from asm-m68k/page.h in asm-m68k/user.h, so
don't bother including it

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
=2D--
=2D-- a/include/asm-m68k/user.h
+++ b/include/asm-m68k/user.h
@@ -1,8 +1,6 @@
 #ifndef _M68K_USER_H
 #define _M68K_USER_H
=20
=2D#include <asm/page.h>
=2D
 /* Core file format: The core file is written in such a way that gdb
    can understand it and provide useful information to the user (under
    linux we use the 'trad-core' bfd).  There are quite a number of

--nextPart6358936.qhQqYfGYkC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.2 (GNU/Linux)

iQIVAwUARcfbNUFjO5/oN/WBAQKw+A//e8qUYBspuiHfEIhrpSDf20ofW83TKkZM
l1wevku1KY0idp3oHYbRjowa5Ee4PHb62aTucO6aJc60xfqnWe//RtuVWRn0+EjG
qCfILbuqIhW4/w4giQGhIiIo853b+kE8ERnWfWES7Vi6WH3dLuuuHsjg7uIGEfFR
LyWhFIMWmIAYWqlwC2qubUCu8ZvdXnLKyQfkqnkdcBuhjO7Xgz4JCf1zjKydPRqU
YHPoQwtkUeigea8QcCdVTqGq8QnJboBqYUVlH1tcCa+hwq9zG3plwrdCIi1TUDoU
XGOvehRJaJdrymMVI7QJebAOVkPUWjfaW3YVteOi8AqIL82VxA7lApidvCtBIqWF
VOcmP2TbFvU66/kCzFzhfLb+k+S47DxGErmAPIDTo83JaQRO+mhGhxGnXbI4pi9f
F43EuClXdcxWs1spEpTmocblR3OtEzGdMOGUAJA2UWxu7P3Tefg71XFBAxVW59Sc
e5q7R8TnKFVhd7e3rGPVskFVRzB0LbwyA0YPIlWhgNj1OiJmMULQ7xFgdiLaMS0X
rvHXJCW/z1i+IB2bngIl5ZKV38JNKEuse3jrAERELnVjHmlf/tz5vB4f3Q62dvFn
WhStoZR9cRIsQVyWm6ZigackivROp4k1h38u/kmxShgiQiH3t0izHoP7AdWNXgLB
RqmQuRwnHwY=
=OyuX
-----END PGP SIGNATURE-----

--nextPart6358936.qhQqYfGYkC--
