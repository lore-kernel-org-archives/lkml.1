Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZC3G3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZC3G3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 02:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZC3G3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 02:29:36 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:60358 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZC3G3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 02:29:35 -0400
Subject: Re: DRM lock ordering fix series
From: Eric Anholt <eric@anholt.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <1238203799.4039.437.camel@laptop>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <87ocvnmhqx.fsf@basil.nowhere.org>
	 <1238170767.8275.2397.camel@gaiman.anholt.net>
	 <1238171805.8275.2434.camel@gaiman.anholt.net>
	 <20090327181018.GC11935@one.firstfloor.org>
	 <1238184629.625.44.camel@gaiman.anholt.net>
	 <1238201922.4039.403.camel@laptop>  <1238203799.4039.437.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AFbdMaV3ACgAapRl15aH"
Date: Sun, 29 Mar 2009 23:29:32 -0700
Message-Id: <1238394572.9782.13.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AFbdMaV3ACgAapRl15aH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-28 at 02:29 +0100, Peter Zijlstra wrote:
> On Sat, 2009-03-28 at 01:58 +0100, Peter Zijlstra wrote:
>=20
> > > OK.  I'm not too excited here -- 10% of 2% of the CPU time doesn't ge=
t
> > > me to the 10% loss that the slow path added up to.  Most of the cost =
is
> > > in k{un,}map_atomic of the returned pages. =20
> >=20
> > Also note that doing large gup() with gup_fast() will be undesirable du=
e
> > to it disabling IRQs. So iterating say several MB worth of pages will
> > hurt like crazy. Currently all gup_fast() users do a single page lookup=
.
>=20
> Also, what's this weird facination with 32bit, can you even buy a 32bit
> only cpu these days?

I work on OpenGL.  Many people using OpenGL want to play commercial
games.  Commercial games are 32-bit.  sysprof doesn't work for 32-on-64,
so I'd lose a critical tool.  Thus, 32-only.

keithp runs 32-on-64, and just about every day we're working together,
we lament that he can't run sysprof on his box.  Getting ~10% of my CPU
back by going 32-on-64 would be nice, but it's not worth not being able
to usefully profile.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-AFbdMaV3ACgAapRl15aH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknQZswACgkQHUdvYGzw6vefFwCfRSvVgBhH6I0WHEh0a1c3vStq
6VMAoINkzcooZvxG7q0gGDQNIqjrdo6n
=Biit
-----END PGP SIGNATURE-----

--=-AFbdMaV3ACgAapRl15aH--
