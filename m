Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbYBOTFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbYBOTFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYBOTFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:05:40 -0500
Received: from ozlabs.org ([203.10.76.45]:34684 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbYBOTFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:05:39 -0500
Subject: Re: [PATCH 0/4]: Respun LMB patches.
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Miller <davem@davemloft.net>
Cc: linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080213.170938.34536425.davem@davemloft.net>
References: <20080213.170938.34536425.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-svYch7FbcXZI/kREFLwb"
Date: Sat, 16 Feb 2008 06:05:37 +1100
Message-Id: <1203102337.6699.0.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-svYch7FbcXZI/kREFLwb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-02-13 at 17:09 -0800, David Miller wrote:
> I've taken into consideration the various feedback, and
> ported the bug fix and other LMB patches posted recently
> in an effort to keep the patch churn by others down wrt.
> my moving of these files.
>=20
> 1) Use HAVE_LMB as suggested by Sam.
>=20
> 2) Fix potential build errors wrt. asm/prom.h dependencies.
>=20
>    My algorithm was:
>=20
>    a) If the file only included asm/lmb.h I added an include
>       of both linux/lmb.c and asm/prom.h
>=20
>    b) If the file already includes asm/prom.h, I merely
>       changed the asm/lmb.h to linux/lmb.h

That fixes the build failures I was seeing, ack.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-svYch7FbcXZI/kREFLwb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHteKBdSjSd0sB4dIRAuWnAJ9WCbI5nCAAUYdH3c7oythnwNsy7QCgs/av
PPUO2nf3MQ1dZIa8o1XpTsI=
=E4p/
-----END PGP SIGNATURE-----

--=-svYch7FbcXZI/kREFLwb--

