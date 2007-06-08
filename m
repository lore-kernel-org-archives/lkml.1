Return-Path: <linux-kernel-owner+w=401wt.eu-S938607AbXFHKVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938607AbXFHKVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937766AbXFHKVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:21:23 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:3166 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937708AbXFHKVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:21:22 -0400
Message-ID: <46692DA0.8090204@imap.cc>
Date: Fri, 08 Jun 2007 12:21:20 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: serio interface
References: <46667A3B.8070708@gmx.de> <20070606091503.GI2649@lug-owl.de> <46667FB9.70206@gmx.de> <20070606095159.GK2649@lug-owl.de> <46682E93.1020602@imap.cc>
In-Reply-To: <46682E93.1020602@imap.cc>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig86AB4B71630D7D1215760D48"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig86AB4B71630D7D1215760D48
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

/me wrote:
> Have a look at drivers/isdn/gigaset/ser-gigaset.c if you like,
> a driver for an ISDN adapter attached via RS232.
>=20
> This is currently implemented as a line discipline, but I consider
> that a hack. [...]
> The serio approach used by input/mouse/sermouse.c might provide a
> more sensible way of driving that kind of device.

Apparently it won't. As I have learned in the meantime, the serio
mechanism in turn just uses a line discipline to actually attach
itself to the serial port. So the line discipline interface
remains "the" way to write a layered driver on top of RS232.

Thanks,

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig86AB4B71630D7D1215760D48
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGaS2gMdB4Whm86/kRArrEAJ4ky3+pqs/i0vk5wtFHdvg3TaP5IgCggpUP
HAlvUAWcpQmZa1tL2pEU63c=
=tb2L
-----END PGP SIGNATURE-----

--------------enig86AB4B71630D7D1215760D48--
