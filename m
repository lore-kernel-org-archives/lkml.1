Return-Path: <linux-kernel-owner+w=401wt.eu-S1763995AbXHFLUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763995AbXHFLUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbXHFLUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:20:43 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:51502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbXHFLUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:20:42 -0400
Subject: Re: [linux-pm] Re: [Resend][PATCH] PM: Fix dependencies of
	CONFIG_SUSPEND and CONFIG_HIBERNATION (updated)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <1186398917.28655.69.camel@johannes.berg>
References: <200708051906.22865.rjw@sisk.pl>
	 <20070806090713.GC15329@atrey.karlin.mff.cuni.cz>
	 <1186392591.28655.35.camel@johannes.berg>
	 <20070806102659.GB1875@elf.ucw.cz>
	 <1186398917.28655.69.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SOplHz4CNfeIuhKF+5Sk"
Date: Mon, 06 Aug 2007 13:22:42 +0200
Message-Id: <1186399362.28655.72.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SOplHz4CNfeIuhKF+5Sk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 13:15 +0200, Johannes Berg wrote:

> config SUSPEND_UP_POSSIBLE
> 	depends on ARCH_SUSPEND_UP_POSSIBLE
>=20
> and then the architecture gets to define that when it can suspend.

In fact, just doing
	depends on (ARCH_SUSPEND_UP_POSSIBLE && !SMP) || (ARCH_SUSPEND_SMP_POSSIBL=
E && SMP)

would probably be good instead of doing the intermediate
SUSPEND_UP_POSSIBLE and SUSPEND_SMP_POSSIBLE. The reason I like this
better is that we don't have a central editing point where patches
conflict causing unnecessary problems. But both are much better than
what we have now anyway :)

johannes

--=-SOplHz4CNfeIuhKF+5Sk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtwSC/ETPhpq3jKURAsauAJwO1qbIxGXE/0dJnhf0t4fDC0k8eACgtn/3
wdCXqNU8li3blQwkoiLEF6U=
=FL19
-----END PGP SIGNATURE-----

--=-SOplHz4CNfeIuhKF+5Sk--

