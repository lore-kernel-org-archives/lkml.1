Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbXGEMtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbXGEMtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbXGEMt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:49:29 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:58516 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbXGEMt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:49:28 -0400
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
	pathway
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Mackerras <paulus@samba.org>, mjg59@srcf.ucam.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <200707051451.38497.rjw@sisk.pl>
References: <E1I63Nv-0006Z9-00@dorka.pomaz.szeredi.hu>
	 <Pine.LNX.4.44L0.0707041139100.25704-100000@netrider.rowland.org>
	 <18060.15630.812698.367707@cargo.ozlabs.ibm.com>
	 <200707051451.38497.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5wbtt3bjFieiS1P7Vk4K"
Date: Thu, 05 Jul 2007 14:50:25 +0200
Message-Id: <1183639825.3818.38.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5wbtt3bjFieiS1P7Vk4K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-05 at 14:51 +0200, Rafael J. Wysocki wrote:

> > > Remember what I wrote a few minutes ago about khubd and ksuspend_usbd
> > > wanting to resume devices during a system suspend transition?  This i=
s
> > > exactly what happens when those threads aren't frozen.
> >=20
> > So, I wonder why I don't see that error on my powerbook?
>=20
> Because you have only one CPU running while your suspend code is being
> executed?

If that's really all the problem then what's wrong with just unplugging
the other CPUs earlier? Sure, that makes suspend no longer perfectly
transparent since userspace might notice the CPUs being unplugged, but
it has to cope with that anyway since a user can do it manually...

johannes

--=-5wbtt3bjFieiS1P7Vk4K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjOkQ/ETPhpq3jKURAuS+AKCkOs0M4b62O+mlZjMKGlO7InyTyQCfU+/Z
ZOzbFpjyaZyeiBmCweuEM90=
=Bh3G
-----END PGP SIGNATURE-----

--=-5wbtt3bjFieiS1P7Vk4K--

