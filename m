Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbXCZHJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbXCZHJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 03:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932162AbXCZHJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 03:09:55 -0400
Received: from ozlabs.org ([203.10.76.45]:53791 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbXCZHJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 03:09:53 -0400
Subject: Re: [PATCH 0/21] MSI rework
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, daniel.e.wolstenholme@intel.com
In-Reply-To: <m1ps705ka1.fsf@ebiederm.dsl.xmission.com>
References: <1174560686.307511.956605711793.qpush@cradle>
	 <m1lkhp8gqx.fsf@ebiederm.dsl.xmission.com>
	 <20070322190834.GA14802@kroah.com>
	 <1174600936.10836.53.camel@localhost.localdomain>
	 <20070322220837.GD20713@kroah.com>
	 <1174623443.5401.21.camel@concordia.ozlabs.ibm.com>
	 <m1ps705ka1.fsf@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hcePlDmgFxpYcRg7jq5f"
Date: Mon, 26 Mar 2007 17:09:51 +1000
Message-Id: <1174892991.4782.11.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hcePlDmgFxpYcRg7jq5f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-23 at 04:25 -0600, Eric W. Biederman wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>=20
> > On Thu, 2007-03-22 at 15:08 -0700, Greg KH wrote:
> >> On Fri, Mar 23, 2007 at 09:02:16AM +1100, Benjamin Herrenschmidt wrote=
:
> >> > > > i.e.  First the simple bug fixes that should purely be restructu=
re of
> >> > > > msi.c with no affect on anything outside of it.
> >> > > >=20
> >> > > > And then get into the architecture enhancements.
> >> > >=20
> >> > > I agree, care to break these down into a smaller series of patches=
 that
> >> > > can go into -mm for testing?
> >> >=20
> >> > I don't see the point in breaking the serie... you can bisect half w=
ay
> >> > through if necessary... it's made of small patches that are done, af=
aik,
> >> > in such a way that the whole thing should still work at any level in=
 the
> >> > serie.
> >> >=20
> >> > The serie just expresses the dependency between them.
> >>=20
> >> Ok, then which patches in the series should be acceptable to take righ=
t
> >> now for 2.6.22?  The "clean up the BUG" ones?
> >
> > The series is already very verbose, I don't think I can split most of
> > them any smaller without producing an unbuildable kernel.
>=20
> That wasn't the request.
>=20
> > I think 1 up to and including 11 are safe as houses, they shouldn't hav=
e
> > any effect other than to clean up the code.
> >
> > The rest make functional changes, but they're all quite small, self
> > contained, and easily bisectable. I'd certainly like Eric to have a loo=
k
> > at them, but at some point I think we're just going to have to bite the
> > bullet and merge them, and see what we get in the way of bug reports.
>=20
> What I wanted was the patches organized into functional groups that
> were small enough to review as a unit.  (Feed the existing patches slower
> please).
>=20
> This seems to be to much change to read and review as a unit, I just get
> bleary eyed, and start to get confused.
>=20
> So far I have found one subtle bug.  Where admittedly my code wasn't as
> obvious as it could be and you were proposing to use an irq that had alre=
ady
> been freed.
>=20
> What I had hoped we can do is you would send a handful at a time I
> would review them.  Then we could get the next handful.  I expect
> doing it that way it should take about a week to get through them all.
>=20
> I guess I can try going through the review that way as well.  Pick a
> subset of what you have sent and review it very carefully, and the
> next day pick a different subset. =20

OK. For starters, do you want to review the first eleven as I've sent
them already, that saves spamming everyone again.

If you're OK with those eleven, then I'll send the remaining 10 or so
later in the week, broken up into (sort-of) functional groups.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-hcePlDmgFxpYcRg7jq5f
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGB3G/dSjSd0sB4dIRAveRAKDCLbkDi09Y35OUh8KpZ4e/onlspACgo8Z6
wG+WllIcbAuIhT9LT0mdPyQ=
=3tPp
-----END PGP SIGNATURE-----

--=-hcePlDmgFxpYcRg7jq5f--

