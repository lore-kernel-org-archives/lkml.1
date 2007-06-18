Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbXFRFyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbXFRFyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 01:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbXFRFyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 01:54:36 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42867 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbXFRFyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 01:54:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] make hdrscheck.sh force __asm__ in exported headers
Date: Mon, 18 Jun 2007 01:54:41 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200706171854.24763.vapier@gentoo.org> <200706180117.46809.vapier@gentoo.org> <20070617223436.2125b1a4.akpm@linux-foundation.org>
In-Reply-To: <20070617223436.2125b1a4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1374483.jQPz1P3PbD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706180154.42205.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1374483.jQPz1P3PbD
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 18 June 2007, Andrew Morton wrote:
> Also, your changelog sucks:
>
>   This updates scripts/hdrschecks.sh by grepping for asm() constructs and
>   rejecting them in favor of __asm__() in exported headers.
>
> well OK.  But for what reason?  We can see a lot of pain in this patch but
> no gain.  The changelog should tell us what the benefit is, so we can make
> informed tradeoff decisions.

err, should have included the rationale in previous e-mail ...

we want to audit asm/volatile because both constructs will fail in userland=
=20
builds when GNU extensions are turned off (like -std=3Dc99) ... __asm__ and=
=20
__volatile__ will work in both places.
=2Dmike

--nextPart1374483.jQPz1P3PbD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARnYeIkFjO5/oN/WBAQKHow//e5V/GSDFFMifR4uEnOpQ4FY/9QQrl2kE
vQL70rXkv3yu0OZWQ5ejkrFHZvCH/LrdKwsTqQ6Tlg3t+uBqTHk15jE8IRwboEGg
xo8BFVeq40UaySiNingh6aTSB4dp0KYXeSfZ8+ZEFRO80mfITnIN51cz0pFCVAZS
jVzqHc/vGaxtrlfmL6Pc0TU2dF+T3ejYKFcAGQoU8xNJ8uF4TY74t4/zXlRGMjVW
eBcnuujvJLdK2sNWQ4yxMz/V04N6XiBcYG7yh0xk2FP2poypBhewGdjRqJbeynLc
GNLiKv+IceoVoLBrRsYrlv1QRDsoyvYwieiwhRtRUWENR7JzLcQDeWLrrlexFeR3
P8gbdvlKYmpADAeIDxmIOOLm4/zlorBV3Ivh1KNLPVy/9F7CJD7tqt6x4Zhvwwar
h5OWUhqM7KYwxxu5vDjtJsX0gcFqMnlH9yy8PYsbLBGKQxJCZck2WaH+dsmaWyo1
WTYH72J/zYPLVQuDw3pbq2Z/9SraXAOFWdq+qCoz38Rj2tSQNE8I66uJB+qCvXWA
TXrhWiX36rEf3mRSU9ivFNUNJwKqrPZCE5SiUTOmaqxCwEPX3SpeGIHJF3gxQvVI
cpNVVWtmppelM1mKfPDCEB64B3KVAkD47Ay8eJuPfpb7qmqp81FKr7OkXYMtkdzg
DuS//uU4bp8=
=L6oW
-----END PGP SIGNATURE-----

--nextPart1374483.jQPz1P3PbD--
