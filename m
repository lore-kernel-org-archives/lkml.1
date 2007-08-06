Return-Path: <linux-kernel-owner+w=401wt.eu-S1764525AbXHFLMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764525AbXHFLMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbXHFLMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:12:46 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:53288 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbXHFLMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:12:45 -0400
Subject: Re: [NFS] 2.6.23-rc1-mm2
From: Johannes Berg <johannes@sipsolutions.net>
To: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <200708061305.37208.marc.dietrich@ap.physik.uni-giessen.de>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	 <20070803172137.GA3783@tv-sign.ru>
	 <1186381496.21957.30.camel@johannes.berg>
	 <200708061305.37208.marc.dietrich@ap.physik.uni-giessen.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EY70lVrxONX/dTFlTmB3"
Date: Mon, 06 Aug 2007 13:13:36 +0200
Message-Id: <1186398816.28655.66.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EY70lVrxONX/dTFlTmB3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 13:05 +0200, Marc Dietrich wrote:

> I applied the patch, but now I get:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: inconsistent lock state ]
> 2.6.23-rc1-mm2 #4
> ---------------------------------
> inconsistent {softirq-on-W} -> {in-softirq-W} usage.
> swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
>  (rpc_credcache_lock){-+..}, at: [<c01dc487>] _atomic_dec_and_lock+0x17/0=
x60

Interesting, but doesn't seem related to this at all. As Oleg just
pointed out this basically disabled checking for workqueue stuff so this
should be looked into by somebody familiar with the NFS code.

johannes

--=-EY70lVrxONX/dTFlTmB3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtwJg/ETPhpq3jKURAs8eAKCfqd2K4uQ2FhrG4yTHm20CxFKPbQCfRhfA
WgDX3oGozsIV/5PBYEIz1FM=
=A/da
-----END PGP SIGNATURE-----

--=-EY70lVrxONX/dTFlTmB3--

