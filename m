Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbXD0JnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbXD0JnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 05:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbXD0JnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 05:43:19 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:54625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbXD0JnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 05:43:18 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Nick Piggin <npiggin@suse.de>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200704262102.38568.rjw@sisk.pl>
References: <20070425072350.GA6866@ucw.cz> <200704262040.31760.rjw@sisk.pl>
	 <1177612802.6814.121.camel@johannes.berg>  <200704262102.38568.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sx0pN/4AmYPOBo7ZlVak"
Date: Fri, 27 Apr 2007 11:41:55 +0200
Message-Id: <1177666915.7828.35.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sx0pN/4AmYPOBo7ZlVak
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-26 at 21:02 +0200, Rafael J. Wysocki wrote:

> Yes.  That's because we want to be able to repeat creating the image
> without closing the fd in some situations.

Oh yeah, I just checked and it's not in fact necessary. I'm just
confused.

> Still, we could use a global var 'platform_hibernation' or something like=
 this,
> I think.  Then, we can do
>=20
> #define platform_hibernation	0
>=20
> on the architectures that don't need it and make ACPI use it instead of t=
his
> "dynamic linking".

No, because acpi doesn't know at build time whether it can actually do
S4 or not.

johannes

--=-sx0pN/4AmYPOBo7ZlVak
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMcVj/ETPhpq3jKURAmB6AKCpfdLNEeTvIqeZrHsehiRh+q545wCgo1nU
i/lNjbTZPhyGSdDmbHpra5w=
=TVqT
-----END PGP SIGNATURE-----

--=-sx0pN/4AmYPOBo7ZlVak--

