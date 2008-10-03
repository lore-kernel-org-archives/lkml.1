Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYJCFSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYJCFSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 01:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYJCFSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 01:18:08 -0400
Received: from home.keithp.com ([63.227.221.253]:53198 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbYJCFSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 01:18:08 -0400
Subject: Re: [patch] mm: pageable memory allocator (for DRM-GEM?)
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>,
       Nick Piggin <npiggin@suse.de>, "hugh@veritas.com" <hugh@veritas.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "airlied@linux.ie" <airlied@linux.ie>,
       "thomas@tungstengraphics.com" <thomas@tungstengraphics.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200810021015.55880.jbarnes@virtuousgeek.org>
References: <20080923091017.GB29718@wotan.suse.de>
	 <1222737005.21655.61.camel@vonnegut.anholt.net>
	 <200810021015.55880.jbarnes@virtuousgeek.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+JT4jPe2tB4XGYJk6bEW"
Date: Thu, 02 Oct 2008 22:17:51 -0700
Message-Id: <1223011071.21240.64.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+JT4jPe2tB4XGYJk6bEW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-02 at 10:15 -0700, Jesse Barnes wrote:

> At this point I think we should go ahead and include Eric's earlier patch=
set
> into drm-next, and continue to refine the internals along the lines of wh=
at
> you've posted here in the post-2.6.28 timeframe.=20

Nick, in case you missed the plea here, we're asking if you have any
objection to shipping the mm changes present in Eric's patch in 2.6.28.
When your new pageable allocator becomes available, we'll switch over to
using that instead and revert Eric's mm changes.

We're ready to promise to support the user-land DRM interface going
forward, and we've got lots of additional work queued up behind this
merge. We'd prefer to push stuff a bit at a time rather than shipping a
lot of new code in a single kernel release.=20

--=20
keith.packard@intel.com

--=-+JT4jPe2tB4XGYJk6bEW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI5ar/Qp8BWwlsTdMRAkTsAKDPDlA4nIJBUgIv8mCltGWO+vRkmQCgsv6G
K7Coczm2HtVBPLeLVh00TfQ=
=KcpQ
-----END PGP SIGNATURE-----

--=-+JT4jPe2tB4XGYJk6bEW--

