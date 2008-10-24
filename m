Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYJXFj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYJXFj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYJXFjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:39:05 -0400
Received: from home.keithp.com ([63.227.221.253]:46155 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbYJXFjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:39:04 -0400
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
	2.6.27-rc1)
From: Keith Packard <keithp@keithp.com>
To: benh@kernel.crashing.org
Cc: keithp@keithp.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       nickpiggin@yahoo.com.au, airlied@linux.ie,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, yinghai@kernel.org,
       Peter Anvin <hpa@zytor.com>
In-Reply-To: <1224818645.7654.431.camel@pasglop>
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
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j0RrFCACXOzkulHUt+0U"
Date: Thu, 23 Oct 2008 22:37:40 -0700
Message-Id: <1224826660.22877.83.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-j0RrFCACXOzkulHUt+0U
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-24 at 14:24 +1100, Benjamin Herrenschmidt wrote:

> I'm not that fan of carrying a mapping with a struct resource because if
> we do that we should probably also refcount the mapping, and then there
> is the whole question of mappings with different attributes, etc etc...

I'm fine with sticking the mapping in a separate structure; it's just
the return from ioremap_wc on 64-bit systems, and nothing at all on
32-bit systems. I don't really see the advantage of moving it into the
resource, especially as we may need different access modes (UC vs WC)
for different portions of a single BAR.

We may want to add some bounds and access mode information to this
structure to check for broken drivers.

--=20
keith.packard@intel.com

--=-j0RrFCACXOzkulHUt+0U
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJAV8kQp8BWwlsTdMRAkITAJ0XZS2/Y15E2zIKUNlNzgepBIuIhQCfcAcZ
r0CnS7FDHhyaekzlgOrXVW4=
=MNfI
-----END PGP SIGNATURE-----

--=-j0RrFCACXOzkulHUt+0U--

