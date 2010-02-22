Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0BVLsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 06:48:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59463 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab0BVLsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 06:48:01 -0500
Date: Mon, 22 Feb 2010 22:47:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, linux-tip-commits@vger.kernel.org
Subject: Re: linux-next requirements (Was: Re: [tip:x86/ptrace] ptrace: Add
 support for generic PTRACE_GETREGSET/PTRACE_SETREGSET)
Message-Id: <20100222224752.0cbd5807.sfr@canb.auug.org.au>
In-Reply-To: <20100222102745.GJ20844@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
	<tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
	<20100222090710.GA31357@elte.hu>
	<20100222203319.8bd497a2.sfr@canb.auug.org.au>
	<20100222102745.GJ20844@elte.hu>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Feb_2010_22_47_52_+1100_V8btWHwOiZxVCGHT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Feb_2010_22_47_52_+1100_V8btWHwOiZxVCGHT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Mon, 22 Feb 2010 11:27:45 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > On Mon, 22 Feb 2010 10:07:10 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > I'll keep them in tip:master to get them tested, but note that i cann=
ot=20
> > > push any of these patches into linux-next until this is fixed, as=20
> > > linux-next requires all architectures to build, with no regard to whi=
ch=20
> > > architectures are tested by kernel testers in practice.
> >=20
> > I merely expect people not to push known broken code into linux-next.
>=20
> FYI, this 'mere' kind of indiscriminate definition of 'breakage' is what =
i am=20
> talking about.

OK, let me remove "merely" from this.

I expect people not to push known broken code into linux-next.  Code in
linux-next is meant to be as ready as possible to be sent to Linus.  If
you know that it breaks some architecture then it should obviously be
fixed some how (unless the architecture maintainer really doesn't care,
of course).

This is different from not knowing that it breaks some architecture even
though you have done reasonable testing.

> The occasional driver build breakage can be tested relatively easily: one=
=20
> allyesconfig build and it's done. Build testing 22 architectures is=20
> exponentially harder: it requires the setup (and constant maintenance) of=
=20
> zillions of tool-chains, plus the build time is significant as well.
>=20
> So this kind of linux-next requirement causes the over-testing of code th=
at=20
> doesnt get all that much active usage, plus it increases build testing=20
> overhead 10-fold. That, by definition, causes the under-testing of code t=
hat=20
> _does_ matter a whole lot more to active testers of the Linux kernel.

Which is why linux-next does *not* require that. (Did you read the part
of my email that you removed?)  I do point out when build failures occur
(that is part of the point of linux-next after all) but they only upset
me when it is clear that the code that has been changed was not built at
all (which doesn't happen too often).
=20
> Which is a problem, obviously.

It certainly would be.

Maybe I don't understand what you are trying to say.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Feb_2010_22_47_52_+1100_V8btWHwOiZxVCGHT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuCbugACgkQjjKRsyhoI8wddgCgkTLE4NngSRHwP6Tkg0fw3DrR
igkAoJxnHuDPvS2/XAtF5gcaqGIu2ak7
=HcvW
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Feb_2010_22_47_52_+1100_V8btWHwOiZxVCGHT--
