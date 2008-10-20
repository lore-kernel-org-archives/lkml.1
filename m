Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbYJTX5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbYJTX5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYJTX4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:56:52 -0400
Received: from home.keithp.com ([63.227.221.253]:33937 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYJTX4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:56:52 -0400
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
	for 2.6.27-rc1)
From: Keith Packard <keithp@keithp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: keithp@keithp.com, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20081020115810.GC10594@elte.hu>
References: <200810181237.49784.nickpiggin@yahoo.com.au>
	 <1224357062.4384.72.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>
	 <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu>
	 <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-83If55+YSbYxxbEIri2Z"
Date: Mon, 20 Oct 2008 08:49:04 -0700
Message-Id: <1224517744.5195.1.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-83If55+YSbYxxbEIri2Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 13:58 +0200, Ingo Molnar wrote:

> yes but note that by caching the whole mapping on 64-bit we get=20
> everything we want: trivially lockless, works from any CPU, can be=20
> preempted at will, and there are no ugly INVLPG flushes anywhere.

I was assuming that on 64-bit, the map would be created at driver init
time and be left in place until the driver closed; if that's what you
mean by 'caching', then yes, we should cache the map.

> 32-bit we should handle as well but not design for it.

As long as we get kmap_atomic-like performance, and we get to simplify
our code, I'm up for it.

--=20
keith.packard@intel.com

--=-83If55+YSbYxxbEIri2Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI/KhtQp8BWwlsTdMRAiDfAJ9RqvKfPpe18kPdy3zRgjQlcPTmuACcCAiZ
GBlELYIpxLkB6bFJ5B5vW+Q=
=6V02
-----END PGP SIGNATURE-----

--=-83If55+YSbYxxbEIri2Z--

