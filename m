Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbXD0PYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbXD0PYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbXD0PYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:24:36 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:33901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbXD0PYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:24:34 -0400
Subject: Re: [linux-pm] driver power operations (was Re: suspend2 merge)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Adrian Bunk <bunk@stusta.de>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <200704271712.10437.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0704271008540.3430-100000@iolanthe.rowland.org>
	 <200704271712.10437.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-INcQ7+TQSCuO2zSTGcof"
Date: Fri, 27 Apr 2007 17:24:21 +0200
Message-Id: <1177687461.3565.38.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-INcQ7+TQSCuO2zSTGcof
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 17:12 +0200, Rafael J. Wysocki wrote:

> How do we differentiate between post_snapshot() and post_restore()?
> I mean, after the restore we're entering the same code path as after the
> snapshot, so do we use a global var for this purpose?

That's pretty easy to do though, we already know at which point we are
so we just put an if(...) invoke_post_snapshot() else
invoke_post_restore().

johannes

--=-INcQ7+TQSCuO2zSTGcof
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMhWk/ETPhpq3jKURAgNxAJ47oSJKr42rumptaXtODIh0MDXRrgCeJtPO
mjoso3FT4UVzC4rLOMpwL2Y=
=rIX7
-----END PGP SIGNATURE-----

--=-INcQ7+TQSCuO2zSTGcof--

