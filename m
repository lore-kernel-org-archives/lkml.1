Return-Path: <linux-kernel-owner+w=401wt.eu-S934619AbXGKWy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619AbXGKWy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761589AbXGKWys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:54:48 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:44309 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919AbXGKWyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:54:47 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: david@lang.hm
Subject: Re: Hibernation Redesign
Date: Thu, 12 Jul 2007 08:54:45 +1000
User-Agent: KMail/1.9.6
Cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, a1426z@gawab.com,
       jeremy@goop.org, jbms@cmu.edu, pavel@ucw.cz, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707112211.23420.nigel@nigel.suspend2.net> <Pine.LNX.4.64.0707111052380.25614@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707111052380.25614@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6473391.70gAx6cCTY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707120854.46873.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6473391.70gAx6cCTY
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 12 July 2007 03:55:40 david@lang.hm wrote:
> On Wed, 11 Jul 2007, Nigel Cunningham wrote:
>=20
> > Hi.
> >
> > On Wednesday 11 July 2007 21:11:34 Miklos Szeredi wrote:
> >>> Anyway, to implement the kexec approach we must separate the
> >>> hibernation from the suspend at the drivers level, which I'm still
> >>> going to do, but I need to take part in endless discussions
> >>
> >> Discussions are good.  We understand the problem better.  Now I still
> >> think we don't understand every aspect completely, so continuing the
> >> discussion makes sense.
> >>
> >>> regarding the freezer, how it is bad and how we should drop it,
> >>> because it breaks things (which NB is not true, because it doesn't).
> >>
> >> This thread started out from a bug, that seemed to be caused by the
> >> freezer (we still don't exactly know what it was caused by), and the
> >> discussion uncovered various problems _with_ the freezer, that up to
> >> now no other _proper_ solutions have been propsed than to remove the
> >> freezer.
> >
> > No other _proper_ solutions have been proposed. Everyone who suggests=20
removing
> > the freezer also suggests implementing it all over again. It might be=20
sending
> > SIGSTOP to everything. It might be shifting the desk chairs around and
> > creating a completely new kernel context, but they always have the same
> > goal - stopping the existing activity, and they all come with their own
> > issues (even if they're not obvious yet because the alternatives are
> > currently vapourware to one extent or another).
>=20
> I think the big problem with the existing freezer is that you want to sto=
p=20
> everything, except X, except Y, except Z.....
>=20
> the advantage of the new approaches being proposed is that they don't=20
> require _anything_ from the origional system continue to run so you avoid=
=20
> all the exceptions.
>=20
> freezing everything is easy, figuring out what you don't want to freeze i=
s=20
> where everyone is seeing problems.
>=20
> > IMHO, the real solution is to go back to the original issue and fix it
> > properly. Make fuse filesystems play nicely with the existing freezer.=
=20
I've
> > just gone back and looked at the point where you started talking
> > about "malicious filesystems". You talk about fuse imposing certain=20
ordering
> > in the userspace tasks being frozen. Please, say more. What ordering=20
issues?
> > Why? How can such ordering be determined programmatically?
>=20
> I think most people just see this as a symptom of the problem, not the=20
> core problem itself.

Sure, but before we go out and buy a new car, let's figure out properly wha=
t=20
the problems with the old one are. It might just be that the horrendous sou=
nd=20
that's making us want a new car isn't as bad as we initially think. Even if=
=20
we do decide we want a new version, we can at least learn something from th=
e=20
old one.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart6473391.70gAx6cCTY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGlV+2N0y+n1M3mo0RAt52AKDazT9Kg672oHcniZRdZHnfetPGpQCcDT2q
JXn02WQ3JLw0XqG/f1EbYH0=
=oKBX
-----END PGP SIGNATURE-----

--nextPart6473391.70gAx6cCTY--
