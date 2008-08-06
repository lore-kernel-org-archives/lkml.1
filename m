Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYHFR5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYHFR5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYHFR44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:56:56 -0400
Received: from home.keithp.com ([63.227.221.253]:2092 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbYHFR4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:56:55 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Stephane Marchesin <marchesin@icps.u-strasbg.fr>
Cc: keithp@keithp.com, Arjan van de Ven <arjan@infradead.org>,
       John Stoffel <john@stoffel.org>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <6a89f9d50808061032k6c30887cg6bed0259f9620b1b@mail.gmail.com>
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
	 <6a89f9d50808061032k6c30887cg6bed0259f9620b1b@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-44QeUUyjB7lHLfPdu6Ud"
Date: Wed, 06 Aug 2008 10:56:49 -0700
Message-Id: <1218045409.24714.257.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-44QeUUyjB7lHLfPdu6Ud
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-08-06 at 19:32 +0200, Stephane Marchesin wrote:

> Right, but the current code will basically force the discrete card
> drivers to implement backing store for all allocations.

Aside from not really forcing discrete card drivers to to anything
(they're welcome to use or not use this stuff as they prefer), I believe
discrete cards will need backing store to support paging objects to disk
and suspend-to-ram operations.

>  Do we want
> this ? Also, for cards that can handle page-based memory allocations,
> there is no way to make use of this feature, do we want this too ?

I don't see how any of the current code directs how future drivers might
work; the user-level interface is reasonably abstract and should allow
all kinds of internal organizations.

Instead of complaining that the current code might not support some
abstract hardware, please build something that does work and we'll see
how to merge that with code for other drivers.

--=20
keith.packard@intel.com

--=-44QeUUyjB7lHLfPdu6Ud
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBImeXhQp8BWwlsTdMRAtspAKC+kg9c3WsM0AjclkGlp2sg3gO3PgCaA9lb
AJO0RRAhmfK38Gca5zWtWgs=
=5Xwd
-----END PGP SIGNATURE-----

--=-44QeUUyjB7lHLfPdu6Ud--

