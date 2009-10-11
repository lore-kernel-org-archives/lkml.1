Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbZJKWF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbZJKWF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbZJKWFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:05:53 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36759 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbZJKWFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:05:52 -0400
X-Sasl-enc: QHL7d5/8ral1d4THJhwEeOL3g2iCTYk5cDY+kFbVww82 1255298689
Message-ID: <4AD25671.7050303@imap.cc>
Date: Mon, 12 Oct 2009 00:04:33 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Tilman Schmidt <tilman@imap.cc>, Andy Whitcroft <apw@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>, Andy Walls <awalls@radix.net>
Subject: Re: checkpatch is not detecting bad whitespacing when using macros
 on formulas
References: <20091011071911.54347f2b@pedra.chehab.org>	<4AD1BB06.70309@imap.cc> <20091011112624.39830ef9@pedra.chehab.org>
In-Reply-To: <20091011112624.39830ef9@pedra.chehab.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB058E674C08E1479D4F85BED"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB058E674C08E1479D4F85BED
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Mauro Carvalho Chehab schrieb:

> Chapter 3.1 of CodingStyle says:
>=20
> 	Use one space around (on each side of) most binary and ternary operato=
rs,
> 	such as any of these:
>=20
> 	        =3D  +  -  <  >  *  /  %  |  &  ^  <=3D  >=3D  =3D=3D  !=3D  ?=
  :
>=20
> At the above, it should have an space before and after the first divisi=
on
> operator.

Agreed.

> So, we should or fix checkpatch.pl or remove the above rule from
> CodingStyle.

No! There is no need (and indeed no way) for checkpatch.pl and
CodingStyle to agree 100 percent.

It's perfectly fine to ask a patch author to fix coding style
issues even if checkpatch.pl didn't complain about them. I've
yet to read of a patch author retorting that "checkpatch.pl
accepted it so it must be fine".

OTOH it's not fine at all if checkpatch.pl complains about
something that is not in fact forbidden by CodingStyle. It
gives patch authors a really hard time, because the standard
argument on LKML has become "checkpatch.pl complained about it
so it must be bad". Try to argue against that once and you'll
see what I mean.

So checkpatch.pl should strive, about all, not to produce
false positives, ie. not to complain about code that is in
fact fine. False negatives, ie. failing to complain about code
that is in violation of CodingStyle in some way, is much less
serious.

> Note that the patch has other similar troubles, like:
>=20
> +       if (d > RXCLK_RCD+1)
> +                                CX23888_IR_REFCLK_FREQ/1000000);
> +       if (rem >=3D CX23888_IR_REFCLK_FREQ/1000000/2)
> +       clocks =3D CX23888_IR_REFCLK_FREQ/1000000 * (u64) ns; /* millic=
ycles    */
> +       return DIV_ROUND_CLOSEST((n+1) * 100, 16);

Sure. But again, that's no reason to make checkpatch.pl complain
even more. It's enough of a pain as it is.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigB058E674C08E1479D4F85BED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFK0lZ9Q3+did9BuFsRAmKkAJ9ROvyTvQc3ucEvGp9yxSV8gbBDRQCfaU/q
IPxDvZYVxFAGINIE66A0T9E=
=FKK9
-----END PGP SIGNATURE-----

--------------enigB058E674C08E1479D4F85BED--
