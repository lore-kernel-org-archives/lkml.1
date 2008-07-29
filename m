Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYG2KKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYG2KKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbYG2KKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:10:07 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbYG2KKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:10:05 -0400
Subject: Re: 2.6.27-rc1: zd1211rw association fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
In-Reply-To: <200807291049.47342.alistair@devzero.co.uk> (sfid-20080729_115008_505138_9BF9DEAA)
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
	 <200807291049.47342.alistair@devzero.co.uk>
	 (sfid-20080729_115008_505138_9BF9DEAA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gDkbE49qw4JxY77sVrtp"
Date: Tue, 29 Jul 2008 12:09:55 +0200
Message-Id: <1217326195.10489.10.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gDkbE49qw4JxY77sVrtp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> However, on 2.6.27-rc1 I see the following instead:
>=20
> [   12.120189] firmware: requesting zd1211/zd1211b_ub
> [   12.166388] firmware: requesting zd1211/zd1211b_uphr
> [   12.218877] zd1211rw 4-2:1.0: firmware version 4725
> [   12.258877] zd1211rw 4-2:1.0: zd1211b chip 050d:705c v4810 high 00-17-=
3f AL2230_RF pa0 g--NS
> [   13.097289] wlan0: authenticate with AP 00:17:3f:a4:d6:9d
> [   13.296890] wlan0: authenticate with AP 00:17:3f:a4:d6:9d
> [   13.496890] wlan0: authenticate with AP 00:17:3f:a4:d6:9d
> [   13.696886] wlan0: authentication with AP 00:17:3f:a4:d6:9d timed out
>=20
> And Debian's networking script fails to obtain an IP address. I notice th=
e line:
>=20
> [   18.613540] wlan0: Initial auth_alg=3D0
>=20
> Is missing from the 2.6.27-rc1 dmesg, however my config should not have b=
een
> altered (I simply make oldconfig'ed it). Find attached anyway.
>=20
> I'll start a bisection if nobody has any immediate ideas.

This is about the 100 millionth time this is reported. Please try the
patch I just posted.

johannes

--=-gDkbE49qw4JxY77sVrtp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjuxvAAoJEKVg1VMiehFYTfsQAIijYb1B7JUcbYZ+Wvmut5se
4oa+NEu9E7NlFHDdRoI0OzH6q0THdxLvby1B0Ulxmf6NYIyDzdY+ON30rz8hjrdC
i4j+ZjTf8HVpYgXNJt+aiR305jr954EZQcGO7u4u3/oze6UWDhrtGb9FjryxaL/o
qrSxJTLc4J5Vd3qmY6Co8FaNPhwHzEplzts79qGgV5xHKaBPHyS0iDkXJcKH4miP
YEIzczVT5HQp3e+Rls5dMf50tjGIsFwzvu9ULRR7b9JJzYwRnWCIUwEnJt0vvGVl
zxcbc8M8E56iru4ord+1U+/mHrqYCYDLoemWv/teVryQuZK74Z1a7RtI3s5pmpht
2i4wk8PGZhGEC9p/r9HJ3Y+z3SNqe510qrYpUbm6LoZ1+k/ZhiQktU+q0QnoBpmI
nxgtS3xu4KMcV7JmouapFjhrAMeDGshA+oxiQ8dq6+5t6zgMZPMbClWqFMU7Mwdq
qp2H3D7fhJNINRpfBqFbXMB65hZcl/PPv/IqfGDHFXsJHXs9g7AnwBsiBzdiAuCH
W/4BdNqgbnagmseDQaT4z66mPB+pXMe2CMfzjC/YuTAZ+xBOaEIzSeXkCKJhH6PK
mRNNEEY4HDpzhRiP5pr8pG0AEZv1bKZiNp7J2ub1fdojd9JW6jRexUgxO6wocMmP
/I75EyH5qV3eTJ9zQauR
=D0b7
-----END PGP SIGNATURE-----

--=-gDkbE49qw4JxY77sVrtp--

