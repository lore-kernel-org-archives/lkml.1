Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbXJaKnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbXJaKnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbXJaKms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:42:48 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:31204 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754988AbXJaKmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:42:46 -0400
Subject: Re: [PATCH 05/33] mm: kmem_estimate_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
In-Reply-To: <200710311443.18143.nickpiggin@yahoo.com.au>
References: <20071030160401.296770000@chello.nl>
	 <20071030160911.281698000@chello.nl>
	 <200710311443.18143.nickpiggin@yahoo.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-B/evvxB9qIXk4AH3ka2B"
Date: Wed, 31 Oct 2007 11:42:38 +0100
Message-Id: <1193827358.27652.128.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B/evvxB9qIXk4AH3ka2B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-31 at 14:43 +1100, Nick Piggin wrote:
> On Wednesday 31 October 2007 03:04, Peter Zijlstra wrote:
> > Provide a method to get the upper bound on the pages needed to allocate
> > a given number of objects from a given kmem_cache.
> >
>=20
> Fair enough, but just to make it a bit easier, can you provide a
> little reason of why in this patch (or reference the patch number
> where you use it, or put it together with the patch where you use
> it, etc.).

A generic reserve framework, as seen in patch 11/23, needs to be able
convert from a object demand (kmalloc() bytes, kmem_cache_alloc()
objects) to a page reserve.


--=-B/evvxB9qIXk4AH3ka2B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHKFweXA2jU0ANEf4RAg3yAJ40xHIOL90VMpb0RQnEM1N4VoRmRgCfUuHc
jGUE2pI/amo9+MDzmA9+R3k=
=lGAV
-----END PGP SIGNATURE-----

--=-B/evvxB9qIXk4AH3ka2B--

