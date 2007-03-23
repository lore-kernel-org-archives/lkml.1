Return-Path: <linux-kernel-owner+w=401wt.eu-S933543AbXCWERj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbXCWERj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 00:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933463AbXCWERj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 00:17:39 -0400
Received: from ozlabs.org ([203.10.76.45]:49454 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933543AbXCWERi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 00:17:38 -0400
Subject: Re: [PATCH 0/21] MSI rework
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, daniel.e.wolstenholme@intel.com
In-Reply-To: <20070322220837.GD20713@kroah.com>
References: <1174560686.307511.956605711793.qpush@cradle>
	 <m1lkhp8gqx.fsf@ebiederm.dsl.xmission.com>
	 <20070322190834.GA14802@kroah.com>
	 <1174600936.10836.53.camel@localhost.localdomain>
	 <20070322220837.GD20713@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qcFmlYradbrcybATOf4J"
Date: Fri, 23 Mar 2007 15:17:23 +1100
Message-Id: <1174623443.5401.21.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qcFmlYradbrcybATOf4J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-22 at 15:08 -0700, Greg KH wrote:
> On Fri, Mar 23, 2007 at 09:02:16AM +1100, Benjamin Herrenschmidt wrote:
> > > > i.e.  First the simple bug fixes that should purely be restructure =
of
> > > > msi.c with no affect on anything outside of it.
> > > >=20
> > > > And then get into the architecture enhancements.
> > >=20
> > > I agree, care to break these down into a smaller series of patches th=
at
> > > can go into -mm for testing?
> >=20
> > I don't see the point in breaking the serie... you can bisect half way
> > through if necessary... it's made of small patches that are done, afaik=
,
> > in such a way that the whole thing should still work at any level in th=
e
> > serie.
> >=20
> > The serie just expresses the dependency between them.
>=20
> Ok, then which patches in the series should be acceptable to take right
> now for 2.6.22?  The "clean up the BUG" ones?

The series is already very verbose, I don't think I can split most of
them any smaller without producing an unbuildable kernel.

I think 1 up to and including 11 are safe as houses, they shouldn't have
any effect other than to clean up the code.

The rest make functional changes, but they're all quite small, self
contained, and easily bisectable. I'd certainly like Eric to have a look
at them, but at some point I think we're just going to have to bite the
bullet and merge them, and see what we get in the way of bug reports.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-qcFmlYradbrcybATOf4J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGA1TTdSjSd0sB4dIRApgeAKC3XIW28ZOuctyNk6Z7TZ0OpadwUwCeMT37
tCqD8CJV7yNHpGF0PvSI0p4=
=qPKe
-----END PGP SIGNATURE-----

--=-qcFmlYradbrcybATOf4J--

