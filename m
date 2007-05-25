Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbXEYCUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbXEYCUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 22:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbXEYCUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 22:20:10 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:54040 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbXEYCUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 22:20:08 -0400
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org>
References: <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
	 <1180008394.15600.26.camel@localhost>
	 <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
	 <20070524200435.GA9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
	 <20070524220017.GC9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
	 <20070524221743.GD9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
	 <20070524231852.GG9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
	 <1180058123.3997.91.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nvwRWSkeSv71GGWgiETv"
Date: Fri, 25 May 2007 12:20:05 +1000
Message-Id: <1180059605.3997.100.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nvwRWSkeSv71GGWgiETv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Linus.

On Thu, 2007-05-24 at 19:10 -0700, Linus Torvalds wrote:
>=20
> On Fri, 25 May 2007, Nigel Cunningham wrote:
> >=20
> > First, let me agree with you that for the atomic copy itself, the
> > freezer is unnecessary. Disabling irqs and so on is enough to ensure th=
e
> > atomic copy is atomic. I don't think any of us are arguing with you
> > there.
>=20
> First off, realize that the problem actually happens during=20
> suspend-to-ram.
>=20
> Think about that for a second.
>=20
> In fact, think about it for a _loong_ time. Because dammit, people seem t=
o=20
> have a really hard time even realizing this.
>=20
> 	There is no "atomic copy".
>=20
> 	There is no "checkpointing".
>=20
> 	There is no "spoon".
>=20
> > Hope this helps.
>=20
> Hope _the_above_ helps. Why is it so hard for people to accept that=20
> suspend-to-ram shouldn't break because of some IDIOTIC issues with disk=20
> snapshots?
>=20
> And why do you people _always_ keep mixing the two up?

It does. Sorry. I didn't read enough of the context.

To answer the question, I guess the answer is that although they're
different creatures, they have similarities. This is one of them, which
is why I could make the mistake I did. Nothing in the issue being
discussed was unique to suspend-to-ram. Perhaps we (or at least I) focus
too much on the similarities, but that doesn't mean they're not there.

Regards,

Nigel

--=-nvwRWSkeSv71GGWgiETv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGVkfVN0y+n1M3mo0RAr/tAJsFhHD6wF//bSQQiKepyOcY4FFDLACffWCT
mihbwmlya5wDOR2rtj0HqoA=
=COZM
-----END PGP SIGNATURE-----

--=-nvwRWSkeSv71GGWgiETv--

