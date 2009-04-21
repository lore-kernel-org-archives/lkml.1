Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZDUO1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZDUO1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbZDUO0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:26:46 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:56917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbZDUO0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:26:45 -0400
Subject: Re: lockdep report at resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oliver@neukum.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <alpine.LNX.2.00.0904211609220.13028@wotan.suse.de>
References: <1234022517.4175.107.camel@johannes.local>
	 <1238578840.5970.178.camel@johannes.local>
	 <alpine.LNX.2.00.0904211550280.13028@wotan.suse.de>
	 <200904211559.43497.oliver@neukum.org>
	 <alpine.LNX.2.00.0904211609220.13028@wotan.suse.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hxvv4Op8630SQVt5Ws4h"
Date: Tue, 21 Apr 2009 16:26:08 +0200
Message-Id: <1240323968.17388.22.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hxvv4Op8630SQVt5Ws4h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-21 at 16:11 +0200, Jiri Kosina wrote:
> On Tue, 21 Apr 2009, Oliver Neukum wrote:
>=20
> > > [ thanks for the analysis Johannes ... involving also Oliver here; re=
ally
> > >   seems like a false positive to me ]
> > I think he's right. But as a matter of principle I'd like to see=20
> > flush_scheduled_work() avoided where possible, hence the patch.
>=20
> I am not entirely sure that this is the same issue as the one from #13136=
=20
> of kernel.org bugzilla.
>=20
> Anyway, for reference, the patch Oliver mentioned here is below.

Thanks. Unfortunately I have another problem that turns off lockdep so I
can't test this right now, sorry.

johannes

--=-hxvv4Op8630SQVt5Ws4h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIbBAABAgAGBQJJ7dd9AAoJEKVg1VMiehFYzA0P+JKCA1O0sfht1jZqVb0MLpEZ
/VXsEMxe58PLUqQEGPgyjqN6yDr8yRulISRrYrll4k6yer+pr6JBzwOVLPXr/tI7
dU/0HsVpEpwVRAPNv2EemNS1X/iQFapyHsSuIARklnGP2Tu2zpjTEi/HNdELepWc
bIFWIpAIMhX5Wf7eex/Lnr+uq6Er6ylHKmuh+JgEWO5MzE5pdQZA0MC1STX7ZiDo
rshQSJ5EU4Q9gxfdMZot7ANB0bBhqjCSKJnpzLweWnZjKHS12pIq/JWOr2mXY6s4
LQTNBTP5MUqVgVpdApt28IyO0OZvvNrgCOek3dvDAyh7A8jvhdXyOOWfcs91xg4d
IyJFKG82tHuMTGKtNuwTs/U9yU80XXNwC+UZJX2jaOhYs2W9R9qrAke9ndKgB0aC
Oo7+y+kJpxu7zejwxvXBqkEgk3MyH/EDo4PK7YGG8OrC2z3nodM4WXxy7eet9s0T
vjbby3FRNR01a1fUWJ0WlXV5326z41SRC7D3lrCkIFWGlWFDHZJePvbb2yvwo634
qBR4hjfCebbd5YooDRy8KXKf8Vmp0CAAc5BHCtYcrcj8HRhrbnC1VQTOk/+DOCV5
QwhCBaFjNwcnmuK+ZJUtQnnXbVkd5BXJO2wBI+XJVVCBgTF+kEBfysJa/JvLHJMo
L5jdIgVyEBmmdkTn+OI=
=FnhA
-----END PGP SIGNATURE-----

--=-hxvv4Op8630SQVt5Ws4h--

