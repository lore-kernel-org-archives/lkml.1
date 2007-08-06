Return-Path: <linux-kernel-owner+w=401wt.eu-S1763567AbXHFLNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763567AbXHFLNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbXHFLNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:13:24 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:53312 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbXHFLNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:13:23 -0400
Subject: Re: [linux-pm] Re: [Resend][PATCH] PM: Fix dependencies of
	CONFIG_SUSPEND and CONFIG_HIBERNATION (updated)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20070806102659.GB1875@elf.ucw.cz>
References: <200708051906.22865.rjw@sisk.pl>
	 <20070806090713.GC15329@atrey.karlin.mff.cuni.cz>
	 <1186392591.28655.35.camel@johannes.berg>
	 <20070806102659.GB1875@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mrJELG6XDpXKm7avtq0/"
Date: Mon, 06 Aug 2007 13:15:17 +0200
Message-Id: <1186398917.28655.69.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mrJELG6XDpXKm7avtq0/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 12:26 +0200, Pavel Machek wrote:

> Well, so that it does not bitrot? This is few bytes, I'd say, and I
> believe we have too many config options already.

This is not an option the user is ever going to see. I think I'd prefer
having two new per-ARCH config symbols though:
config SUSPEND_UP_POSSIBLE
	depends on ARCH_SUSPEND_UP_POSSIBLE

and then the architecture gets to define that when it can suspend.

johannes

--=-mrJELG6XDpXKm7avtq0/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtwLF/ETPhpq3jKURAlcOAJ9oVWMuve3lFO+jNDAUNnkXwDeGYQCeIQJR
dXZuA0J+Jvb26OhTFAnG2Mc=
=nD1a
-----END PGP SIGNATURE-----

--=-mrJELG6XDpXKm7avtq0/--

