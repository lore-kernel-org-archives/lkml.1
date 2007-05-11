Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbXEKH6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbXEKH6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbXEKH6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:58:12 -0400
Received: from ozlabs.org ([203.10.76.45]:44818 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXEKH6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:58:12 -0400
Subject: Re: [PATCH] update sysfs kset initialisation in PPC64 DLPAR IO
	driver
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Greg KH <gregkh@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20070511071606.GB1211@suse.de>
References: <464322F3.3010808@shadowen.org>
	 <2c705c055fcd12202673ee8a3056153b@pinky> <20070510141221.GA26709@suse.de>
	 <46434041.7020903@shadowen.org>  <20070511071606.GB1211@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9fM6HOSO93kqWbFKOdcv"
Date: Fri, 11 May 2007 17:58:09 +1000
Message-Id: <1178870289.3923.6.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9fM6HOSO93kqWbFKOdcv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-11 at 00:16 -0700, Greg KH wrote:
> On Thu, May 10, 2007 at 04:54:41PM +0100, Andy Whitcroft wrote:
> > Greg KH wrote:
> > > On Thu, May 10, 2007 at 03:00:50PM +0100, Andy Whitcroft wrote:
> > >> Move the rpadlpar device from "struct subsystem" to "struct kset"
> > >> following the changes in sysfs.
> > >>
> > >> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> > >> ---
> > >>
> > >> 	Ok, this patch seems to sort out the compile problem
> > >> 	here and indeed boots and runs kernbench.  Perhaps
> > >> 	you could confirm this is sufficient.
> > >=20
> > > As per the discussion on the pci hotplug list, no, this doesn't seem =
to
> > > fix the problem.  The developers there are looking into it.  If you c=
an
> > > test out patches for this, I'm sure the people there would appreciate
> > > the help.
> >=20
> > Sure anything they have for testing, send them to me ...
>=20
> They have the same patch that you made (I made it), yet they reported
> that it didn't work properly for them.
>=20
> Can you test your patch out on "real" hardware?

I tested it on real hardware, but it can't hurt for Andy to try it too I
guess.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-9fM6HOSO93kqWbFKOdcv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGRCIRdSjSd0sB4dIRAhwWAKCW3P81yq8niHMm4c1WlXH9SQNilwCgyCy+
GEAmYifw9pFkVV7fw1MkA0Y=
=mESi
-----END PGP SIGNATURE-----

--=-9fM6HOSO93kqWbFKOdcv--

