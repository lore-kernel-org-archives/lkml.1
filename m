Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbZFCPxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbZFCPxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZFCPxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:53:46 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:45726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZFCPxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:53:45 -0400
Subject: Re: linux-next: Tree for June 3 (rfkill)
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910906030847k7e6f97bbo16497d872b93151b@mail.gmail.com>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
	 <4A269539.8020607@oracle.com> <1244042950.4862.10.camel@johannes.local>
	 <69e28c910906030847k7e6f97bbo16497d872b93151b@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8AHxGSoibjcmzL9mpW7O"
Date: Wed, 03 Jun 2009 17:53:37 +0200
Message-Id: <1244044417.4862.23.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8AHxGSoibjcmzL9mpW7O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-03 at 17:47 +0200, G=C3=A1bor Stefanik wrote:

> >> CFG80211=3Dy
> >> MAC80211=3Dy
> >> RFKILL=3Dm
> >>
> >> net/built-in.o: In function `cfg80211_netdev_notifier_call':
> >> core.c:(.text+0xa678b): undefined reference to `rfkill_blocked'
> >> net/built-in.o: In function `cfg80211_dev_free':
> >
> > Hrm. I thought
> >
> > config CFG80211
> >        tristate "Improved wireless configuration API"
> >        depends on RFKILL || !RFKILL
> >
> > would avoid that. Why doesn't it?
> >
> > johannes
> >
>=20
> Maybe the "y" state of CFG80211 specifically needs to depend on
> RFKILL=3Dy || !RFKILL.

Maybe doesn't help me at all.

> BTW should CFG80211=3Dy really be blocked when RFKILL=3Dm?=20

Yes.

> Shouldn't we
> just disable CFG80211 RFKILL support in this case (perhaps via a
> separate CONFIG_CFG80211_RFKILL automatically configured depending on
> CONFIG_RFKILL)?

That would be immensely stupid. You might as well just make cfg80211 a
module then.

johannes

--=-8AHxGSoibjcmzL9mpW7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJpx+AAoJEODzc/N7+QmaEicP/3JwoPj8xjfkugDReCjXIHQJ
OKSqNE1gscuq0XinPhx1qp1WFBrCRzvhuYehX51nRAcgajdu9/PG7CJ+0+KbsTBr
xY0nxfMrqoJBElwfKbe2HCl0WP4dRdais4SlnlW6YVcbdcvtw2KeYtQBFgEFTeyg
RvJqxzTqhOn9a8e0QzwHgOGuiwn+tczYj23XdSMB8HzGWJTwKaWmUttkYVM4Q8Mt
sD9syg75E0mJiOSJ5ss17c2XUZQk+HR16SBQvpwsjRiC2h4Fin9Kk77tBXVnnxXu
HfZY8OHqDjJSSdzdRnXFO3gWyALfKo0vOmx/qJdUW2T+MjY7rvZAq4wo6bgaVZbh
UjobFIhsAo5x1BravQmodJfVZ1oKZCQK0IVnD1x3LlXm/WClBsH0qkEP3Q+roKHY
VQsMik227irP+Snwcrh2jpCQQj6ob0/haejWZsnFQ39KDECEiBn4NgmHVGqfeHVb
2H8RE0ftNEl2J62znjvihPCjyzfeCNSQ1AyudcD70KtSTmQ4tVhRPWIAXzO1Pa63
rB/Hw0DFJgKuBY0EDrEFfaRJUXMOlnsZwf3nOAx5kEKba+JJx8s47F0KhSxAg+jE
FjwuJmw1QxDV5kHZS2KQW+FBCQpQVyqdSWxduZ9RrCUK31d3CgYds4mms+2XqHE9
VDnn2WUWR92mhqYgrOOI
=jn+N
-----END PGP SIGNATURE-----

--=-8AHxGSoibjcmzL9mpW7O--

