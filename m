Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYADJRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYADJRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 04:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYADJRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 04:17:39 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:56541 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753699AbYADJRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 04:17:37 -0500
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <20080104024506.GA4665@one.firstfloor.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <20080104024506.GA4665@one.firstfloor.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0iT/L+VpIFEqKEXzzaCh"
Date: Fri, 04 Jan 2008 10:17:31 +0100
Message-Id: <1199438251.7143.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0iT/L+VpIFEqKEXzzaCh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-01-04 at 03:45 +0100, Andi Kleen wrote:
> > I still have trouble to see that SLOB still has much to offer. An embed=
ded=20
> > allocator that in many cases has more allocation overhead than the defa=
ult=20
> > one? Ok you still have advantages if allocations are rounded up to the=20
> > next power of two for a kmalloc and because of the combining of differe=
nt=20
> > types of allocations in a single slab if there are an overall small num=
ber=20
> > of allocations. If one would create a custom slab for the worst problem=
s=20
> > there then this may also go away.
>=20
> I suspect it would be a good idea anyways to reevaluate the power of two
> slabs. Perhaps a better distribution can be found based on some profiling=
?
> I did profile kmalloc using a systemtap script some time ago but don't
> remember the results exactly, but iirc it looked like it could be improve=
d.

I remember wli trying to work out a series that had minimal
fragmentation. IIRC he was mixing a fibonaci series with the power of
two series.

Bill, do you remember getting anywhere?

--=-0iT/L+VpIFEqKEXzzaCh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHffmrXA2jU0ANEf4RArGUAJwJDIuK+J1IdaUlfR5OX7hqJ4ugtQCeO2/I
s/6cUfN/iTP3y69Nr2HeNhM=
=frz6
-----END PGP SIGNATURE-----

--=-0iT/L+VpIFEqKEXzzaCh--

