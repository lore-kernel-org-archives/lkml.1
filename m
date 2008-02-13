Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYBMMQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYBMMQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYBMMQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:16:39 -0500
Received: from ozlabs.org ([203.10.76.45]:59163 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbYBMMQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:16:38 -0500
Subject: Re: "ide=reverse" do we still need this?
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Greg KH <greg@kroah.com>, bzolnier@gmail.com, muli@il.ibm.com,
       jdmason@kudzu.us, linux-ide@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
In-Reply-To: <47B2DD45.7080709@keyaccess.nl>
References: <20080213001506.GA13933@kroah.com>
	 <47B24AB3.3040009@keyaccess.nl> <20080213044436.GB10101@kroah.com>
	 <47B2DD45.7080709@keyaccess.nl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GSV2L6sa3QZTlXkXtIBS"
Date: Wed, 13 Feb 2008 23:16:36 +1100
Message-Id: <1202904996.6974.11.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GSV2L6sa3QZTlXkXtIBS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-02-13 at 13:06 +0100, Rene Herman wrote:
> On 13-02-08 05:44, Greg KH wrote:
>=20
> >> While details escape me somewhat again at the monment, a few months ag=
o
> >> I was playing around with a PCI Promise IDE controller and needed
> >> ide=3Dreverse to save me from having to switch disks around to still h=
ave
> >> a bootable system.
> >>=20
> >> Or some such. Not too clear anymore, but I remember it saved the day.
> >=20
> > You couldn't just change the boot disk in grub?
> >=20
> > Or use an initramfs and /dev/disk/by-id/ to keep any future moves stabl=
e?
>=20
> No. The thing is that you need these kinds of hacks while messing with ol=
d=20
> systems, building and stripping them, often in recovery type of situation=
s.
>=20
> As said (same as the other person I saw reacting) details of what was mos=
t=20
> decidedly needed last time around escape me at the moment, but ide=3Dreve=
rse=20
> is the kind of hack that saves one hours of unscrewing computer cases and=
=20
> switching disks around while building stuff, making quick tests, doing=20
> recovery...
>=20
> If it must go for the greater architectural good, so be it, but it's the=20
> type of thing that's used specifically in the situations where you don't=20
> have stable, well arranged (or known!) setups to begin with.

I might be off the deep end, but isn't this what
Documentation/feature-removal-schedule.txt is for?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-GSV2L6sa3QZTlXkXtIBS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHst+kdSjSd0sB4dIRAtheAJ9/B8k6pd1scVRvHog5WAywyZHjsACfXnoV
I5haLvFUBjf1iqThCYnZYzs=
=Hv7S
-----END PGP SIGNATURE-----

--=-GSV2L6sa3QZTlXkXtIBS--

