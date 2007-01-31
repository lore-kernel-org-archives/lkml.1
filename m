Return-Path: <linux-kernel-owner+w=401wt.eu-S1030493AbXAaSVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030493AbXAaSVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:21:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030498AbXAaSVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:21:03 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:38328 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030493AbXAaSVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:21:01 -0500
X-Greylist: delayed 2047 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jan 2007 13:21:00 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=S3mUUfUcdd7t8W8gPAK8bYbzzuPKH/Qjd7FONDW8Z1JR15fGCVp2u8Fia99WZw5AN5J8hMK+41+aLJvT8nL5HzDRynRwwoZT0ju2kfKCAxA/ZzCQ1TvsFjdssjrZgNXF;
Message-ID: <45C0D602.70708@simon.arlott.org.uk>
Date: Wed, 31 Jan 2007 17:46:42 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Duncan Sands <duncan.sands@math.u-psud.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cxacru: Poll for device status more frequently.
References: <45BFB841.9030200@simon.arlott.org.uk> <200701311527.39343.duncan.sands@math.u-psud.fr>
In-Reply-To: <200701311527.39343.duncan.sands@math.u-psud.fr>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig4F0DACC85D987B0CC41CEAB2"
Reply-To: Simon Arlott <b3c83437033a245c3e1hcjxk0000jq7l@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4F0DACC85D987B0CC41CEAB2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 31/01/07 14:27, Duncan Sands wrote:
>> The device is only polled for status every 5 seconds yet status update=
s
>> occur as often as every second - when the line is down the status chan=
ges
>> between "down" and "attempting to activate" every 2 seconds. =20
>=20
> How much overhead does polling involve?  [A particularly problematic ca=
se
> is when polling is failing - I've occasionally seen speedtouch modems
> where polling fails every time (not sure why) and for some reason this
> increases system load considerably, which is why the speedtch driver ha=
s
> a dynamic polling interval].  If polling overhead is basically nothing,=

> then this change is OK with me.  Otherwise the next simplest thing to d=
o
> is to have a short polling interval when the line is down, and a longer=

> one when the line is up.
>=20

I've had it polling every 200ms on a dual ppro200 since november, and it =
has never failed to poll the status.


> Ciao,
>=20
> Duncan.


--=20
Simon Arlott


--------------enig4F0DACC85D987B0CC41CEAB2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRcDWBqRtx1WjQ8ihAQrnMQ//c9XB0fwt26FL2FKwpukcpRGYPqZxUyuf
u1pKutHtPU/lJSBh2g9ixI7/JslGXJbaOZBh0XVbMc2VuTDSm0M6dfbjPhSIeFk3
c6HJoTOBacelH91nd2LTSe/4usaeo2Yb9Gk0Wxjnb/lQutIq/Ep2dA2KMLqQ7huH
VeJmKZv5iFwodWjaXWY3Eda6/Fj3uaIYoIsp2kF145YTfGFdndtQfQBRDBGMi7XT
q5IgMk3TIZQVLRnIdepG1qcpyHX7NdANX5U1iP/B1JhhYSakgIQKtsBX9d2jpGiG
C/ocJpA2iN0OqkFEiGKtTJ2MpCwuyCVwJHnce6vxlYFtDUnLONgHsHxUx5RkItrC
t5TAHDFRe6KSkZ3c0LDslfo3KcD5ppnuxy1KRwQnL80wzo2idvgE+jcHZDmkxwzh
VzMQxpOjqCMy87qHblhusP+e21aK4kC1zAODUMDxejXxKHAmhSGzOpfh6v6/PCWo
PTnJvdU7waKmY78gQKjvxwAch9IR0hkmBgynit13LvGwtw2TCI9iMBHb0MnPb1cr
qjPrZJGPYlCpYtjxVynvcWxU6IZsbfvLTh8t6zp9qeM9llOuao/iJ3kqq7vPCb44
mnV5uhi6teYjnBrczhaNuUgHpOG3KGI4g5y9bGoK4esPyoKiOR1pesXlUDXK+wlb
K1p0KEeF2xQ=
=8/eA
-----END PGP SIGNATURE-----

--------------enig4F0DACC85D987B0CC41CEAB2--
