Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbXEXNXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbXEXNXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757272AbXEXNXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:23:36 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51493 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012AbXEXNXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:23:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [rfe] easier customization of kconfig for non-Linux projects
Date: Thu, 24 May 2007 09:23:40 -0400
User-Agent: KMail/1.9.6
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       kbuild-devel@lists.sourceforge.net
References: <200705240117.39800.vapier@gentoo.org> <20070524064004.GA28923@uranus.ravnborg.org>
In-Reply-To: <20070524064004.GA28923@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3683074.cRu6THnrNq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705240923.42035.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3683074.cRu6THnrNq
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 24 May 2007, Sam Ravnborg wrote:
> The intent with this is clear but the solution you suggest albeit simple
> does not really match where we could end up with kconfig.
> Recently Roman added support for options in the kconfig language
> and I would assume we could deal with most of this just using options.

that certainly sounds nicer :)

> One example could be to support options for the mainmenu entrye like this:
>
> mainmenu "Busybow config system"
> 	option project=3D"Busybox"
> 	option version=3D"$VERSION"   <=3D Where '$' signify an environment vari=
able

this is doable now ?  if so, i'll test it out in uClibc ...

> In this way we could later distribute kconfig as a binary instead
> of building it into the source as today.

not entirely sure how useful that'd be unless you mean as a completely sep=
=20
package that distributions would include ...
=2Dmike

--nextPart3683074.cRu6THnrNq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARlWR3UFjO5/oN/WBAQLXaw/+NRZkrwK5Qqe7+I6nJrhpvg9/RkE55Ocb
pn2fOT2Z4yLImymOvEVQrAjJfkuzF8rQ7f870GKFqfjc3QJe4QYVNncXDfEAlF71
3Z3/NsjORUFF50TwQb7Baqk738uSQMmSWGzCyBYXsNgPDcoAnv9hdI5q05ilvpzH
XrRJgJt7qaYaJnqjniqRjeZYPbbMCOCKBVSIzKO1XR9Q3b4vuwKum8PTexhOO6Bk
kCPFAjXFuP3BwO0NxvoCfVvINujDolu2Uhk+dA4gZm5cOQZawAfj4y329Zk4uydy
hXnfimNnrTvF0M1j59L72NVSZeFeFomeGL8jaIdSq6EWzGPFtf3VqIA37A/IJmTE
lXmrtqiVDJVhNI6o7mbCKDZmMhfr+eYUVf8Fm/CRjd7rUsYWUdn4U+CxSWxed6f3
5XU7iIblU5lUl0ribf18ThFkTjcPgTNIv2C7KjTFLKJCPqoId2YFCnnOSWNzN7md
SLyqdZ2QSI9vebmP54nW+3Wz6hOY+m5KTyZZ3V3+KFvC+8trZfBqYMv6/JeumU2H
l8M/+9pcyWNvDwPmKJxrQpBN31Xf2Z2SVjpb3Nxo3dvgAYpUl/6cE9nU/BMsGBgC
f8FDmSdFGmAqzj3nquRCqjuxFnO4HmD2hbwJ3Wq7WgTgr+Iqg+Vn8ugio0lgznD9
jkIJhRXDxpU=
=7WQ6
-----END PGP SIGNATURE-----

--nextPart3683074.cRu6THnrNq--
