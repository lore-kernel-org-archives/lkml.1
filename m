Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbXHFK52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbXHFK52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbXHFK5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:57:21 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:39551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbXHFK5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:57:20 -0400
Subject: Re: [NFS] 2.6.23-rc1-mm2
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
       Neil Brown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070806105316.GA140@tv-sign.ru>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	 <200708031301.01569.marc.dietrich@ap.physik.uni-giessen.de>
	 <20070803093830.39852a01.akpm@linux-foundation.org>
	 <1186160608.7255.10.camel@localhost> <20070803172137.GA3783@tv-sign.ru>
	 <1186381496.21957.30.camel@johannes.berg> <20070806105316.GA140@tv-sign.ru>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+osbxuci/Lo1oWNOQ/mR"
Date: Mon, 06 Aug 2007 12:58:59 +0200
Message-Id: <1186397939.28655.63.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+osbxuci/Lo1oWNOQ/mR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 14:53 +0400, Oleg Nesterov wrote:

> But this makes ->lockdep_map meaningless? We always take wq->lockdep_map
> for reading, now we can't detect deadlocks.
>=20
> 	read_lock(A);
> 	lock(B);
>=20
> vs
> 	lock(B);
> 	read_lock(A);
>=20
> is valid, kernel/lockdep.c should not complain.

Ah, hmm. Good point, I guess you can always have multiple read locks.
Then we'd have to make a new parameter or such to get rid of the
recursive locking try message. But if you want to deprecate the API
anyway then this is a good way to find it.

johannes

--=-+osbxuci/Lo1oWNOQ/mR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtv7z/ETPhpq3jKURAo+gAKCsL05vlZNHiSAKcS2FRjTg/8Qu1QCeI5ys
O18F7isGXZuHjJQ5aIaacaU=
=agy8
-----END PGP SIGNATURE-----

--=-+osbxuci/Lo1oWNOQ/mR--

