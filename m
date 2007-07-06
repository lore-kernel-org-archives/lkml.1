Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbXGFXq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbXGFXq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 19:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXGFXqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 19:46:52 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:51709 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbXGFXqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 19:46:51 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Date: Sat, 7 Jul 2007 09:46:47 +1000
User-Agent: KMail/1.9.6
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org
References: <20070706202629.GA158@tv-sign.ru> <200707070056.22560.rjw@sisk.pl>
In-Reply-To: <200707070056.22560.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10034318.MeZ1UxdGJD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707070946.50153.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10034318.MeZ1UxdGJD
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Saturday 07 July 2007 08:56:21 Rafael J. Wysocki wrote:
> On Friday, 6 July 2007 22:26, Oleg Nesterov wrote:
> > Rafael J. Wysocki wrote:
> > >
> > > This patch makes the freezer skip uninterruptible user space tasks (i=
e.=20
such
> > > that have an mm of their own) when counting the tasks to be frozen.  =
As=20
a
> > > result, these tasks have the TIF_FREEZE and TIF_SIGPENDING flags set,=
=20
but the
> > > freezer doesn't wait for them to enter the refrigerator.  Nevertheles=
s,=20
they
> > > will enter the refrigerator as soon as they change their state.
> >=20
> > A small correction: they will enter the refrigerator on return to=20
user-space.
>=20
> Yes, I should have written that explicitly.
>=20
> > Actually, TASK_INTERRUPTIBLE doesn't mean the task actually sleeps. It=
=20
could
> > be running or preempted... I am a bit worried :)
>=20
> Fortunately, similar approach has been tested quite extensively by suspen=
d2,
> IIRC. :-)

That's right. I used to signal TASK_UNINTERRUPTIBLE (I take it the=20
INTERRUPTIBLE above is a typo) tasks, but ignore them when deciding whether=
=20
freezing was successful.

I've since dropped those modifications, but only because I'm actively tryin=
g=20
to get closer to mainline.

Regards,

Nigel
=2D-=20
Nigel Cunningham
Christian Reformed Church of Cobden
103 Curdie Street, Cobden 3266, Victoria, Australia
Ph. +61 3 5595 1185 / +61 417 100 574
Communal Worship: 11 am Sunday.

--nextPart10034318.MeZ1UxdGJD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjtRqN0y+n1M3mo0RAiBfAJ40wXHNRNTrNRJ5Ie/Zw1NiUlYsgACguioC
2JmWooBFKt9rMCjNGry8mR4=
=QoMI
-----END PGP SIGNATURE-----

--nextPart10034318.MeZ1UxdGJD--
