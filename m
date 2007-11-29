Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbXK2ADb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbXK2ADb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758325AbXK2ADW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:03:22 -0500
Received: from mail.anarazel.de ([217.115.131.40]:55348 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758280AbXK2ADV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:03:21 -0500
From: Andres Freund <andres@anarazel.de>
To: Roland McGrath <roland@redhat.com>
Subject: Re: "hwcap 0 nosegneg" doesnt work with paravirt_ops xen as of 2.6.23.9
Date: Thu, 29 Nov 2007 01:03:03 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
References: <200711281829.25532.andres@anarazel.de> <474DAF78.8040300@goop.org> <20071128224359.2B5CA26F8E7@magilla.localdomain>
In-Reply-To: <20071128224359.2B5CA26F8E7@magilla.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1284155.bDMNp29YMR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711290103.08324.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1284155.bDMNp29YMR
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Wednesday 28 November 2007, Roland McGrath wrote in "Re: "hwcap 0 nosegn=
eg"=20
doesnt work with paravirt_ops xen as of 2.6.23.9":
> > > /etc/ld.so.conf.d/xen.conf:
> > > hwcap 0 nosegneg
> >
> > This looks OK. [...]
>
> No, it does not match this:
> 	/* Bit used for the pseudo-hwcap for non-negative segments.  We use
> 	   bit 1 to avoid bugs in some versions of glibc when bit 0 is
> 	   used; the choice is otherwise arbitrary. */
> 	#define VDSO_NOTE_NONEGSEG_BIT	1
> You really want "hwcap 1 nosegneg" given that.
> Yes, we've been over this several times already.
Thanks for the information. I guess it would be nice to document this=20
somewhere (except in code)... At least I could not find any information abo=
ut=20
it beside some patch (Not directed at you, Roland). Any idea where?

Besides, it has one Problem: It is not backwards compatible. Using it on=20
earlier Xen Versions yields the normal tls versions (xen 3.1). Isnt the=20
userbase of existing xen installations bigger than the one of some point in=
=20
=46C5 test releases?
Ugh. Leaning a bit far out of the door with that one considering my knowled=
ge=20
about it... Sorry about that.

Greetings,

Andres

--nextPart1284155.bDMNp29YMR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHTgG8porPraT14igRAtGtAJwNh810eYXl/q46UHeTgqQ+XfcoHQCgmV0N
UNb+hASovRIA8OfZBTnHr2o=
=/zpC
-----END PGP SIGNATURE-----

--nextPart1284155.bDMNp29YMR--
