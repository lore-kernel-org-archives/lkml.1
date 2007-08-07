Return-Path: <linux-kernel-owner+w=401wt.eu-S1761937AbXHGJsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761937AbXHGJsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758609AbXHGJsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:48:46 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:59092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542AbXHGJsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:48:45 -0400
Subject: Re: [linux-pm] Re: [Resend][PATCH] PM: Fix dependencies of
	CONFIG_SUSPEND and CONFIG_HIBERNATION (updated)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <200708061356.23030.rjw@sisk.pl>
References: <200708051906.22865.rjw@sisk.pl>
	 <1186398917.28655.69.camel@johannes.berg>
	 <20070806113644.GA1790@elf.ucw.cz>  <200708061356.23030.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DLw5ronqpyv8r4EOMP/u"
Date: Tue, 07 Aug 2007 11:42:36 +0200
Message-Id: <1186479756.4067.23.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DLw5ronqpyv8r4EOMP/u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 13:56 +0200, Rafael J. Wysocki wrote:
> On Monday, 6 August 2007 13:36, Pavel Machek wrote:
> > On Mon 2007-08-06 13:15:17, Johannes Berg wrote:
> > > On Mon, 2007-08-06 at 12:26 +0200, Pavel Machek wrote:
> > >=20
> > > > Well, so that it does not bitrot? This is few bytes, I'd say, and I
> > > > believe we have too many config options already.
> > >=20
> > > This is not an option the user is ever going to see. I think I'd
> > > prefer
> >=20
> > Ok, option that users can't set is probably not evil.
> >=20
> > > having two new per-ARCH config symbols though:
> > > config SUSPEND_UP_POSSIBLE
> > > 	depends on ARCH_SUSPEND_UP_POSSIBLE
> > >=20
> > > and then the architecture gets to define that when it can suspend.
> >=20
> > Looks like a plan.
>=20
> Hmm, why don't we do the $subject change first (the advantage if it is th=
at
> the patch is ready) and then move the necessary definitions to the arch l=
evel?

Sounds good to me as well, that way we already have the basic stuff in
place. Hey, we could even migrate over slowly by making
SUSPEND_UP_POSSIBLE depend on ARCH_SUSPEND_UP_POSSIBLE *and* all the
arches that support it right now.

johannes

--=-DLw5ronqpyv8r4EOMP/u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGuD6M/ETPhpq3jKURAsiEAJ9+Yj79xkHtYaFNqrv0K9IFe05PKgCcDr6u
ynIkSWkktvmStBdUjKR9BgU=
=p2UK
-----END PGP SIGNATURE-----

--=-DLw5ronqpyv8r4EOMP/u--

