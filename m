Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbYBMWkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbYBMWkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYBMWj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:39:56 -0500
Received: from ozlabs.org ([203.10.76.45]:39882 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbYBMWjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:39:55 -0500
Subject: Re: "ide=reverse" do we still need this?
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Greg KH <greg@kroah.com>, bzolnier@gmail.com, muli@il.ibm.com,
       jdmason@kudzu.us, linux-ide@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
In-Reply-To: <47B2E6AB.1020701@keyaccess.nl>
References: <20080213001506.GA13933@kroah.com>
	 <47B24AB3.3040009@keyaccess.nl> <20080213044436.GB10101@kroah.com>
	 <47B2DD45.7080709@keyaccess.nl> <1202904996.6974.11.camel@concordia>
	 <47B2E6AB.1020701@keyaccess.nl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wUO0dmoPtQA0wamBoBGC"
Date: Thu, 14 Feb 2008 09:39:02 +1100
Message-Id: <1202942342.10139.4.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wUO0dmoPtQA0wamBoBGC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-02-13 at 13:46 +0100, Rene Herman wrote:
> On 13-02-08 13:16, Michael Ellerman wrote:
>=20
> > On Wed, 2008-02-13 at 13:06 +0100, Rene Herman wrote:
> >> On 13-02-08 05:44, Greg KH wrote:
> >>
> >>>> While details escape me somewhat again at the monment, a few months =
ago
> >>>> I was playing around with a PCI Promise IDE controller and needed
> >>>> ide=3Dreverse to save me from having to switch disks around to still=
 have
> >>>> a bootable system.
> >>>>
> >>>> Or some such. Not too clear anymore, but I remember it saved the day=
.
> >>> You couldn't just change the boot disk in grub?
> >>>
> >>> Or use an initramfs and /dev/disk/by-id/ to keep any future moves sta=
ble?
> >> No. The thing is that you need these kinds of hacks while messing with=
 old=20
> >> systems, building and stripping them, often in recovery type of situat=
ions.
> >>
> >> As said (same as the other person I saw reacting) details of what was =
most=20
> >> decidedly needed last time around escape me at the moment, but ide=3Dr=
everse=20
> >> is the kind of hack that saves one hours of unscrewing computer cases =
and=20
> >> switching disks around while building stuff, making quick tests, doing=
=20
> >> recovery...
> >>
> >> If it must go for the greater architectural good, so be it, but it's t=
he=20
> >> type of thing that's used specifically in the situations where you don=
't=20
> >> have stable, well arranged (or known!) setups to begin with.
> >=20
> > I might be off the deep end, but isn't this what
> > Documentation/feature-removal-schedule.txt is for?
>=20
> Documentation/feature-removal-schedule.txt is for asking/discussing wheth=
er=20
> or not features should be removed? No, I don't think so. It seems to be a=
=20
> schedule of when to remove features.

Well it's sort of both I think. It's a schedule, but if enough people
complain that something's being removed then it can be reconsidered
before it's removed.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-wUO0dmoPtQA0wamBoBGC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHs3GGdSjSd0sB4dIRAs6iAJoCpWQgooMGQnHy5Yl/H4J3TIH5owCffS5+
WchTHq4UcCio/J8f6RjaA4w=
=m+/o
-----END PGP SIGNATURE-----

--=-wUO0dmoPtQA0wamBoBGC--

