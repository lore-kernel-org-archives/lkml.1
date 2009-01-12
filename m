Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZALJuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZALJuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 04:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbZALJuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 04:50:04 -0500
Received: from ozlabs.org ([203.10.76.45]:35422 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbZALJuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:50:02 -0500
Subject: Re: linux-next: origin tree build failure
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>,
       linuxppc-dev@ozlabs.org, linux-next@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20090112090552.GD26750@elte.hu>
References: <20090112104837.69feedec.sfr@canb.auug.org.au>
	 <1231719015.22571.4.camel@pasglop>  <20090112090552.GD26750@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fMSAHM2yExMWsU+/H95c"
Date: Mon, 12 Jan 2009 20:49:51 +1100
Message-Id: <1231753791.8959.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fMSAHM2yExMWsU+/H95c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-12 at 10:05 +0100, Ingo Molnar wrote:
> * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>=20
> > On Mon, 2009-01-12 at 10:48 +1100, Stephen Rothwell wrote:
> > > Hi Linus,
> > >=20
> > > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> > >=20
> > > arch/powerpc/platforms/pasemi/cpufreq.c: In function 'pas_cpufreq_cpu=
_init':
> > > arch/powerpc/platforms/pasemi/cpufreq.c:216: error: incompatible type=
s in assignment
> > > arch/powerpc/platforms/powermac/cpufreq_64.c: In function 'g5_cpufreq=
_cpu_init':
> > > arch/powerpc/platforms/powermac/cpufreq_64.c:365: error: incompatible=
 types in assignment
> > > arch/powerpc/platforms/cell/cbe_cpufreq.c: In function 'cbe_cpufreq_c=
pu_init':
> > > arch/powerpc/platforms/cell/cbe_cpufreq.c:121: error: incompatible ty=
pes in assignment
> > >=20
> > > Caused by commit 835481d9bcd65720b473db6b38746a74a3964218 ("cpumask:
> > > convert struct cpufreq_policy to cpumask_var_t") which missed updatin=
g
> > > all the powerpc (at least) cpufreq drivers.
> >=20
> > Yeah, it only updates x86 it seems ...=20
>=20
> Yeah - and that build bug was stupid too - when touching a generic file=20
> that is called include/linux/cpufreq.h and changing a key data field one=20
> should at minimum get the idea that it's generic for a reason and should=20
> start grepping the tree ...
>=20
> It slipped through because it didnt get caught in build tests because=20
> cpufreq isnt enabled in the powerpc defconfig.

Which defconfig?

powerpc(master) $ git grep CPU_FREQ=3Dy arch/powerpc/configs/ppc64_defconfi=
g
arch/powerpc/configs/ppc64_defconfig:CONFIG_CPU_FREQ=3Dy

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-fMSAHM2yExMWsU+/H95c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklrEj8ACgkQdSjSd0sB4dI1sQCeNse/NW8O16+C2QED0qb2owYq
fLQAnjZ8C9w39aprGODx0/e2TVMvIZPB
=B0P8
-----END PGP SIGNATURE-----

--=-fMSAHM2yExMWsU+/H95c--

