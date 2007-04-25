Return-Path: <linux-kernel-owner+w=401wt.eu-S1423305AbXDYIsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423305AbXDYIsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423306AbXDYIsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:48:51 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:46872 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423305AbXDYIsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:48:50 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070425072904.GB6866@ucw.cz>
References: <20070418211632.GA7610@elte.hu>
	 <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
	 <1176947576.5906.21.camel@nigel.suspend2.net>
	 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425064137.GA25247@elte.hu>  <20070425072904.GB6866@ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jRXaRF8mZBLCkKDZkJ7E"
Date: Wed, 25 Apr 2007 18:48:48 +1000
Message-Id: <1177490928.3857.27.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jRXaRF8mZBLCkKDZkJ7E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-04-25 at 07:29 +0000, Pavel Machek wrote:
> Hi!
>=20
> > > I absolutely detest all suspend-to-disk crap. Quite frankly, I hate=20
> > > the whole thing. I think they've _all_ caused problems for the "true"=
=20
> > > suspend (suspend-to-ram), and the last thing I want to see is three o=
r=20
> > > four different suspend-to-disk implementations.  So unlike Ingo, I=20
> > > don't think "let's just integrate them all side-by-side and maintain=20
> > > them and look who wins" is really a good idea.
> > >
> > > How many different magic ioctl's does the thing introduce? Is it=20
> > > really just *two* entry-points (and how simple are they,=20
> > > interface-wise), and nothing else?
> >=20
> > userspace-driven-suspend is already in the kernel, today. So it's not=20
> > really "two versions side by side doing the same thing", but more of:
> >=20
> >            A B C + D E F G H
> >=20
> > where "ABC" is used by the uswsusp code today, and "ABCDEFGH" is used b=
y=20
> > suspend2. So any "suspend2 merge" would largely be about adding "DEFGH"=
.=20
>=20
> Actually, we have 'D H' in kernel, today. It is called swsusp...
> (Encryption, swapFile support and Graphical progress are missing from
> today's kernel.)

Along with a lot of other things (see my "Reasons to merge Suspend2"
email from earlier in the day).

> > My original mail was about the following thing: i tried the suspend2=20
> > patch (which just makes "echo disk > /sys/power/state" work as expected=
,=20
> > as long as you give the booting up kernel image an idea about where the=
=20
>=20
> ..and it means that 'echo disk > ...' should work w/o suspend2 patch,
> too. (Just try it). You'll miss compression part, but that provides
> only small speedup.

Please don't spread misinformation to support your case. LZF compression
(which is what all Suspend2 users use AFAIK) generally doubles the speed
of your cycle.

Nigel

--=-jRXaRF8mZBLCkKDZkJ7E
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGLxXwN0y+n1M3mo0RApjAAKCddO2xyHvaLsZFvDevimuucjKPnACfchvf
LbIgKQgPKny886GffooCap0=
=R5pH
-----END PGP SIGNATURE-----

--=-jRXaRF8mZBLCkKDZkJ7E--

