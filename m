Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXLTIA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXLTIA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 03:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbXLTIAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 03:00:10 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:51886 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750960AbXLTIAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 03:00:09 -0500
Subject: Re: [PATCH 00/29] Swap over NFS -v15
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
In-Reply-To: <476999B7.1000203@tmr.com>
References: <20071214153907.770251000@chello.nl>  <476999B7.1000203@tmr.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6SMKnQn+0+PVsF307nk1"
Date: Thu, 20 Dec 2007 09:00:04 +0100
Message-Id: <1198137604.6484.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6SMKnQn+0+PVsF307nk1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2007-12-19 at 17:22 -0500, Bill Davidsen wrote:
> Peter Zijlstra wrote:
> > Hi,
> >=20
> > Another posting of the full swap over NFS series.=20
> >=20
> > Andrew/Linus, could we start thinking of sticking this in -mm?
> >=20
>=20
> Two questions:
> 1 - what is the memory use impact on the system which don't do swap over=20
> NFS, such as embedded systems, and

It should have little to no impact if not used.

> 2 - what is the advantage of this code over the two existing network=20
> swap approaches,=20

> swapping to NFS mounted file and=20

This is not actually possible with a recent kernel, current swapfile
support requires a blockdevice.

> swap to NBD device?

> I've used the NFS file when a program was running out of memory and that=20
> seemed to work, people in UNYUUG have reported that the nbd swap works,=20
> so what's better here?

swap over NBD works sometimes, its rather easy to deadlock, and its
impossible to recover from a broken connection.

--=-6SMKnQn+0+PVsF307nk1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHaiEEXA2jU0ANEf4RAl93AJ97JZvV0QnnGe1G9cyi4ENjZnyBtgCbBeHc
BHq+vfwezh/scL/6LPg9c90=
=VCif
-----END PGP SIGNATURE-----

--=-6SMKnQn+0+PVsF307nk1--

