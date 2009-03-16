Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbZCPA7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbZCPA7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 20:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZCPA7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 20:59:25 -0400
Received: from ozlabs.org ([203.10.76.45]:49963 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZCPA7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 20:59:24 -0400
Subject: Re: more than 50 percent of dmesg belongs only to PCI and USB
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Greg KH <greg@kroah.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090316003932.GB15098@kroah.com>
References: <1237016485.2935.12.camel@ht.satnam>
	 <1237159729.8619.7.camel@localhost>  <20090316003932.GB15098@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HHvPOaNlcE9UOV5Yfjl+"
Date: Mon, 16 Mar 2009 11:59:21 +1100
Message-Id: <1237165161.8619.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HHvPOaNlcE9UOV5Yfjl+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-15 at 17:39 -0700, Greg KH wrote:
> On Mon, Mar 16, 2009 at 10:28:49AM +1100, Michael Ellerman wrote:
> > On Sat, 2009-03-14 at 13:11 +0530, Jaswinder Singh Rajput wrote:
> > > Can we make dmesg little bit better and remove some noise and put the=
se
> > > debug messages on /sys/kernel/debug/ :
> >=20
> > I think they should just be KERN_DEBUG, that way they won't be displaye=
d
> > to most users, except people who want to see them.
> >=20
> > The problem is it's easier to write:
> >=20
> >   dev_info(&dev->dev, "transparent bridge\n");
> >=20
> > than:
> >=20
> >   dev_printk(KERN_DEBUG, &dev->dev, "transparent bridge\n");
> >=20
> > and, dev_dbg() does not do what you want in this case.
>=20
> Why not?  It prints it out if you enable the config option at run-time,
> which is what you want.

Only if you have CONFIG_DYNAMIC_PRINTK_DEBUG or whatever it's called
enabled. Which is a terrible idea because it compiles-in all the
pr_debug() and dev_dbg() code that used to be if (0)'ed.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-HHvPOaNlcE9UOV5Yfjl+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm9pGkACgkQdSjSd0sB4dJzVQCgljk7dTIKPReWgwQAl1CbKtwJ
4jEAoLQwP2IgQGmvcDrY8rQW0l/aWvFe
=vr/L
-----END PGP SIGNATURE-----

--=-HHvPOaNlcE9UOV5Yfjl+--

