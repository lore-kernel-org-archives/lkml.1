Return-Path: <linux-kernel-owner+w=401wt.eu-S1423316AbXDYIut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423316AbXDYIut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423315AbXDYIut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:50:49 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:38772 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423316AbXDYIus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:50:48 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Christian Hesse <mail@earthworm.de>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1177490913.30284.38.camel@frg-rhel40-em64t-04>
References: <200704182245.24156.mail@earthworm.de>
	 <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de>
	 <20070418220228.GA14536@elte.hu>
	 <1176947576.5906.21.camel@nigel.suspend2.net>
	 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425072350.GA6866@ucw.cz>
	 <1177490913.30284.38.camel@frg-rhel40-em64t-04>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Z4sZDMpaytPImnz3RCT1"
Date: Wed, 25 Apr 2007 18:50:46 +1000
Message-Id: <1177491047.3857.32.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Z4sZDMpaytPImnz3RCT1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-04-25 at 10:48 +0200, Xavier Bestel wrote:
> On Wed, 2007-04-25 at 07:23 +0000, Pavel Machek wrote:
> > > I absolutely detest all suspend-to-disk crap. Quite frankly, I hate t=
he=20
> > > whole thing. I think they've _all_ caused problems for the "true" sus=
pend=20
> > > (suspend-to-ram), and the last thing I want to see is three or four=20
> >=20
> > Well, it is a bit more complex than that.
> >=20
> > suspend-to-disk is a workaround for
> >=20
> >         'suspend-to-ram eats too much power' (plus some details like
> >         being able to replace battery).
> >=20
> > suspend-to-ram is a workaround for
> >=20
> >         'idle machine takes way too much power' (plus some details
> >         like don't spin the disk so that machine is safe to carry).
>=20
> I think it depends on who you ask. I personally think that suspend-to-
> $youchoose is a workaround for the slowness of system startup. I never
> turn off my laptop, I just suspend it.
>=20
> (And guess what, it uses APM and suspend is really faster and way more
> reliable than each kernel implementation I could try).

If you tried Suspend2 and had problems with reliability, please send me
logs. I'll do all I can to help. (I have to qualify it a bit, because
I'm not able to fix drivers, but if it's a Suspend2 issue, tell me and
I'll fix it).

Regards,

Nigel

--=-Z4sZDMpaytPImnz3RCT1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGLxZmN0y+n1M3mo0RApiTAJ9rr6FkTsuJanUSbmYBxryZC5RMHACgv0Zb
PYBzjPfqHWpvribBUBCDkZQ=
=wIb1
-----END PGP SIGNATURE-----

--=-Z4sZDMpaytPImnz3RCT1--

