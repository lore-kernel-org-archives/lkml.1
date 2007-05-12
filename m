Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbXELCR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbXELCR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 22:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXELCRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 22:17:21 -0400
Received: from ozlabs.org ([203.10.76.45]:37643 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbXELCRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 22:17:21 -0400
Subject: Re: [PATCH] update sysfs kset initialisation in PPC64 DLPAR
	IO	driver
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Andy Whitcroft <apw@shadowen.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       John Rose <johnrose@austin.ibm.com>
In-Reply-To: <46444820.2020506@shadowen.org>
References: <464322F3.3010808@shadowen.org>
	 <2c705c055fcd12202673ee8a3056153b@pinky> <20070510141221.GA26709@suse.de>
	 <46434041.7020903@shadowen.org>  <20070511071606.GB1211@suse.de>
	 <1178870289.3923.6.camel@concordia.ozlabs.ibm.com>
	 <46444820.2020506@shadowen.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-26c7D453DuUsQEZRVb3+"
Date: Sat, 12 May 2007 12:17:18 +1000
Message-Id: <1178936238.10759.8.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-26c7D453DuUsQEZRVb3+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-11 at 11:40 +0100, Andy Whitcroft wrote:
> Michael Ellerman wrote:
> > On Fri, 2007-05-11 at 00:16 -0700, Greg KH wrote:
> >> On Thu, May 10, 2007 at 04:54:41PM +0100, Andy Whitcroft wrote:
> >>> Greg KH wrote:
> >>>> On Thu, May 10, 2007 at 03:00:50PM +0100, Andy Whitcroft wrote:
> >>>>> Move the rpadlpar device from "struct subsystem" to "struct kset"
> >>>>> following the changes in sysfs.
> >>>>>
> >>>>> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> >>>>> ---
> >>>>>
> >>>>> 	Ok, this patch seems to sort out the compile problem
> >>>>> 	here and indeed boots and runs kernbench.  Perhaps
> >>>>> 	you could confirm this is sufficient.
> >>>> As per the discussion on the pci hotplug list, no, this doesn't seem=
 to
> >>>> fix the problem.  The developers there are looking into it.  If you =
can
> >>>> test out patches for this, I'm sure the people there would appreciat=
e
> >>>> the help.
> >>> Sure anything they have for testing, send them to me ...
> >> They have the same patch that you made (I made it), yet they reported
> >> that it didn't work properly for them.
> >>
> >> Can you test your patch out on "real" hardware?
> >=20
> > I tested it on real hardware, but it can't hurt for Andy to try it too =
I
> > guess.
>=20
> To be fair I am not sure I have a clue how to test it.  Got a recipe?
> My patch was based on how other drivers seemed to be converted which is
> a concern for those drivers.
>=20
> What sort of failure do you see?

Prior to the removal of struct subysystem I get two files called
'add_slot' and 'remove_slot' under /sys/bus/pci/slots/control.

With Greg's patch I get the directory /sys/bus/pci/slots/control, but
nothing under it.=20

Apparently John Rose is looking into it.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-26c7D453DuUsQEZRVb3+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGRSOudSjSd0sB4dIRAif0AJ45jsoALr5aPHK9T+9D4FFrIDQfrQCdHl1z
11KoCIVArGZQuLdn0rzYSig=
=pphh
-----END PGP SIGNATURE-----

--=-26c7D453DuUsQEZRVb3+--

