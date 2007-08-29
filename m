Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbXH2E3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbXH2E3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbXH2E3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:29:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:45231 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbXH2E3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:29:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,319,1183359600"; 
   d="asc'?scan'208";a="285104946"
Subject: Re: CFS review
From: Keith Packard <keith.packard@intel.com>
Reply-To: keith.packard@intel.com
To: Ingo Molnar <mingo@elte.hu>
Cc: keith.packard@intel.com, Al Boldi <a1426z@gawab.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070829041827.GA8733@elte.hu>
References: <200708111344.42934.a1426z@gawab.com>
	 <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu>
	 <200708280737.53439.a1426z@gawab.com>  <20070829041827.GA8733@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QH4G6oHZ8stTtrvK+M1G"
Organization: Intel Corp
Date: Tue, 28 Aug 2007 21:29:09 -0700
Message-Id: <1188361749.21502.123.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QH4G6oHZ8stTtrvK+M1G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-29 at 06:18 +0200, Ingo Molnar wrote:

> > Then lay them out side by side to see the periodic stallings for=20
> > ~10sec.

The X scheduling code isn't really designed to handle software GL well;
the requests can be very expensive to execute, and yet are specified as
atomic operations (sigh).

> i just tried something similar (by adding Option "NoDRI" to xorg.conf)=20
> and i'm wondering how it can be smooth on vesa-driver at all. I tested=20
> it on a Core2Duo box and software rendering manages to do about 3 frames=20
> per second. (although glxgears itself thinks it does ~600 fps) If i=20
> start 3 glxgears then they do ~1 frame per second each. This is on=20
> Fedora 7 with xorg-x11-server-Xorg-1.3.0.0-9.fc7 and=20
> xorg-x11-drv-i810-2.0.0-4.fc7.

Are you attempting to measure the visible updates by eye? Or are you
using some other metric?

In any case, attempting to measure anything using glxgears is a bad
idea; it's not representative of *any* real applications. And then using
software GL on top of that...

What was the question again?

--=20
keith.packard@intel.com

--=-QH4G6oHZ8stTtrvK+M1G
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG1PYTQp8BWwlsTdMRAtN9AKCNgROm4duzQSCbv0MUQeeYT3Gd1ACgv/R1
s2wMj2xYKr4VJ+GnpaEnX/U=
=8iQc
-----END PGP SIGNATURE-----

--=-QH4G6oHZ8stTtrvK+M1G--
