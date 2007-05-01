Return-Path: <linux-kernel-owner+w=401wt.eu-S1946099AbXEBAAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946099AbXEBAAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946102AbXEBAAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:00:17 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:32939 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946099AbXEBAAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:00:14 -0400
Message-ID: <4637D47D.7040203@freedesktop.org>
Date: Tue, 01 May 2007 16:59:57 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: sparse -Wptr-subtraction-blows: still needed?
References: <4637AC3D.6000008@freedesktop.org> <alpine.LFD.0.98.0705011442320.3808@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705011442320.3808@woody.linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1DDFF69AC76DD886BBFEB42B"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1DDFF69AC76DD886BBFEB42B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Linus Torvalds wrote:
>=20
> On Tue, 1 May 2007, Josh Triplett wrote:
>> Does this still apply?  Do current versions of GCC still have this pro=
blem?
>> If not, can the option and warning go away?
>=20
> Even if current versions of gcc don't triple the build time (and for th=
e=20
> kernel, I suspect it doesn't, because we've tried to clean up our heade=
r=20
> files), the generated _code_ will invariably suck.

"invariably"?

Do you know whether the current version of GCC generates poor code for po=
inter
subtraction?

If so, does anything in particular make this an unfixable problem?

Has anyone reported this poor code generation to the GCC bugzilla?  If so=
, I
can add a reference to the bug in any (hypothetical) documentation for
-Wptr-subtraction-blows.

> So I'd not want to remove the warning.

Regardless of whether it addresses a current GCC issue or not, I have no
problem leaving the warning in if people want it, given that it requires =
an
explicit switch.

- Josh Triplett



--------------enig1DDFF69AC76DD886BBFEB42B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGN9SKGJuZRtD+evsRAgDxAKCSNT7Fxdpx5oe21LTUmkoCXbcMXQCgphQQ
NvlU4NQQIMljommyj/tf03g=
=MH41
-----END PGP SIGNATURE-----

--------------enig1DDFF69AC76DD886BBFEB42B--
