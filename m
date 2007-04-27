Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbXD0Mql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbXD0Mql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbXD0Mql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:46:41 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:59767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbXD0Mqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:46:40 -0400
Subject: Re: driver power operations (was Re: suspend2 merge)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20070427124029.GH22250@elf.ucw.cz>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070425203150.GD17387@elf.ucw.cz>
	 <1177669279.7828.55.camel@johannes.berg> <200704271407.00879.rjw@sisk.pl>
	 <20070427124029.GH22250@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pcXzd7RiCtDbVasHyGX3"
Date: Fri, 27 Apr 2007 14:46:42 +0200
Message-Id: <1177678002.6024.11.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pcXzd7RiCtDbVasHyGX3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 14:40 +0200, Pavel Machek wrote:

> > Five callbacks are fine by me, especially if we can define reasonable d=
efaults
> > for the hibernation (and can we?).
>=20
> Well, we still can default to suspend(PMSG_FREEZE) for freeze(), and
> resume() for thaw(). Anything else is just not sane way forward.

I think we should remove the argument to suspend() in the same patch
series. Yes, that would mean porting all drivers that currently use it,
but that's not actually all that many since most drivers are dumbed-down
wrt. power management.

And realistically, resume for thaw makes no sense, nor does suspend for
freeze, so we probably want to change those over to suspend/restart and
use them. or something.

johannes

--=-pcXzd7RiCtDbVasHyGX3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMfCy/ETPhpq3jKURAvgfAKCkr5+8OohXwg+2mpD5/9Ck7bZb9wCdGagf
Lobd27HlV2zLmB2uxffXcaA=
=I2Ch
-----END PGP SIGNATURE-----

--=-pcXzd7RiCtDbVasHyGX3--

