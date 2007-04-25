Return-Path: <linux-kernel-owner+w=401wt.eu-S2992449AbXDYJTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992449AbXDYJTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992452AbXDYJTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:19:14 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:58654 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992449AbXDYJTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:19:13 -0400
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
In-Reply-To: <1177492072.30284.48.camel@frg-rhel40-em64t-04>
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
	 <1177491047.3857.32.camel@nigel.suspend2.net>
	 <1177492072.30284.48.camel@frg-rhel40-em64t-04>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-af8UkB2autnwajxUCfHQ"
Date: Wed, 25 Apr 2007 19:19:11 +1000
Message-Id: <1177492751.3857.43.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-af8UkB2autnwajxUCfHQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-04-25 at 11:07 +0200, Xavier Bestel wrote:
> On Wed, 2007-04-25 at 18:50 +1000, Nigel Cunningham wrote:
> > > (And guess what, it uses APM and suspend is really faster and way mor=
e
> > > reliable than each kernel implementation I could try).
> >=20
> > If you tried Suspend2 and had problems with reliability, please send me
> > logs. I'll do all I can to help. (I have to qualify it a bit, because
> > I'm not able to fix drivers, but if it's a Suspend2 issue, tell me and
> > I'll fix it).
>=20
> Does suspend2 work with APM ? After much trying, I think now the ACPI
> implementation of my laptop (a vintage Compaq Armada 1700) is busted,
> only APM works.

It should do. If you set the powerdown method to 0, it will use
machine_power_off() instead of trying to use acpi, fall back to
machine_halt() if that fails and lastly (should not be needed) a
while(1) cpu_relax() loop.

> AFAIR the problem with suspend2 was that it didn't poweroff some parts
> of the laptop (the led of the wifi pcmcia card was on, and the lcd light
> was on too), but that was last year. Kernel's suspend kind of worked but
> didn't resume (no reaction on button press). As I tried all this last
> year, I may have forgotten some things.

The code to poweroff those parts will be dependent on the drivers
(assuming I'm making the right calls). If it's something where swsusp
works and suspend2 doesn't, it will be because I'm doing something
wrong. If they both don't do the right thing, then it's probably the
driver.

> Honestly, I like this laptop when it works flawlessly, so I don't see
> many reasons to try *susp* again. I'll do it when I'm bored, just not
> today.

Okay :) Just let me know if I can help.

Nigel

--=-af8UkB2autnwajxUCfHQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGLx0PN0y+n1M3mo0RArAzAKCinb2O66hPQnGewE53d1aQ7z5/swCeJFvj
niwS3AsEJ3IjFY5mEE/gdwc=
=Jn5d
-----END PGP SIGNATURE-----

--=-af8UkB2autnwajxUCfHQ--

