Return-Path: <linux-kernel-owner+w=401wt.eu-S1764360AbXF1QAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764360AbXF1QAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759736AbXF1QAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:00:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2867 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055AbXF1QAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:00:00 -0400
X-Greylist: delayed 1717 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jun 2007 12:00:00 EDT
Date: Thu, 28 Jun 2007 16:31:16 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Harald Arnesen <harald@skogtun.org>, Adrian Bunk <bunk@stusta.de>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm
Message-ID: <20070628153116.GC3650@sirena.org.uk>
Mail-Followup-To: Kyle Moffett <mrmacman_g4@mac.com>,
	Harald Arnesen <harald@skogtun.org>, Adrian Bunk <bunk@stusta.de>,
	LKML Kernel <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, david@lang.hm
References: <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de> <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de> <20070627173240.GR1094@stusta.de> <87ejjwgytd.fsf@basilikum.skogtun.org> <DBDB2ED7-97C8-4002-BF0A-01FF3F5737F4@mac.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Content-Disposition: inline
In-Reply-To: <DBDB2ED7-97C8-4002-BF0A-01FF3F5737F4@mac.com>
X-Cookie: This space intentionally left blank.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 212.50.174.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Userspace compiler support of "long long"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 28, 2007 at 08:11:59AM -0400, Kyle Moffett wrote:

> I can't even find the docs for their "tcc".  Their "tchk" appears to =20

tchk is the same thing pretty much with output disabled.  There's a HTML
copy of the man page here:

  http://www.penguin-soft.com/penguin/man/1/tendracc.html

It's packaged for Debian and therefore Ubuntu and other derived
distributions.

> have a "#pragma longlong type allow" or something, so I'd imagine the =20
> same exists for tcc and would be required to build stuff using kernel =20
> headers.

You just need to specify -Ysystem (or some other API selection option)
when building to get it to accept long long.  Since TenDRA focuses on
strict standards conformance it defaults to something roughly equivalent
to GCC with -std=3Dc89 -pedantic -Werror and requires the user to
explicitly enable support for any other APIs and features they want to
use.

>           On the other hand, their compiler looks so immature that it =20
> does not appear to be worth spending much time worrying about now.  =20
> When somebody shows up with a solution for that compiler then we can =20
> look at it at that time.

The compiler is solid enough but old - it predates C99 and has had no
real development since then beyond updating the system include overrides
to work with newer glibc versions.

--=20
"You grabbed my hand and we fell into it, like a daydream - or a fever."

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUBRoPUQQ2erOLNe+68AQKeuQQAl2iD2PKWAtAh78g6j4+j6Zei/cTBnSd1
kv3+R5/gkuif9EUjRPn9rZuay1OaawrmHCMWr3I5UO9+HPLx+A+MVmhUvaGKrlH/
vLQB2PG6G9+FynMrvvU3PBbtdyRgNSK9NGHdUBgcNn+44B+HINU4pof7/DuHaMYs
GU4v0mpWl/k=
=lRmC
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
