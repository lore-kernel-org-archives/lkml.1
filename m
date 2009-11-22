Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZKVMcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZKVMcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZKVMcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:32:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42993 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946AbZKVMcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:32:17 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Wouter van Heyst <larstiq@larstiq.dyndns.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, 504391@bugs.debian.org,
       Pierre Ossman <pierre@ossman.eu>
In-Reply-To: <20091122114234.GA28590@one.lan>
References: <1257914676.2237.57.camel@localhost>
	 <20091116122329.847916b6.akpm@linux-foundation.org>
	 <1258410709.2792.9.camel@localhost>  <20091122114234.GA28590@one.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-umgxClBDn8WH5ulkxk0h"
Date: Sun, 22 Nov 2009 12:32:16 +0000
Message-ID: <1258893136.3627.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] mmc: add module parameter to set whether cards are
 assumed removable
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-umgxClBDn8WH5ulkxk0h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-11-22 at 12:42 +0100, Wouter van Heyst wrote:
> On Mon, Nov 16, 2009 at 10:31:49PM +0000, Ben Hutchings wrote:
[...]
> > In general, it is not possible to tell whether a card present in an MMC
> > slot after resume is the same that was there before suspend.  So there
> > are two possible behaviours, each of which will cause data loss in some
> > cases:
> >=20
> > CONFIG_MMC_UNSAFE_RESUME=3Dn (default): Cards are assumed to be removed
> > during suspend.  Any filesystem on them must be unmounted before
> > suspend; otherwise, buffered writes will be lost.
> >=20
> > CONFIG_MMC_UNSAFE_RESUME=3Dy: Cards are assumed to remain present durin=
g
> > suspend.  They must not be swapped during suspend; otherwise, buffered
> > writes will be flushed to the wrong card.
> >=20
> > Currently the choice is made at compile time and this allows that to be
> > overridden at module load time.
>=20
> I'm running 2.6.32-rc7 with this patch applied and CONFIG_MMC_UNSAFE_RESU=
ME=3Dy
> That works as desired for my non-removable case. Is it desired that I
> test if 'removable=3D1' will thrash my filesystem?

Please test with CONFIG_MMC_UNSAFE_RESUME=3Dn (which Debian will continue
to use) and removable=3D0.

Ben.

--=20
Ben Hutchings
Unix is many things to many people,
but it's never been everything to anybody.

--=-umgxClBDn8WH5ulkxk0h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUASwkvQ+e/yOyVhhEJAQIkjBAA1MIkomPrdHGBNgfm9DKbSZt7QQgtgMET
anVwwKzmjw9MgJFMOL3L0juAewcyh07W9iMsfb9lwd37H5tczGoFrkKy/bmE+ZP5
R/nEqNogn1fPXDa5kwAbfMDOiKCDMXn0FHLEtK1SxDIPA2iEjIoq0Q2borwqx9np
eqoUIhs92QF3v0Wmoes6y4WQvPGbLQ3iAQNa2Iwg3QmtRWUC6m/3n7LKqYvduaXH
qW5h5vGGhSp8Da1FkuvNSE6izPA5lcNk8SWGhFYgdlGdT9GmQ4qyDaHKz0Fi89rZ
HlNcfXU4l7bhFZfaAiZOEmxsJmkF35fCyis9KCoG/HEf8Bx4MobxFDZgeXQmJAei
HmC7d+7YDfV9Bhw4RYJCeRxevmz+U5CLcnC4d2TCAhezgxPfBzLgQcr6ro5C3qk6
YW4rZftQWasBgWlL/OKn8W0JSRqvl2JGQ3Sm7T7nCHWcoLMQmGQJh4Xozi4kgOzS
ZcdEPPzUt3FWmXN+O9/G6Y11RdGnQh2AvkazBWPEyuTqt9fEbbQgKSiTCHglUc6w
YQvgQ0TAGYF02DbtGGiF2gyPnspDQUxFKFLNUvD/wKz421JMpV60yBNE25EWEPOb
zWD6pcR0LmNEEyRYEhc6arJ6h+ObGyQZ6shJIRZzT4A089/bcYYSo7pvzPfXHD7N
f+dI8aeQhpk=
=3uUM
-----END PGP SIGNATURE-----

--=-umgxClBDn8WH5ulkxk0h--
