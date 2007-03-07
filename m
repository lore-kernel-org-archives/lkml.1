Return-Path: <linux-kernel-owner+w=401wt.eu-S2992464AbXCGWHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992464AbXCGWHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992461AbXCGWHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:07:39 -0500
Received: from mx.laposte.net ([81.255.54.11]:34426 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992464AbXCGWHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:07:38 -0500
Subject: Re: [Bug 8136] 2.6.21-rc2-mm2 won't boot
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
In-Reply-To: <20070306161559.e0c7ee71.akpm@linux-foundation.org>
References: <200703062336.l26NaTZA026385@fire-2.osdl.org>
	 <20070306161559.e0c7ee71.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ht9nBBgkFjMvosBpZArb"
Organization: Adresse perso
Date: Wed, 07 Mar 2007 23:06:49 +0100
Message-Id: <1173305209.3510.4.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 (2.9.92-1.fc7.1) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ht9nBBgkFjMvosBpZArb
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le mardi 06 mars 2007 =C3=A0 16:15 -0800, Andrew Morton a =C3=A9crit :
> On Tue, 6 Mar 2007 15:36:29 -0800
> bugme-daemon@bugzilla.kernel.org wrote:
>=20
> > http://bugzilla.kernel.org/show_bug.cgi?id=3D8136

> So rc2-mm2 panics due to "MP-BIOS bug: 8254 timer not connected to IO-API=
C" and
> rc2-mm1 does not.
>=20
> Could be ACPI, could be x86_64 timer changes, could be something else.
>=20
> Would you have time to bisect it?=20
>=20
> I'd suggest you drill in on the patches between
> x86_64-mm-defconfig-update.patch and
> optimize-and-simplify-get_cycles_sync.patch: the x86 changes.

Removing the x86 patchset (342-430) and utrace (647-663) makes the
system boot. (no surprise, but good to confirm). I'll try a few more
tests tomorrow, need to sleep now.

--=20
Nicolas Mailhot

--=-ht9nBBgkFjMvosBpZArb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkXvN3MACgkQI2bVKDsp8g3o6ACeP0WuacKHf2cQvUSykc8sPmGb
J6oAn3hauCAUIycN1UqXgFMhyMffVlTf
=t52l
-----END PGP SIGNATURE-----

--=-ht9nBBgkFjMvosBpZArb--
