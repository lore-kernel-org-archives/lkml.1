Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbXDZGp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbXDZGp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933069AbXDZGp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:45:27 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:53452 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020AbXDZGpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:45:25 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070425234549.GM17387@elf.ucw.cz>
References: <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
	 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
	 <20070425202741.GC17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
	 <20070425214420.GG17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
	 <1177540027.5025.87.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
	 <20070425231319.GK17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251621530.9964@woody.linux-foundation.org>
	 <20070425234549.GM17387@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4jP3KOzMX9oF+OCm1zVP"
Date: Thu, 26 Apr 2007 11:48:41 +1000
Message-Id: <1177552121.5025.141.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4jP3KOzMX9oF+OCm1zVP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-26 at 01:45 +0200, Pavel Machek wrote:
> > What's your argument? Your argument seems to be that it's not stupid,=20
> > because it can work. Can't you see that that simply isn't an
> > argument at=20
>=20
> I tried keeping module_init/thaw/resume similar code, so that driver
> authors can debug suspend-to-disk, cross their fingers, and have
> suspend-to-ram work, too.



> Now, perhaps enough people do std/str these days so this is not
> important any longer... lets hope so.

Noooo! It's important and getting more important. More and more, people
are going to be demanding better power saving (climate change and all
that stuff). The best power saving is to have the thing completely off,
so STD is more important. The second best power saving is STR, so that's
important too. But even more important is good power saving all the
time.

For that reason, I agree completely with Linus. The current model is far
too limited. It shouldn't be so suspend-to-ram/disk centric, and should
instead focus on run-time power management, with suspend to ram and disk
as particular instances of run-time power management. It should make
appropriate differentiation between snapshotting and suspending to ram.

I do disagree that the current suspend-to-disk algorithm is broken. We
do need a point at which we say "Ok, drivers, record your state." - the
current device_suspend and device_resume calls. But that doesn't mean
the need to be called device_suspend/resume or do what they do now.

I'd love to help make this happen, but I'm afraid I just don't have the
time.

Nigel

--=-4jP3KOzMX9oF+OCm1zVP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMAT5N0y+n1M3mo0RAlJaAKDk9r4FZyIQNZ7RqAuno97tqEx6wwCaAyPy
1E1ipjItH16ab0nfcRuWygs=
=yi5w
-----END PGP SIGNATURE-----

--=-4jP3KOzMX9oF+OCm1zVP--

