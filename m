Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbXDZHf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbXDZHf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXDZHf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:35:27 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:34182 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbXDZHfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:35:25 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Olivier Galibert <galibert@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Christian Hesse <mail@earthworm.de>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070425233355.GA36476@dspnet.fr.eu.org>
References: <20070419070437.GA25211@elte.hu>
	 <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de>
	 <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de>
	 <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org>
	 <20070425233355.GA36476@dspnet.fr.eu.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-G+M6xBqjBZ5ooIB4VxZ4"
Date: Thu, 26 Apr 2007 11:56:59 +1000
Message-Id: <1177552619.5025.147.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-G+M6xBqjBZ5ooIB4VxZ4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-26 at 01:33 +0200, Olivier Galibert wrote:
> On Wed, Apr 25, 2007 at 11:50:45AM -0700, Linus Torvalds wrote:
> > .. but if the alternative is a feature that just isn't worth it, and=20
> > likely to not only have its own bugs, but cause bugs elsewhere? (And ye=
s,=20
> > I believe STD is both of those. There's a reason it's called "STD". Go=20
> > to google and type "STD" and press "I'm feeling lucky". Google is God).
>=20
> If it was correctly designed, it would be possible to change the
> hardware or even the kernel through a STD cycle.  And that would be
> damn interesting on servers.

Those are different issues - hardware hot/cold plugging for the first.

Changing the kernel through a cycle - that's not a design fault. The
problem there is that the kernel and it's associated data structures are
part of the state. Changing the kernel and keeping the image would
require exactly correspondence in data structures, memory map and so on.
That's why the same kernel is required.

> In any case, if I could trust it, I'd use it when I need to move
> servers around and I don't want to lose what is running.  Riding power
> cuts that way would be nice.

That's what Rafael and I working on.

Nigel

--=-G+M6xBqjBZ5ooIB4VxZ4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMAbrN0y+n1M3mo0RAtG+AJ4jPsOA94uW6pXfSF3WLsBQbHcmGACfZ7o4
yIQsLLG/a9XWT5vkMr7uBfg=
=5VtJ
-----END PGP SIGNATURE-----

--=-G+M6xBqjBZ5ooIB4VxZ4--

