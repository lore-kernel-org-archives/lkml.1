Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbYABNiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbYABNiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYABNhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:37:55 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:35616 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbYABNhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:37:54 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] asm-x86/msr.h: pull in linux/types.h
Date: Wed, 2 Jan 2008 08:37:52 -0500
User-Agent: KMail/1.9.7
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
References: <200801012008.53275.vapier@gentoo.org> <20080102114849.GA25887@elte.hu>
In-Reply-To: <20080102114849.GA25887@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1542628.olPUTayWRp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801020837.53860.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1542628.olPUTayWRp
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 02 January 2008, Ingo Molnar wrote:
> * Mike Frysinger <vapier@gentoo.org> wrote:
> > Forgot to mention this before, but since the msr.h header uses types
> > like __u32, it should pull in linux/types.h.
>
> does not build with the attached config.

sorry, forgot about __ASSEMBLY__ protection.
=2D--
Since the msr.h header uses types like __u32, it should pull in linux/types=
=2Eh.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
=2D--
diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index 664a2fa..80b0270 100644
=2D-- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -3,6 +3,10 @@
=20
 #include <asm/msr-index.h>
=20
+#ifndef __ASSEMBLY__
+# include <linux/types.h>
+#endif
+
 #ifdef __i386__
=20
 #ifdef __KERNEL__

--nextPart1542628.olPUTayWRp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.8 (GNU/Linux)

iQIcBAABAgAGBQJHe5OxAAoJEEFjO5/oN/WBJVkQAKeMw1OPdUBx/0wdkE1qNlHN
I2Y8/YvMl+693bvLym24edLA3xnzz1FYshKjsfGVMMl2AvUXq3ArgCOkWcjnsv9Q
NnMfQ0xLd4fKwh6czKf9RwRfOCKisr0RYNMrXvyciUuxiLwTCn4jz+TENZqPfi3c
X6WuBKz1ga5WbaNqTEuAnb/sDY7OVuFkxB2W7fZmhOBaOCnT14l/wSKJBzT8fjn6
FH3J3oE2BrgbiwzhAkXngG/A+R5x1ORWuZzHBzzyX0evEX4pEkeGU9TDHpdx2LEb
NN3gbii3oGaIpMKhuiEJetxhduNHL5Lf7DYkBW92XUdj2H+49KK/1HmbiURh3YiD
h0LjnakR3/hTgawxzEkfq296bIgESYUlNQSf4etQOshbHTTgfnStkQcQIt7fOaOp
TE1NCSHaW0DYjGZw7BmvpHHcVmKNij3aQtANmI09NEeRvbcVq6Cf6q/09kS6tFs3
HX15ZyW2pQ96ugIwGZH0eVeMPAtm6Kk7EzpB2S56Tdgykb/tJnNOV7HmGg4io3j5
tdP+vLx93foI0Qi5WBtDucvS8PPehc0yLp2deY82vWqHr1aMEUORW67HseaNCSbY
mwQrfnzDieOxWCBGsCYs6viwtQKJC2qfEEnejiF+jszyT54hSekgDaREfHmiBlCX
QOQlwxEJnPUzQolvecLc
=vkhW
-----END PGP SIGNATURE-----

--nextPart1542628.olPUTayWRp--
