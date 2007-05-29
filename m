Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXE2WPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXE2WPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbXE2WPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:15:43 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:54165 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbXE2WPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:15:42 -0400
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by
	default
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <200705300013.14750.rjw@sisk.pl>
References: <200705270012.59177.rjw@sisk.pl>
	 <200705291415.31970.rjw@sisk.pl>
	 <1180443572.20718.29.camel@nigel.suspend2.net>
	 <200705300013.14750.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vCpKqWdFn2FDD0jXK1/R"
Date: Wed, 30 May 2007 08:15:43 +1000
Message-Id: <1180476943.20718.53.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vCpKqWdFn2FDD0jXK1/R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-05-30 at 00:13 +0200, Rafael J. Wysocki wrote:
> On Tuesday, 29 May 2007 14:59, Nigel Cunningham wrote:
> > Hi.
> >=20
> > On Tue, 2007-05-29 at 14:15 +0200, Rafael J. Wysocki wrote:
> > > Please have a look at the current version of the patch (appended).
> > >=20
> > > I have followed the Nigel's suggestion not to change the current beha=
vior
> > > in this patch (I'll add a couple of patches removing the freezability=
 from
> > > some kernel threads), with one exception: I couldn't figure out any r=
eason
> > > to have try_to_freeze() called in net/sunrpc/svcsock.c:svc_recv() .
> >=20
> > Thanks. IIRC, svcsock is related to the NFS server code.
> >=20
> > > I've also added a piece of documentation, freezing-of-tasks.txt .  Pl=
ease
> > > see if it's not missing anything (I'd like it to be quite complete).
> >=20
> > [...]
> >=20
> > Mostly just grammar and the odd typo. On the whole, it's really well
> > written and perfectly readable - great job!
>=20
> Thanks a lot for all of the comments, they are really helpful. :-)

Thank you for doing all this work in the first place!

Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>

Regards,

Nigel

--=-vCpKqWdFn2FDD0jXK1/R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXKYPN0y+n1M3mo0RAhJAAKCnK2YrlpM8mlUnzEwbJ7WvnD1DgACdGaVh
TvIGdJdBceWG589gm89Xw8Q=
=A/zG
-----END PGP SIGNATURE-----

--=-vCpKqWdFn2FDD0jXK1/R--

