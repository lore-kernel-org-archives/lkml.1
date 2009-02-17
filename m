Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZBQQog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZBQQog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZBQQoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:44:24 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:43424 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbZBQQoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:44:23 -0500
Subject: Re: [PATCH -next/mmotm/resend/lost] wireless: fix for
	CONFIG_NL80211=n
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, linville@tuxdriver.com
In-Reply-To: <20090213163935.ea924a9a.randy.dunlap@oracle.com> (sfid-20090214_013927_260784_1DD3BDE7)
References: <20090213163935.ea924a9a.randy.dunlap@oracle.com>
	 (sfid-20090214_013927_260784_1DD3BDE7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZtTcPGLy+nSr2Z/uNMVj"
Date: Tue, 17 Feb 2009 17:44:17 +0100
Message-Id: <1234889057.29785.5.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZtTcPGLy+nSr2Z/uNMVj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-13 at 16:39 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Add empty function for case of CONFIG_NL80211=3Dn:
>=20
> net/wireless/scan.c:35: error: implicit declaration of function 'nl80211_=
send_scan_aborted'
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

bump &
Acked-by: Johannes Berg <johannes@sipsolutions.net>

I forgot this when adding the scan abort part.

> ---
>  net/wireless/nl80211.h |    4 ++++
>  1 file changed, 4 insertions(+)
>=20
> --- linux-next-20090212.orig/net/wireless/nl80211.h
> +++ linux-next-20090212/net/wireless/nl80211.h
> @@ -27,6 +27,10 @@ static inline void
>  nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
>  		       struct net_device *netdev)
>  {}
> +static inline void nl80211_send_scan_aborted(
> +					struct cfg80211_registered_device *rdev,
> +					struct net_device *netdev)
> +{}
>  #endif /* CONFIG_NL80211 */
> =20
>  #endif /* __NET_WIRELESS_NL80211_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-ZtTcPGLy+nSr2Z/uNMVj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmuldAAoJEKVg1VMiehFYaPsP/ArQ2cAA12EPOgvyB8nyKsqt
q0ZZl0fInOTPN8uDCpdM8KyWAXLwkFD86i36kjkCsEk5uWN55UzabaGXnp20t61y
Xpd4f2pGmvOdRuX44MA8HlAa6Can5fseSDNHVUA4JKSlWcOeiprB9wgph+0jhAoJ
lCDAzk11xxeWA49yPiNQ/aIsHcuLNnx3F/wvoF8uOAUljkNT5PEKXBKSE+DNj4WS
Nez27RqaBgHyyI5sggqTl0KR7o/NmzXof+k/b3QL7aP5JNsojo5g3zl4exFbPnkn
Km0XMgH0pMg7KPjgKlCxqPdoCj+qIMvTEkZ0hupwzGka99cxc9cCPR9Mm30cQLX/
0OwblI8zV2P27M4L7dqghS7Fa3mx5HsXw0hzLe8ZYyBWq1LDNjwwdcGNdBScqxoc
VNwgG2rYjHPIKwY/B1Wp0Ko8ASb2Wh3a9NFJ8nVZKgMwDtS1W6ssvWl+By5IhTza
gspW5CpBWsMe1/t5rHiQNScHE/BmcvPs32C826FtMrt1x0YNNCCVdlvEQWUIkvie
0l+EXfPJGpbENrSxK5kyxx5mT3r3n/UaRs5kt74WdxXH6lybZRA4BRzdp3vaB9kg
H5nPtKivj9+YNGFxM1EuEn8wxhFgFGn4m62MrAeTu+I1I5VgRmPKuJl37o4k7Og7
OeMNvGyu5sdjMALX6KAk
=OHg2
-----END PGP SIGNATURE-----

--=-ZtTcPGLy+nSr2Z/uNMVj--

