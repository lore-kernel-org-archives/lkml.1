Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbXEYFS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbXEYFS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbXEYFSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:18:50 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:41470 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbXEYFSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:18:49 -0400
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
In-Reply-To: <alpine.LFD.0.98.0705242147090.26602@woody.linux-foundation.org>
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
	 <1180059605.3997.100.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org>
	 <1180062040.3997.112.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org>
	 <1180067587.3997.136.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705242147090.26602@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-liTSgnmOaAmsmS30rsyT"
Date: Fri, 25 May 2007 15:18:46 +1000
Message-Id: <1180070326.3997.166.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-liTSgnmOaAmsmS30rsyT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-05-24 at 21:49 -0700, Linus Torvalds wrote:
>=20
> On Fri, 25 May 2007, Nigel Cunningham wrote:
> >=20
> > Does that mean you never ever power off your laptop (assuming you have
> > one), and the battery never runs out? Surely you must power it off
> > completely sometimes?
>=20
> So? The bootup isn't that much worse than a disk suspend/resume, and it's=
=20
> reliable.
>=20
> And actually, I don't use laptops much. I use mostly desktops, and STR=20
> works fine on at least some of them. In contrast, doing some=20
> suspend-to-disk thing would just be insane and idiotic. If I have to wait=
=20
> for half a minute and have a slow system even after that because my git=20
> trees aren't in the cache, I really might as well just shut them off.
>=20
> In contrast, STR means they are quiet and don't waste energy when I don't=
=20
> use them, but they're instantly available when I care. HUGE difference.
>=20
> I really think suspend-to-disk is just a total waste of my time.

Ah. That's because you're using [u]swsusp. If you used Suspend2, your
git trees would be in the cache, your system wouldn't be slow and you'd
still be back up in that half a minute or so - probably less time. Give
it a try for a week, and then go back to rebooting. After that, tell me
rebooting is better and I've wasted the last 5 or 6 years improving the
code.

Regards,

Nigel

--=-liTSgnmOaAmsmS30rsyT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGVnG2N0y+n1M3mo0RAtd6AKCKIs6QVpCSHqGuiZlxF9mUGbYJAgCghBwT
Rh8xvYN1YsELK7Nh+tJnACk=
=9DlP
-----END PGP SIGNATURE-----

--=-liTSgnmOaAmsmS30rsyT--

