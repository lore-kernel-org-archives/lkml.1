Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbZDMUMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbZDMUMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZDMUL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:11:57 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:50279 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZDMUL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:11:56 -0400
Subject: Re: [patch 0/6] x86, PAT, CPA: Cleanups and minor bug fixes
From: Eric Anholt <eric@anholt.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: venkatesh.pallipadi@intel.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <20090411070035.GB11799@elte.hu>
References: <20090409212646.511925000@intel.com>
	 <1239396112.6356.10.camel@gaiman.anholt.net>
	 <20090411070035.GB11799@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FtED2Ze3nN5mkhQKO69M"
Date: Mon, 13 Apr 2009 13:11:52 -0700
Message-Id: <1239653512.29473.74.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FtED2Ze3nN5mkhQKO69M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-11 at 09:00 +0200, Ingo Molnar wrote:
> * Eric Anholt <eric@anholt.net> wrote:
>=20
> > On Thu, 2009-04-09 at 14:26 -0700, venkatesh.pallipadi@intel.com wrote:
> > > This patchset contains cleanups and minor bug fixes in x86 PAT and CP=
A
> > > related code. The bugs were mostly found by code inspection. There
> > > should not be any functionality changes with this patchset.
> >=20
> > I've been curious, what are you using to test PAT changes for=20
> > regressions?  I've got some regression tests at:
> >=20
> > http://cgit.freedesktop.org/xorg/app/intel-gpu-tools/
> >=20
> > Requires KMS enabled and master of libdrm, but after that you can=20
> > sudo make check, and it tests execution of several DRM paths=20
> > without requiring X.  In benchmarks/ there are a few=20
> > microbenchmarks of various mapping types, which has been useful in=20
> > making sure that we're ending up with the right PTEs.
>=20
> Looks really nice! Regarding libdrm, is there a version cutoff from=20
> where it is expected to work just fine? I've got this version:=20
> libdrm-2.4.6-3.fc11.x86_64.

I should keep the pkgconfig check up to date, but in the worst case it
doesn't compile and you go get new libdrm.  The 2.4.6 check right now
appears to be correct.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-FtED2Ze3nN5mkhQKO69M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknjnIgACgkQHUdvYGzw6vf1nwCeLT4L0Yez23/26h2tT24GKYj0
bCgAnAtUeYWoyyxjkqOiziU29Q2+jfDh
=cJzO
-----END PGP SIGNATURE-----

--=-FtED2Ze3nN5mkhQKO69M--
