Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbZIXNZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbZIXNZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZIXNZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:25:53 -0400
Received: from ozlabs.org ([203.10.76.45]:50789 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZIXNZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:25:53 -0400
Subject: Re: [PATCH] perf_event, powerpc: Fix compilation after big
 perf_counter rename
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20090924121423.GB12262@elte.hu>
References: <19128.4280.813369.589704@cargo.ozlabs.ibm.com>
	 <1253584591.7103.197.camel@pasglop> <20090922072834.GA25470@elte.hu>
	 <1253606415.7103.216.camel@pasglop> <1253620332.10476.4.camel@concordia>
	 <20090923124420.GA5525@elte.hu> <1253747995.6110.5.camel@concordia>
	 <20090924121423.GB12262@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AbA2JgGiCoPU2uu02jdr"
Date: Thu, 24 Sep 2009 23:25:55 +1000
Message-Id: <1253798755.16237.4.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AbA2JgGiCoPU2uu02jdr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 14:14 +0200, Ingo Molnar wrote:
> * Michael Ellerman <michael@ellerman.id.au> wrote:
>=20
> > On Wed, 2009-09-23 at 14:44 +0200, Ingo Molnar wrote:
> > > * Michael Ellerman <michael@ellerman.id.au> wrote:
> > >=20
> > > > On Tue, 2009-09-22 at 18:00 +1000, Benjamin Herrenschmidt wrote:
> > > > > On Tue, 2009-09-22 at 09:28 +0200, Ingo Molnar wrote:
> > > > > >=20
> > > > > > Nevertheless you are right that i should have caught this parti=
cular=20
> > > > > > PowerPC build bug - i missed it - sorry about that!
> > > > > >=20
> > > > > Allright. Well, to help in general, we are setting up a build-bot
> > > > > here too that will build -tip HEAD for at least powerpc daily wit=
h
> > > > > a few configs too.
> > > >=20
> > > > Results here:
> > > >=20
> > > > http://kisskb.ellerman.id.au/kisskb/branch/12/
> > >=20
> > > ok, seems green for today - the two failures are: one a powerpc=20
> > > toolchain problem it appears, plus a mainline warning.
> >=20
> > Yep that looks more or less normal.
> >=20
> > > Btw., for me to be able to notice failures there it would have to=20
> > > email me automatically if there's any -tip build failures that do=20
> > > not occur with the upstream branch. Does it have such a feature?
> >=20
> > Not really, it sends mails to me, but it doesn't have a way to filter=20
> > them by branch. I think the plan is we'll keep an eye on it and either=20
> > send you patches or at least let you know that it's broken.
>=20
> how many mails are those per day, typically? If there's not too many and=20
> if there's a way to send all of them to me i could post-filter them for=20
> -tip relevance. If that is feasible. You bouncing it to me later is=20
> certainly also a solution. (but lengthens the latency of fixes,=20
> obviously.)

Lots of mails - there are an insane number of arm configs for
starters :)

Give me a day or two, I should be able to add a per-branch setting for
who to send mails to without too much trouble.

cheers

--=-AbA2JgGiCoPU2uu02jdr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq7c2AACgkQdSjSd0sB4dI5ZwCgu1nBGxzUdssbydSkZDA00d3Y
JxoAoJ0M2g9oyXqi3BwPTK3hJ0lcmqkv
=loTI
-----END PGP SIGNATURE-----

--=-AbA2JgGiCoPU2uu02jdr--

