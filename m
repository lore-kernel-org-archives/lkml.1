Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbYBDXa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbYBDXa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYBDXaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:30:21 -0500
Received: from ozlabs.org ([203.10.76.45]:55283 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbYBDXaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:30:18 -0500
Subject: Re: Commit for mm/page_alloc.c breaks boot process on my machine
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Gerhard Pircher <gerhard_pircher@gmx.net>
Cc: Mel Gorman <mel@csn.ul.ie>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080204222047.243670@gmx.net>
References: <20080201184254.174020@gmx.net>
	 <20080201191119.GI18688@csn.ul.ie> <20080201200518.174050@gmx.net>
	 <20080201202518.GJ18688@csn.ul.ie> <20080201210656.174030@gmx.net>
	 <20080204104232.GB29484@csn.ul.ie>  <20080204222047.243670@gmx.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1AXqJ/0d1vMyoWOf4omx"
Date: Tue, 05 Feb 2008 10:30:16 +1100
Message-Id: <1202167816.7672.18.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1AXqJ/0d1vMyoWOf4omx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-02-04 at 23:20 +0100, Gerhard Pircher wrote:
> -------- Original-Nachricht --------
> > Datum: Mon, 4 Feb 2008 10:42:32 +0000
> > Von: Mel Gorman <mel@csn.ul.ie>
> > An: Gerhard Pircher <gerhard_pircher@gmx.net>
> > CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
> > Betreff: Re: Commit for mm/page_alloc.c breaks boot process on my machi=
ne
>=20
> > > > > > 2. Any chance of seeing a dmesg log?
> > > > > That's a little bit of a problem. The kernel log in memory doesn'=
t
> > > > > show any kernel oops, but is also fragmented (small fragments see=
m
> > > > > to have been overwritten with 0x0).
> > > >=20
> > > > err, that doesn't sound very healthy.
> > >
> > > Yeah, I know. But the platform code hasn't changed much when porting =
it
> > > from arch/ppc to arch/powerpc. That's why I'm a little bit lost in th=
is
> > > case. :-)
> > >=20
> >=20
> > I'm at a bit of a loss to guess what might have changed in powerpc code
> > that would explain this. I've added the linuxppc-dev mailing list in
> > case they can make a guess.
> Yes, I'll try to get some comments on the linuxppc-dev mailing list.
>=20
> > I think you are also going to need to start bisecting searching
> > specifically for the patch that causes these overwrites.
> I think I had a similar problem with kernel v2.6.23, too and therefore
> waited for kernel 2.6.24. So the problem may exist since a long time.
>=20
> > It's a virtual address so it depends on the value of CONFIG_KERNEL_STAR=
T
> > as to whether this is a user program address or not.
> AFAIK start_kernel() is called very early in the boot process, were no
> user or kernel thread is active. I also wonder why the kernel crashes whe=
n
> the mem boot option is used. Let's see what the linuxppc-dev people say.

Can you post a fresh bug report? There's lots of details missing from
the email you forwarded.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-1AXqJ/0d1vMyoWOf4omx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHp6AIdSjSd0sB4dIRAkNOAJ4l9wltKBymwt8bkEeYv2VtTzhzZQCfZCl/
20w/qrzLOAGEUKD43gfUGaM=
=Vg5n
-----END PGP SIGNATURE-----

--=-1AXqJ/0d1vMyoWOf4omx--

