Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYHGC5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYHGC5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 22:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYHGC5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 22:57:40 -0400
Received: from home.keithp.com ([63.227.221.253]:3700 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbYHGC5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 22:57:39 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Stephane Marchesin <marchesin@icps.u-strasbg.fr>
Cc: keithp@keithp.com, Arjan van de Ven <arjan@infradead.org>,
       John Stoffel <john@stoffel.org>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <6a89f9d50808061916r6f3434dbve525d5d814f57913@mail.gmail.com>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <Pine.LNX.4.64.0808041720500.25617@blonde.site>
	 <1217870748.24714.79.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808041855050.5717@blonde.site>
	 <1217877645.24714.87.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808042055240.17041@blonde.site>
	 <18583.47633.987143.236236@stoffel.org>
	 <1217910505.24714.152.camel@koto.keithp.com>
	 <6a89f9d50808060920t168d533g5d440b444e7c09fc@mail.gmail.com>
	 <20080806102437.2d5e5d11@infradead.org>
	 <6a89f9d50808061916r6f3434dbve525d5d814f57913@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6bwqxP8sy9W8qNYLyvOS"
Date: Wed, 06 Aug 2008 19:57:26 -0700
Message-Id: <1218077846.24714.290.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6bwqxP8sy9W8qNYLyvOS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 04:16 +0200, Stephane Marchesin wrote:

> Btw, I was wondering what prevented you (you being the intel people)
> from fixing TTM instead of writing GEM ? That's what happened, there
> was TTM first, intel came first, they should've fixed it...

Well, we (mostly Eric, but a bit of work by me as well) spent about a
year trying to fix it, with Thomas' help, but after that, we still
hadn't managed to make the 965 run OpenGL reasonably well.

Around April 1, we (Eric and I) evaluated how long it would take to
built just what we needed, rather than trying to work out a general
architecture that could serve every hardware need we could think of. We
figured it would take about a month to get something working, and by the
end of April, we had 3D working better on 965 than we had ever managed
with TTM.

Given the difficulty we had understanding the TTM internals, it's
possible that this was just a failure on our part. But as we expect a
wide range of people to maintain this code going forward, it seemed
reasonable to want something simple enough that even we could figure out
how it works.

I think TTM is over designed, but that is colored by experience with
very simple hardware. While I think something simple, like GEM, could
work on most hardware, I really don't know and invite you to try
whatever approach you want.

Also, we're talking about moving code into the Linux kernel source tree
to support Intel integrated graphics. There is no incumbent
implementation there that we're trying to replace, this is new
functionality for Linux.

--=20
keith.packard@intel.com

--=-6bwqxP8sy9W8qNYLyvOS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBImmSWQp8BWwlsTdMRAjsOAKC93ZPZSa9vOs9YXzsWsVJlI5p26QCfU+7z
Wt/05gO2i1vrtFYdd2NFX1k=
=3miR
-----END PGP SIGNATURE-----

--=-6bwqxP8sy9W8qNYLyvOS--

