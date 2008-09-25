Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbYIYCnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbYIYCnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYIYCnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:43:43 -0400
Received: from home.keithp.com ([63.227.221.253]:3836 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbYIYCnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:43:43 -0400
Subject: Re: [patch] mm: pageable memory allocator (for DRM-GEM?)
From: Keith Packard <keithp@keithp.com>
To: Nick Piggin <npiggin@suse.de>
Cc: keithp@keithp.com, eric@anholt.net, hugh@veritas.com, hch@infradead.org,
       airlied@linux.ie, jbarnes@virtuousgeek.org, thomas@tungstengraphics.com,
       dri-devel@lists.sourceforge.net,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080925023014.GB4401@wotan.suse.de>
References: <20080923091017.GB29718@wotan.suse.de>
	 <1222185029.4873.157.camel@koto.keithp.com>
	 <20080925003021.GC23494@wotan.suse.de>
	 <1222305622.4343.166.camel@koto.keithp.com>
	 <20080925023014.GB4401@wotan.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GYCG0ZiNG1vhycsunoPk"
Date: Wed, 24 Sep 2008 19:43:26 -0700
Message-Id: <1222310606.4343.174.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GYCG0ZiNG1vhycsunoPk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-25 at 04:30 +0200, Nick Piggin wrote:

> OK. I will have to add some facilities to allow mmaps that go back throug=
h
> to tmpfs and be swappable... Thanks for the data point.

It seems like once you've done that you might consider extracting the
page allocator from shmem so that drm, tmpfs and sysv IPC would share
the same underlying memory manager API.

--=20
keith.packard@intel.com

--=-GYCG0ZiNG1vhycsunoPk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI2vrOQp8BWwlsTdMRAta3AKDdMsaDuVC5iYl8//VG8pMtj2/tDQCgjUyP
KL15keWQnOdRYe9HEyzzSCE=
=hxHd
-----END PGP SIGNATURE-----

--=-GYCG0ZiNG1vhycsunoPk--

