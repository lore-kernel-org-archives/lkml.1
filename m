Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbXE1WxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbXE1WxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbXE1WxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:53:08 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:42813 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbXE1WxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:53:05 -0400
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20070528130343.GB29738@srcf.ucam.org>
References: <1180008394.15600.26.camel@localhost>
	 <20070527184402.GA21161@srcf.ucam.org>
	 <20070528010506.GA24186@srcf.ucam.org> <200705281011.17338.rjw@sisk.pl>
	 <20070528121056.GA29143@srcf.ucam.org> <20070528125507.GI18807@elf.ucw.cz>
	 <20070528130343.GB29738@srcf.ucam.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LBxhtiGjzeykB2V10R76"
Date: Tue, 29 May 2007 08:53:03 +1000
Message-Id: <1180392783.4149.18.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LBxhtiGjzeykB2V10R76
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Mon, 2007-05-28 at 14:03 +0100, Matthew Garrett wrote:
> On Mon, May 28, 2007 at 02:55:07PM +0200, Pavel Machek wrote:
>=20
> > Well, PPC people are aware of this, and they think they can fix the
> > drivers. We probably want to drop the freezer for suspend long-term,
> > so. PPC machines use small subset of all the drivers, so it apparently
> > is not big problem for them.
>=20
> I'm fairly certain that PPC uses USB. In any case, it's not limited to=20
> PPC - APM has the same issue. Any driver that assumes processes will be=20
> frozen during suspend to RAM is broken now, not the future.

The converse is also true, though. Any process that assumes processes
aren't frozen during suspend to RAM is also broken now, and will be
while we allow the possibility of suspending to ram after writing a
hibernation image.

In short, drivers should be designed to work whether processes are
frozen or not.

Regards,

Nigel

--=-LBxhtiGjzeykB2V10R76
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGW11PN0y+n1M3mo0RAgniAJ0fZhQWg5VICONqJI8RjBgVd6QVvQCgmwo+
tsHtsvNsxqI4JD92iezEqJs=
=Aant
-----END PGP SIGNATURE-----

--=-LBxhtiGjzeykB2V10R76--

