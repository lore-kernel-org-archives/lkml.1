Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbXD0Ouo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbXD0Ouo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbXD0Oun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:50:43 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:38354 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbXD0Ot4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:49:56 -0400
Subject: Re: [linux-pm] driver power operations (was Re: suspend2 merge)
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       suspend2-devel@lists.suspend2.net, Mike Galbraith <efault@gmx.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Adrian Bunk <bunk@stusta.de>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1177684764.3565.20.camel@johannes.berg>
References: <Pine.LNX.4.44L0.0704271008540.3430-100000@iolanthe.rowland.org>
	 <1177684764.3565.20.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-d3dVFZWUqqs8GQ5o4eJI"
Date: Fri, 27 Apr 2007 16:49:51 +0200
Message-Id: <1177685391.3565.22.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d3dVFZWUqqs8GQ5o4eJI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 16:39 +0200, Johannes Berg wrote:

> Good point. Though if we go for passing the interrupt-enable setting as
> an argument then many drivers will have the same
> "if (irqs_disabled()) return" code. Hm. I guess passing it isn't even
> strictly necessary.

Eh, the point I actually wanted to make is that many drivers don't care
for the irqs disabled case and would have to add code to exclude it.

johannes

--=-d3dVFZWUqqs8GQ5o4eJI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMg2P/ETPhpq3jKURAlFSAKC58IY4REN7J4Z2orFc3GjSOD7AfACbBJ1i
3SsunRItONabcfep2bqhFZM=
=V/xn
-----END PGP SIGNATURE-----

--=-d3dVFZWUqqs8GQ5o4eJI--

