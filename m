Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0BTLKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 06:10:52 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:47668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab0BTLKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 06:10:50 -0500
Subject: Re: Firmware versioning best practices II
From: Johannes Berg <johannes@sipsolutions.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Vipin Mehta <Vipin.Mehta@atheros.com>
In-Reply-To: <1266664166.1820.4165.camel@macbook.infradead.org>
References: <43e72e891002191823h3245bc0cn7a8745ae77409aa8@mail.gmail.com>
	 <1266662106.1820.4034.camel@macbook.infradead.org>
	 <1266663639.10357.1.camel@jlt3.sipsolutions.net>
	 <1266664166.1820.4165.camel@macbook.infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-E7U4luxEQwnml8iEygd4"
Date: Sat, 20 Feb 2010 12:10:47 +0100
Message-ID: <1266664247.11514.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E7U4luxEQwnml8iEygd4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-20 at 11:09 +0000, David Woodhouse wrote:
> On Sat, 2010-02-20 at 12:00 +0100, Johannes Berg wrote:
> > That doesn't make much sense anyway. If the firmware filename is
> > foo-$APIVER-$CODEVER every code change would need a corresponding
> driver
> > change. If it is just foo-$APIVER then the $CODEVER can be embedded
> in
> > the firmware file and printed so you know which code you're using,
> but
> > if it doesn't influence the API I don't see why it should be part of
> the
> > filename?=20
>=20
> The idea is that just like with shared libraries, you have a symlink
> from the 'soname' foo-3.fw to the actual file foo-3-1.4.1.fw.

Ah ok. I indeed do that manually with iwlwifi firmware :)

> For shared libraries, it's easy to create those symlinks automatically
> using ldconfig. For firmware that doesn't really work though -- since
> the soname isn't encoded in the file like it is in ELF libraries.

Right. Though I guess we could come up with a unified firmware wrapper
format that the firmware loader can unwrap.

johannes

--=-E7U4luxEQwnml8iEygd4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLf8M0AAoJEODzc/N7+QmauLoP/0L6lG8kspUFiWaem3HdJWPw
3phXdhD1qPV84bKf+5StMUlKqPmUYc2LRCbSzSkEJVsUpSI5TF84RLO3CYOwYAPE
HZmoVFWqrKwkjTatrya9eUDsSQHpjiEOj0pSLVhkEplHytuM38AwStHdjXYVpoZp
JCboYcmfWL+ac1Xgs0fMdfLnoguuN0q/Vql7qHIslv7qz40S+MuEZe6yhrs2fj0G
yYU7alalgEE319A0QJR++Rzs/7hq89/CcvNE0E00S+IgIZT5zKjWqLR/+P1Wcg9v
Cc1rwDXZAJk0GtNkbkZ4m7lAOMyuuq6/SbIeNWLtrzOsgOx2ER6kB+YEBwDUxj3u
jqTeWbDatsbAUtUDzkzR1R9F0WjbQuNrt85XXgEQ0CvrIdTiCvuBZpOUWW1y1DCW
ea/X/1deo5UzK3NAsh4Pvi/p/spVUChxZQTEX1M/h6kOcjf6uiLj4ZWI5U8YqsIQ
t+Kwnl28vPNLsd88bQ7IG02YifcxMF1gILMbhWqTcGJCiuX4IaVjTWi+1n7yEoR/
eIgUlvcpDIgelxtn5QOVcrchm7pDmR6lPi9TkRn1G3CrwBDvixkmlhcWpFT9kacc
uOfyun3HwnHit2VI1Xyat91BmSeDj/JvlKyRAtWlP2Wl+oI0VQVw5gz9gWq0Cr/U
3n1WvTjG0QVvQfZBsRtp
=/wBl
-----END PGP SIGNATURE-----

--=-E7U4luxEQwnml8iEygd4--

