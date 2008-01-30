Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYA3AQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYA3AQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYA3AQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:16:24 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:42950 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbYA3AQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:16:23 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] linux/types.h: always export 64bit aligned defines
Date: Tue, 29 Jan 2008 19:16:20 -0500
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>
References: <200801260423.21860.vapier@gentoo.org> <20080127213319.01026b19.akpm@linux-foundation.org> <Pine.LNX.4.64.0801292030190.14907@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801292030190.14907@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2312289.to8OfNz048";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801291916.21133.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2312289.to8OfNz048
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 29 January 2008, Jan Engelhardt wrote:
> On Jan 27 2008 21:33, Andrew Morton wrote:
> >On Sat, 26 Jan 2008 04:23:21 -0500 Mike Frysinger <vapier@gentoo.org>=20
wrote:
> >> Some kernel headers exported to userspace rely on these 64bit
> >> aligned defines. However, they are hidden behind
> >> __KERNEL_STRICT_NAMES at the moment which means most of the time,
> >> they're never actually available.
>
> Wrong way.

i'm thinking the right way, i just may not have expressed it completely=20
clearly ...

> They are inside #ifndef __KERNEL_STRICT_NAMES, so=20
> they _are_ available to userspace.

for all practical purposes, they are not.  glibc will define=20
__KERNEL_STRICT_NAMES because (like a sane C lib), it defines all of the=20
basic types that the kernel also defines.
=2Dmike

--nextPart2312289.to8OfNz048
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR5/B1UFjO5/oN/WBAQLDmQ/+J7nUBUsh1R1DqLr4zvFBXlVFDshohYol
ASYir1qR65dz6C7eitE5U5mRO//vgEM4JKu4rajydadrgssn3En1zUophFiJ8obs
N1Ac/l/oRGGLKFWQ6CcwdC5ULbt2JLXTI2w0ymkemrsBn/scHXes5eyyB9xCP/mm
ccKkriXx6HqdJmT9fwRL04tw0XcJOEohiHJ7h7ariYtmAHYFcN/336LJtbraGgTg
gTE+DCVN9DX/ga9LY6tE2gfHl8bQenf5H1xm7K/aSgonguZBtR/liAsz5DQ+3Q7f
ah8Nl0wGe+9tYImN8YHDMRUyqB/kiDOtic+ge7ZFSTgRRUhQ1bCCSniSqNKqOtXI
GECnFCGQPtg+d88Z8QkrXdR6kfRQDqvmR8GhVASI1U0wv9TfRR/PJeAbjZn5KvuV
S8kFhjUV9G9Dg9NtZTlbuheqUucqS9/DOU3FuWTWwR0oTjT43sGRaXsUAz8piJNw
99L2Uje7xETGkIGdXsanyHWxPxvDhDhIgXUEiC8EHKJqbo5pXr2/KBTOF3Z/WzCN
0XOPhZeZe0ONmLifuk5RK3DSfnmHbCVvRVGLz6xDpeEz5IdnAsZMOIYKn2jw/Wlm
gvlaHrrmI7j1ypOSWg1nimNKCcuKDP+Ylwm8wifSWMwPlSs66CBjDcINYWrNlNrs
Y2mMR5jjRfs=
=YuYA
-----END PGP SIGNATURE-----

--nextPart2312289.to8OfNz048--
