Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZGFXDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZGFXDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbZGFXDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:03:31 -0400
Received: from eta-ori.net ([91.121.142.51]:40763 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbZGFXDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:03:30 -0400
Message-ID: <4A5282B4.8070302@impulze.org>
Date: Tue, 07 Jul 2009 01:03:16 +0200
From: Daniel Mierswa <impulze@impulze.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090628)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC] Re: Parsing kernel parameters and escaping "
References: <4A50B09B.9030901@impulze.org>
In-Reply-To: <4A50B09B.9030901@impulze.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig277FFB2B10D40B0C36C44711"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig277FFB2B10D40B0C36C44711
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

As stated in my last E-Mail in this thread there are currently some
limitations when passing quotes to kernel parameters, I tried to remove
some of those limitations. A git fp is attached.

(from the commit message):
> There was a limitation for kernel parameters with regards to quoting. I=
t
> wasn't possible to escape quotes or use quotes to form space-filled
> values _inside_ parameters. This patch attempts to make that possible,
> kernel parameters are now parsed as follows:
> '"param=3D value"' [param=3D value][]
> 'param=3D" value "" combination "' [param][ value  combination ]
> 'param=3D" \" test"' [param][ " test]
> '"param"=3Danother' [param][another]

Any suggestions welcome. Please be kind, as I'm not too familar with
writing parsers, kernel development and what I may have broke. :-)

--=20
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply
know better than you do.
               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22


--------------enig277FFB2B10D40B0C36C44711
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkpSgroACgkQm9l44K3zL5fkEACdGGwDCvSa+TEAbyNDz65Iw8fF
OGMAn2e+as490wd2styzGJBDHpXc6a6G
=32Ef
-----END PGP SIGNATURE-----

--------------enig277FFB2B10D40B0C36C44711--
