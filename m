Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbXGCOsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbXGCOsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbXGCOsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:48:15 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:57942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbXGCOsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:48:14 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
In-Reply-To: <200707031651.10225.rjw@sisk.pl>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707031456.40890.rjw@sisk.pl> <1183472474.3722.13.camel@johannes.berg>
	 <200707031651.10225.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0F4/8mMhtQYS2UCPrSZF"
Date: Tue, 03 Jul 2007 16:48:06 +0200
Message-Id: <1183474086.3722.24.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0F4/8mMhtQYS2UCPrSZF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-03 at 16:51 +0200, Rafael J. Wysocki wrote:

> > His proposed solution (freezing tasks when they cross the kernel
> > boundary) helps for the s-t-r case, but in fact doesn't solve (1)
> > because devices can be suspended at runtime
>=20
> This is a different thing and a different infrastructure is needed for it=
 (not
> present at the moment).

Yeah I should've said "any of his proposed solutions"

> > and then you certainly do not want to freeze tasks that try to access t=
he
> > device.=20
> >=20
> > (2) is related but not identical, what if you have a device suspended a=
t
> > runtime and some tasks tries to access it; should the task block until
> > you wake up that device?
>=20
> I think the device should be woken up in that case.

Ah, but that also means the device has to actually know about it.

> > I think the core of the discussion isn't appreciated by everybody here
> > yet---we need to solve both run-time and suspend-to-ram-time device
> > suspend, not just one of them.
>=20
> For now, we're discussing the suspend-to-ram-time suspend only, for which
> we have (some) infrastrcuture (and which should be supported by all drive=
rs,
> IMO).

Right but if we solve the run-time suspend case in favour of having the
device driver know about it then the suspend-to-ram-time suspend case
solves itself.

johannes

--=-0F4/8mMhtQYS2UCPrSZF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGimGm/ETPhpq3jKURAuZaAJwKFpNXjK5dNj2wekTULyCKUtid6ACcDgiq
+ImVwODsg7xJzHdPuMBGohY=
=Y7u8
-----END PGP SIGNATURE-----

--=-0F4/8mMhtQYS2UCPrSZF--

