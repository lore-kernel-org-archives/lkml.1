Return-Path: <linux-kernel-owner+w=401wt.eu-S1758334AbZBKVvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbZBKVvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbZBKVuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:50:51 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:49478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZBKVuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:50:50 -0500
Subject: RE: [PATCH]iwlan dma mapping read and write changes
From: Johannes Berg <johannes@sipsolutions.net>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
In-Reply-To: <1234388845.16004.53.camel@johannes.local>
References: <20081001165606.GA21279@linux-os.sc.intel.com>
	 <20090211182648.GA1661@linux-os.sc.intel.com>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2CD@hasmsx504.ger.corp.intel.com>
	 <1234388027.16004.50.camel@johannes.local>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2D5@hasmsx504.ger.corp.intel.com>
	 <1234388845.16004.53.camel@johannes.local>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QJDoUAqAZmwieoIxO/hj"
Date: Wed, 11 Feb 2009 22:50:07 +0100
Message-Id: <1234389007.16004.55.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QJDoUAqAZmwieoIxO/hj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-11 at 22:47 +0100, Johannes Berg wrote:
> > >> Indeed the firmware/ucode write back to host memory to update retry
> > >> counter for APMDU packets. I'm not sure if this is needed for legacy
> > >> traffic, though.
> > >
> > >I don't think they can be seeing AMPDU packets since that is, well,
> > >broken?
> >=20
> > Currently I'm not aware of any other cases where memory is accessed
> > back but I may have not complete info.  Will be back with the answer
> > tomorrow.
>=20
> I don't think it really matters, since AMPDU packets will be fixed soon,
> and for those you know it's necessary (and the report says that under
> some other circumstances it's also necessary). Unless there'd be some
> benefit from using BIDI only when we know it'll be needed, and using
> TODEV in the other cases?

Or if there's a firmware bug.

johannes

--=-QJDoUAqAZmwieoIxO/hj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJk0gKAAoJEKVg1VMiehFYHzkQAI4TEGOISIDni20gm6Ca9oEE
2zqkUUI3rszUbh76rVCmGPmbSQCfvEI1fGr2sqszMqdcDeiPSvudxuSiMc7Dpt0G
I5ziz6gAL61ry1Do+qi3Ny3x+qs2eAcGDxx8Ua97NQvXrpuXx9ApH4ytvaFvu541
sbogJ9e46NwwLBOVyH3HgLHazX76uNQrunU6BdE+Z6qUS6XB9w36UNM/N2VTnVgb
rZj3q5oQ/xcElQXvw4fybXXZSGS+49qeUeQyJ1JEnoOPpHiOtUowu7RRnhqBtsmA
Bq1+FvEMvRGJVlrFHDVdKmrRCcl4qzglbW1iVoTIVHLpXWpDaKst31naf7f3w4ZO
fWPaMzqIV9kSwk/kPKeq1scxn5uXJC8A5yNlMljBbyGc5Zcpul8dFa4tqrFbTyai
wGG7d/g/TBZFZeJ9VVPHPbhf5vyNFyeZeTpSgOkslovx6uGZXUwQT5GhxPNaecas
gE2M9P6VLxEYWHjK2b0jgWDtv0Khp7WIwPul+pd88omARHf0YfwpbyMsSZcpJmYK
QTKBLICBAH/Y9bilBpcMndyAFT14NuJZgZQZTq5hNNUQHLHGlS5RKgSdJFDL1TES
TpMorbeXQyKCWQqmb3KgD5i/aUI3YfR+8LViTCBTiyTmNkSMo5RD0+yokGDeJN5s
mfyJ6FCP9YSJ9UvSJopf
=mlG3
-----END PGP SIGNATURE-----

--=-QJDoUAqAZmwieoIxO/hj--

