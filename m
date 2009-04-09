Return-Path: <linux-kernel-owner+w=401wt.eu-S934813AbZDIPnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934813AbZDIPnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935458AbZDIPmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:42:55 -0400
Received: from nn7.de ([85.214.94.156]:35017 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765729AbZDIPmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:42:51 -0400
Subject: Re: 2.6.29+ ath5k connect disconnect cycles?
From: Soeren Sonnenburg <sonne@debian.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239109208.15015.11.camel@maxim-laptop>
References: <1239008128.32048.211.camel@localhost>
	 <1239109208.15015.11.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4lemCsJaeJZPJJcIYKbP"
Date: Thu, 09 Apr 2009 17:37:33 +0200
Message-Id: <1239291453.8961.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4lemCsJaeJZPJJcIYKbP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 16:00 +0300, Maxim Levitsky wrote:
> On Mon, 2009-04-06 at 10:55 +0200, Soeren Sonnenburg wrote:
> > Dear all,
> >=20
> > does anyone else observer strange connect disconnect cycles with ath5k?
> > I have two different notebooks here one with an AR5414 and one with som=
e
> > 2424 (?) chipset both having the same problems to connect...
> >=20
> > Soeren
>=20
> I use latest -git of wireless-testing, and AR2425.
> Thanks to hard work of ath5k developers, it works better and better.
> Yet phy seems to die when loaded with traffic, but its reset brings is
> back alive. ath5k does a reset every 10 seconds.
>=20
> If you use WPA, then you might have bigger problems, I mean, during the
> period when phy is dead, AP might ask for group rekey, but ath5k won't
> hear this, and continue using old keys. This causes much longer delays,
> and sometimes reconnect cycles you see.

Unfortunately, this happened with a open network. But YMMV as it seems
to work very reliably in other locations (even with WPA)... with both
the 2425 and 5414 chipset.

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-4lemCsJaeJZPJJcIYKbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkneFj0ACgkQ/h9eL9HisW95WgCdEKtFHxOaIkRUODiTYs1f4RfQ
i5wAnRIiFBmeliZcZJIlCs8LWwLI2pbF
=nM4K
-----END PGP SIGNATURE-----

--=-4lemCsJaeJZPJJcIYKbP--
