Return-Path: <linux-kernel-owner+w=401wt.eu-S2993140AbXDZJpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993140AbXDZJpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993148AbXDZJpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:45:14 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:34648 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993140AbXDZJpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:45:11 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: David Lang <david.lang@digitalinsight.com>
Cc: Olivier Galibert <galibert@pobox.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Christian Hesse <mail@earthworm.de>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <Pine.LNX.4.63.0704260016590.9337@qynat.qvtvafvgr.pbz>
References: <20070419070437.GA25211@elte.hu>
	 <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de>
	 <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de>
	 <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org>
	 <20070425233355.GA36476@dspnet.fr.eu.org>
	 <1177552619.5025.147.camel@nigel.suspend2.net>
	 <Pine.LNX.4.63.0704260016590.9337@qynat.qvtvafvgr.pbz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cP9fJQWe4pkZdXnlT5F5"
Date: Thu, 26 Apr 2007 19:45:11 +1000
Message-Id: <1177580711.5025.246.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cP9fJQWe4pkZdXnlT5F5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-26 at 00:27 -0700, David Lang wrote:
> On Thu, 26 Apr 2007, Nigel Cunningham wrote:
>=20
> > Hi.
> >
> > On Thu, 2007-04-26 at 01:33 +0200, Olivier Galibert wrote:
> >> On Wed, Apr 25, 2007 at 11:50:45AM -0700, Linus Torvalds wrote:
> >>> .. but if the alternative is a feature that just isn't worth it, and
> >>> likely to not only have its own bugs, but cause bugs elsewhere? (And =
yes,
> >>> I believe STD is both of those. There's a reason it's called "STD". G=
o
> >>> to google and type "STD" and press "I'm feeling lucky". Google is God=
).
> >>
> >> If it was correctly designed, it would be possible to change the
> >> hardware or even the kernel through a STD cycle.  And that would be
> >> damn interesting on servers.
> >
> > Those are different issues - hardware hot/cold plugging for the first.
> >
> > Changing the kernel through a cycle - that's not a design fault. The
> > problem there is that the kernel and it's associated data structures ar=
e
> > part of the state. Changing the kernel and keeping the image would
> > require exactly correspondence in data structures, memory map and so on=
.
> > That's why the same kernel is required.
>=20
> that depends on exactly what you save in your snapshot.
>=20
> one approach is to try and save absolutly everything in ram (this is the =
current=20
> approach)
>=20
> if you do this then you do need to use the same kernel for the reasons th=
at you=20
> list.
>=20
> however, you could also decide to only save the information about process=
es on=20
> the system (i.e. what you absolutly have to) and let the kernel re-initia=
lize=20
> itself (along with it's devices) then you could use a different kernel sa=
fely.=20
> doing this should also save you a significant amount of storage when make=
ing=20
> your snapshot

Well, there is cryopid for individual processes. I suppose you could
potentially try doing a mass cryopiding. That would make things a lot
more complicated though. I'm not saying it's not doable.

Regards,

Nigel

--=-cP9fJQWe4pkZdXnlT5F5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMHSnN0y+n1M3mo0RAsS7AJ9QccBCDz9cFAEttOWkYZBrbmueYQCdHibk
+9NxO6qFnpskmCnCmCoZocI=
=792i
-----END PGP SIGNATURE-----

--=-cP9fJQWe4pkZdXnlT5F5--

