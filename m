Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbYLaWeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbYLaWeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYLaWeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:34:08 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56648 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbYLaWeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:34:07 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] headers_check.pl: disallow extern's
Date: Wed, 31 Dec 2008 17:32:32 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org> <200812311758.04516.arnd@arndb.de>
In-Reply-To: <200812311758.04516.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1578474.HVQtXtH7GF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812311732.40076.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1578474.HVQtXtH7GF
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 31 December 2008 11:58:03 Arnd Bergmann wrote:
> On Saturday 27 December 2008, Mike Frysinger wrote:
> > +sub check_prototypes
> > +{
> > +	if ($line =3D~ m/^\s*extern\b/) {
> > +		printf STDERR "extern's make no sense in userspace\n";
> > +		$ret =3D 1;
> > +	}
> > +}
>
> Unfortunately, this way you can only detect prototypes with an explicit
> 'extern' in them, not the equivalent form with an implicit extern.
>
> Not sure if we can detect the other form reliably from perl.

yes, i already mentioned both of these issues.  that's why i suggested we=20
start adding "extern" to all the headers (or at least the userspace ones).
=2Dmike

--nextPart1578474.HVQtXtH7GF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJW/MIAAoJEEFjO5/oN/WB6GoQAL44anAHDXppKHCvkh9Gh+m4
OLbDiEtKnCJAbx6Ii/A7LhHcK5O6BjE0D4Haj3v90R70fWKZE3W2J3Tl3iWYHVmO
mjFyfDKFVy0X6g8eD6BRQ0YFHEK6lqmwrfXLSYQEkjwgP0eUYgp/U19+PlTzGdeO
RgslQE2jKhVQb+JREwDUTHuWq3X2SLxp9EmK7BF/pY/fQPhP/x7HMLoT6KS4dbHv
EXfyLe4JqwL4Lzg8tzA9oOUrUg3V0reFiS/QPp0N6liMNFk10a8wfuKAwWeDeidq
BuqQTMjzFbgfGqbbecAFrPs+Z77GjTC/FbqpWq6268M8ZDCpdWNeMQU5roJaNaO/
06D9ywhzkDCH5drL2Wa6paDyYMlJqUzPFjhN6V+a3kd8R6OCNHMVsEZmZJLb1MLW
36QlGjGFpURz2PXW4enpPjO100pzvKVBhTux9hYKTYbiALUQi6NOmIaHy7TPrhMc
444oZraCKwo6W1GlTF7Zekx7YZyylrcscXSTn91vJQClJAqlOPYPzHsAxwktWpxy
36ZsP4MNwoBYzEsFJ4ae2XamTpElGlOlQXzRcHmx661UsARJRq3G6F/5fnadnCTL
Lawsck8fQl/NQDbdSBuzqzJOi96eUIenj1fKTz4sWk0LpxCa0w0sGYw6WIG4NGLx
I5OiRlFR39y34GS2XuWa
=elQ3
-----END PGP SIGNATURE-----

--nextPart1578474.HVQtXtH7GF--
