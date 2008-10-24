Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbYJXTAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbYJXTAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYJXTAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:00:13 -0400
Received: from home.keithp.com ([63.227.221.253]:37421 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbYJXTAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:00:11 -0400
Subject: Re: Adding kmap_atomic_prot_pfn
From: Keith Packard <keithp@keithp.com>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Cc: keithp@keithp.com, nickpiggin@yahoo.com.au, airlied@linux.ie,
       yinghai@kernel.org, Peter Anvin <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <49017A2C.5010504@tungstengraphics.com>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu>	<1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu>	<1224389697.4384.118.camel@koto.keithp.com>
	 <1224398496.5303.7.camel@koto.keithp.com>	<20081019175320.GA6442@elte.hu>
	 <1224450291.5303.23.camel@koto.keithp.com>	<20081020115810.GC10594@elte.hu>
	 <1224517744.5195.1.camel@koto.keithp.com>	<20081022093615.GF12453@elte.hu>
	 <1224793332.22877.8.camel@koto.keithp.com>
	 <20081023133840.d4eef579.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>
	 <1224813015.22877.51.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>
	 <1224829359.22877.86.camel@koto.keithp.com>
	 <49017A2C.5010504@tungstengraphics.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qfjxnpC7eYWMaEHIXmm+"
Date: Fri, 24 Oct 2008 08:48:47 -0700
Message-Id: <1224863327.22877.106.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qfjxnpC7eYWMaEHIXmm+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-24 at 09:33 +0200, Thomas Hellstr=C3=B6m wrote:
> Keith,
>=20
> What you actually are doing here is claiming copyright on code that=20
> other people have written, and tighten the export restrictions.=20
> kmap_atomic_prot_pfn() appeared long ago in drm git with identical code=20
> and purpose, but with different authors, and iounmap_atomic is identical=20
> to kunmap_atomic.

Yeah, I just stuck my usual license header on it and didn't think about
authorship. I'll fix that, once we figure out what the appropriate name
is.

But, as this code is clearly a trivial adaptation of the existing kernel
code, it should carry a GPLv2 license. I'm also not particular as to the
EXPORT restriction, I was just following the EXPORT advice given for the
other newly exposed kernel symbols we're using.

--=20
keith.packard@intel.com

--=-qfjxnpC7eYWMaEHIXmm+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJAe5fQp8BWwlsTdMRAoymAKDkHnjX6k+ke+eLAFfFbGOhqRYj8ACgnY0P
BPH85Rh5Tu12F9phX4BCC7o=
=OFFe
-----END PGP SIGNATURE-----

--=-qfjxnpC7eYWMaEHIXmm+--

