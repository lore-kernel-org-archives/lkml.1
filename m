Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbYJGBKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYJGBKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYJGBKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:10:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:2781 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbYJGBKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:10:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,370,1220252400"; 
   d="asc'?scan'208";a="388330082"
Subject: Re: [PATCH -mm -v3] Separate atomic_t declaration from
	asm/atomic.h into asm/atomic_def.h
From: Huang Ying <ying.huang@intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0810061047440.5594@anakin>
References: <1223263964.5872.20.camel@yhuang-dev.sh.intel.com>
	 <Pine.LNX.4.64.0810061047440.5594@anakin>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-J2y4bja2dkTYnRYG6VKh"
Date: Tue, 07 Oct 2008 09:09:59 +0800
Message-Id: <1223341799.5872.24.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-J2y4bja2dkTYnRYG6VKh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Geert,

On Mon, 2008-10-06 at 10:48 +0200, Geert Uytterhoeven wrote:
> On Mon, 6 Oct 2008, Huang Ying wrote:
> > From: Huang Ying <ying.huang@intel.com>
> >=20
> > asm/atomic.h contains both declaration and implementation of atomic_t. =
 So
> > there are some implementation related files included in asm/atomic.h.  =
And
> > atomic_t is a typedef.  Combination of above makes it impossible to use
> > atomic_t in files included by atomic.h.  Such as atomic_t can not be us=
ed
> > in linux/kernel.h on i386, because it is included by asm/atomic.h.
> >=20
> > It is reasonable to separate declaration from implementation.  So a new
> > file atomic_def.h is added for every architecture to accommodate the
> > declaration of atomic_t.
>=20
> And how many of these atomic_def.h are identical?
> asm-generic?

Most of them are identical. But <asm/atomic_def.h> will be a public API,
included by not only <asm/atomic.h> but also <linux/xxx.h>. I don't know
how to put it in asm-generic.

Best Regards,
Huang Ying

--=-J2y4bja2dkTYnRYG6VKh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjqtuEACgkQKhFGF+eHlpjlpgCfYJ4MJ9bPR1Sx00wO3TBix1u9
V8oAoJWqixv8DoxETzCmT3xEopyr33zM
=Er7F
-----END PGP SIGNATURE-----

--=-J2y4bja2dkTYnRYG6VKh--

