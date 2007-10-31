Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbXJaMyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbXJaMyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 08:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbXJaMyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 08:54:24 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:10704 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbXJaMyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 08:54:23 -0400
Subject: Re: [PATCH 03/33] mm: slub: add knowledge of reserve pages
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
In-Reply-To: <200710312225.07249.nickpiggin@yahoo.com.au>
References: <20071030160401.296770000@chello.nl>
	 <200710312146.03351.nickpiggin@yahoo.com.au>
	 <1193833072.27652.167.camel@twins>
	 <200710312225.07249.nickpiggin@yahoo.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1JONk1CHaR7M71QTq2Rs"
Date: Wed, 31 Oct 2007 13:54:18 +0100
Message-Id: <1193835258.27652.199.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1JONk1CHaR7M71QTq2Rs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-31 at 22:25 +1100, Nick Piggin wrote:
> On Wednesday 31 October 2007 23:17, Peter Zijlstra wrote:
> > On Wed, 2007-10-31 at 21:46 +1100, Nick Piggin wrote:
>=20
> > > And I'd prevent these ones from doing so.
> > >
> > > Without keeping track of "reserve" pages, which doesn't feel
> > > too clean.
> >
> > The problem with that is that once a slab was allocated with the right
> > allocation context, anybody can get objects from these slabs.
>=20
> [snip]
>=20
> I understand that.
>=20
>=20
> > So we either reserve a page per object, which for 32 byte objects is a
> > large waste, or we stop anybody who doesn't have the right permissions
> > from obtaining objects. I took the latter approach.
>=20
> What I'm saying is that the slab allocator slowpath should always
> just check watermarks against the current task. Instead of this
> ->reserve stuff.

So what you say is to allocate a slab every time we take the slow path,
even when we already have one?

That sounds rather sub-optimal.

--=-1JONk1CHaR7M71QTq2Rs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHKHr6XA2jU0ANEf4RAm9gAJ9xM3miH4H0KzYn+MEPjt6I1zY3swCdEN3/
FchO1Oe5ngFrcknUFRAg2jQ=
=2VhI
-----END PGP SIGNATURE-----

--=-1JONk1CHaR7M71QTq2Rs--

