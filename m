Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZGHKce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZGHKce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZGHKcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:32:24 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZGHKcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:32:23 -0400
Subject: Re: Possible memory leak in net/wireless/scan.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1247042784.6595.7.camel@pc1117.cambridge.arm.com>
References: <1246986269.9451.105.camel@pc1117.cambridge.arm.com>
	 <1247022413.4755.56.camel@johannes.local>
	 <1247042784.6595.7.camel@pc1117.cambridge.arm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0edu/znVxt1wtd/oxhKY"
Date: Wed, 08 Jul 2009 12:24:46 +0200
Message-Id: <1247048686.4755.57.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0edu/znVxt1wtd/oxhKY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-08 at 09:46 +0100, Catalin Marinas wrote:

> Anyway, I run it from some ARM embedded systems at ~200MHz and 256MB of
> RAM to dual core x86 at 2GHz with 3GB of RAM. I also ran it on quemu in
> the past (but, well, in the embedded world I'm pretty used with
> emulators taking 10 min to boot the kernel).

:)

> But it can slow things down since it tracks every memory allocation and
> it needs to look up the pointer in an rb tree.

It was so slow I gave up after a while. But then my real purpose was
testing something, not waiting for kmemleak, so I guess I just didn't
wait long enough :)

johannes

--=-0edu/znVxt1wtd/oxhKY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKVHPpAAoJEODzc/N7+QmaA9wQAIsrUvltj4gJpYNYGBCwHv2Q
pue1BBe7YgiqoWIMvyRFpZQEo9rhrGm7Ynkpw6LqlA71jr43DpZYeVnLggOzP0An
u28VTtDfFXt4gYEs1XlgTOQBQ6enyudqs1JSxgMFbEmVnK8Ss3FaHb2yiXhu3GDO
85tR+43Bqdl8zxw9I6NVu3X8lTxT2DOZjWh4bw8ysAUor58wW6RBmkKHS0cr1N8j
ufBFWwpdV31LizTBB8nlDBx9mMFgQLVAOwHjefvZxncp247fdnAXxbTKyecd6Jkv
LxFdRD/h2XcEw+RgCuB9uW2dWd9WD7W52fp5toeRoTEwA6+H3Y44caLEpaneWF3N
vvBFY8XXjuaipAoERKKY2sIog5QyO2EmwQOf5BSH2EP6jRz5RlRZcpg67ehBFc/5
XIFq3ehGl1Irvk3t/JKgMUvadDStTosgR2SJ1VYI6MnocKmwANUc7TK0DUQKs3LY
Gh3NjH/D09wsQAmC+tmf1FMkZrQLuLKe1iAQsHPjaZPejnrEDkIN4X1xgT3gVukb
YHdvq6EWRxGvyD4zuz+NG76NZVU5DiO7jU4HL/+SWxmLwIo3ZnNauyof4iKkl1tn
FfYx+XpUWPH3psHUEbIaQ1foUOqnOv9HyntSew9jlTHBDMfFoUCJAh+wdpMgwKgI
lvRwTlPsfh8exgx0iFbz
=tnro
-----END PGP SIGNATURE-----

--=-0edu/znVxt1wtd/oxhKY--

