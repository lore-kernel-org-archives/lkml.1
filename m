Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbZGEOEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbZGEOEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 10:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZGEOEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 10:04:10 -0400
Received: from eta-ori.net ([91.121.142.51]:60459 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbZGEOEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 10:04:09 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jul 2009 10:04:09 EDT
Message-ID: <4A50B09B.9030901@impulze.org>
Date: Sun, 05 Jul 2009 15:54:35 +0200
From: Daniel Mierswa <impulze@impulze.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090628)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Parsing kernel parameters and escaping "
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7BCD7DE93CB0F1C9E3A4B334"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7BCD7DE93CB0F1C9E3A4B334
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi list,
I was wondering why " cannot be escaped when parsing kernel parameters
in kernel/params.c. Given a disk label like 'foo " bar' and passing
something to the kernel command line like real_root=3DLABEL=3D"foo \" bar=
"
this would make 'bar' a kernel parameter which is misleading imho. Any
ideas why this path was chosen and how I am supposed to pass such a
parameter that it is considered as one entity?

--=20
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply
know better than you do.
               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22


--------------enig7BCD7DE93CB0F1C9E3A4B334
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkpQsKAACgkQm9l44K3zL5cMYQCeOIqTDcuRSjbrKGqdTObCPSQ9
Q+AAnRlrXcS/na8MgDmRgSs4UjT9kA0P
=tMNE
-----END PGP SIGNATURE-----

--------------enig7BCD7DE93CB0F1C9E3A4B334--
