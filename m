Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbYJXTAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbYJXTAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYJXTAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:00:11 -0400
Received: from home.keithp.com ([63.227.221.253]:37407 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbYJXTAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:00:10 -0400
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
	2.6.27-rc1)
From: Keith Packard <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: keithp@keithp.com, nickpiggin@yahoo.com.au, airlied@linux.ie,
       benh@kernel.crashing.org, Peter Anvin <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net,
       Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0810240752300.3287@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>
	 <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu>
	 <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu>
	 <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu>
	 <1224793332.22877.8.camel@koto.keithp.com>
	 <20081023133840.d4eef579.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>
	 <1224813015.22877.51.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>
	 <1224818645.7654.431.camel@pasglop>
	 <1224826660.22877.83.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810240752300.3287@nehalem.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3imfBnWvKRITK4IctLg5"
Date: Fri, 24 Oct 2008 08:45:20 -0700
Message-Id: <1224863120.22877.100.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3imfBnWvKRITK4IctLg5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-24 at 07:53 -0700, Linus Torvalds wrote:

> Actually, on 32-bit, the 'prot' should be there, as should the starting=20
> physical page. Otherwise the two interfaces would be very odd, and you'd=20
> have to repeat those arguments in all callers (ie both in "prepare" and=20
> in the actual "access").

I suppose. What I did instead was create _wc versions of both the
prepare and access functions to eliminate the need for additional data.
Either way is fine with me; I took the route which didn't require an
additional allocation.

--=20
keith.packard@intel.com

--=-3imfBnWvKRITK4IctLg5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJAe2QQp8BWwlsTdMRAirLAJ4986y9JT4P6qM+2X3CCMK2W/qaoQCcDBv0
o9irxTuMjhmqnZeY5NCQRqg=
=YiPw
-----END PGP SIGNATURE-----

--=-3imfBnWvKRITK4IctLg5--

