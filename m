Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbXEYFOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbXEYFOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbXEYFOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:14:15 -0400
Received: from ozlabs.org ([203.10.76.45]:38471 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbXEYFOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:14:14 -0400
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, David Miller <davem@davemloft.net>,
       Tony Luck <tony.luck@intel.com>
In-Reply-To: <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org>
	 <m1mz09p1t7.fsf@ebiederm.dsl.xmission.com>
	 <20070513014622.c5702928.akpm@linux-foundation.org>
	 <46470209.9000502@bellsouth.net> <46470515.50000@NineX.eu.org>
	 <464707F7.6080600@bellsouth.net> <m1irawpwy2.fsf@ebiederm.dsl.xmission.com>
	 <20070513204407.7ba35010@osprey.hogchain.net>
	 <4647FA38.3090108@NineX.eu.org> <46480EA5.40400@NineX.eu.org>
	 <20070514053406.478bf93f@osprey.hogchain.net>
	 <m1d513oddj.fsf@ebiederm.dsl.xmission.com>
	 <20070514093829.377e04bc@osprey.hogchain.net>
	 <m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>
	 <20070514160005.627435e3@osprey.hogchain.net>
	 <m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	 <20070515212200.517fcba2@osprey.hogchain.net>
	 <m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	 <20070516185225.3f3ac082@osprey.hogchain.net>
	 <m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	 <20070522204103.134bf5a2@osprey.hogchain.net>
	 <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mVyzzfotcJ1AsaZQXrOx"
Date: Fri, 25 May 2007 15:14:10 +1000
Message-Id: <1180070050.8203.30.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mVyzzfotcJ1AsaZQXrOx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-05-24 at 22:19 -0600, Eric W. Biederman wrote:
> Currently we blacklist known bad msi configurations which means we
> keep getting MSI enabled on chipsets that either do not support MSI,
> or MSI is implemented improperly.  Since the normal IRQ routing
> mechanism seems to works even when MSI does not, this is a bad default
> and causes non-functioning systems for no good reason.
>=20
> So this patch inverts the sense of the MSI bus flag to only enable
> MSI on known good systems.  I am seeding that list with the set of
> chipsets with an enabled hypertransport MSI mapping capability.  Which
> is as close as I can come to an generic MSI enable.  So for actually
> using MSI this patch is a regression, but for just having MSI enabled
> in the kernel by default things should just work with this patch
> applied.

I guess this is a good idea for random x86 machines. On powerpc I think
we'll just turn it on for every bus, and let the existing per-platform
logic decide.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-mVyzzfotcJ1AsaZQXrOx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGVnCidSjSd0sB4dIRAgb9AJkBJhLY1j8i+6rDcmDk9yzIDg/6IwCgnBBF
/8JmNjOJsUHJLtZyOHsqEzo=
=S3O6
-----END PGP SIGNATURE-----

--=-mVyzzfotcJ1AsaZQXrOx--

