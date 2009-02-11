Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbZBKVsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbZBKVsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbZBKVsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:48:14 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:49384 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbZBKVsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:48:13 -0500
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
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F04F633E2D5@hasmsx504.ger.corp.intel.com>
References: <20081001165606.GA21279@linux-os.sc.intel.com>
	 <20090211182648.GA1661@linux-os.sc.intel.com>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2CD@hasmsx504.ger.corp.intel.com>
	 <1234388027.16004.50.camel@johannes.local>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2D5@hasmsx504.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kWY3FhLxAHEgSuViB5so"
Date: Wed, 11 Feb 2009 22:47:25 +0100
Message-Id: <1234388845.16004.53.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kWY3FhLxAHEgSuViB5so
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> Indeed the firmware/ucode write back to host memory to update retry
> >> counter for APMDU packets. I'm not sure if this is needed for legacy
> >> traffic, though.
> >
> >I don't think they can be seeing AMPDU packets since that is, well,
> >broken?
>=20
> Currently I'm not aware of any other cases where memory is accessed
> back but I may have not complete info.  Will be back with the answer
> tomorrow.

I don't think it really matters, since AMPDU packets will be fixed soon,
and for those you know it's necessary (and the report says that under
some other circumstances it's also necessary). Unless there'd be some
benefit from using BIDI only when we know it'll be needed, and using
TODEV in the other cases?

johannes

--=-kWY3FhLxAHEgSuViB5so
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJk0dqAAoJEKVg1VMiehFY7yYQAKq8CiVHcI87LdoQ02/98i4c
kjsv/dCmWgJF1mWlpes2eh7ciNixUrluZq+56D9a4uduyi13ditUQ7ICu7Km9np2
sdyRNspC5KSe3bizpN5gzNQPnrZajDeSPrGjgM3CwxOtknORvXDssewXG7cRL8/H
w633+LxC297Kz6/00VQ6jfsE4aFJzTvHflFwiWfhw5POKRX1ubqqLiYKFCCqhCED
cA8rtoNKQ6hr1cyNEmHllobDzayk2w/W/r1SgIocrDO4GhIjh76CFkUG/NyeA4Y8
6W3MvL+v+rHMH76tFKOe1jbt5p4+IlpWT0zA4U6QOe4Go54aq2ByAu7AyboqJ03G
yyn2v+nw81oyz0upt7BJ+GrCY/TmUCXdu/1qtcXTcgA5AsbgHNZDKGo8nwYYUV6C
tJDZYoSmI3R/jOHl7sUZ8/jKETDaVRxte5dVojb6ss237PigN36q/APdZgX8g7xD
lXKavGsXw6BnlEHlJ16YSyn1ekDra3MUaMyrMY5jQ4ijpwCwrPSsECQO2N7JoCr0
J8DcHWSyqsk3xqqut3sjbb4I/p+srgKaPxYGlEgneorVI7x2+1/XXSQi7NaaiaiH
aNQeeqyXFQr9Hpz1A8XGI46x4ZmAkyUveiVKMb1Gb2+qH6Kg9Ti+gTUMXTBsHNFY
sXiKpFMHjGFnNXjsTjFu
=HYgZ
-----END PGP SIGNATURE-----

--=-kWY3FhLxAHEgSuViB5so--

