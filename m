Return-Path: <linux-kernel-owner+w=401wt.eu-S933547AbZJFVfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbZJFVfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933208AbZJFVfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:35:08 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247AbZJFVfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:35:05 -0400
Subject: Re: [PATCH -next] wireless: fix CFG80211_WEXT build problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linville@tuxdriver.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20091006132729.8b4f9345.rdunlap@xenotime.net>
References: <20091006165220.b5cb1c44.sfr@canb.auug.org.au>
	 <20091006132729.8b4f9345.rdunlap@xenotime.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mlIR3prWWHjimdDtAY9E"
Date: Tue, 06 Oct 2009 23:33:49 +0200
Message-Id: <1254864829.22426.44.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mlIR3prWWHjimdDtAY9E
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-06 at 13:27 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix CFG80211_WEXT build dependencies/errors:
>=20
> ERROR: "cfg80211_wext_siwscan" [drivers/net/wireless/orinoco/orinoco.ko] =
undefined!
> ERROR: "cfg80211_wext_siwmode" [drivers/net/wireless/orinoco/orinoco.ko] =
undefined!
> ERROR: "cfg80211_wext_giwrange" [drivers/net/wireless/orinoco/orinoco.ko]=
 undefined!
> ERROR: "cfg80211_wext_giwmode" [drivers/net/wireless/orinoco/orinoco.ko] =
undefined!
> ERROR: "cfg80211_wext_giwname" [drivers/net/wireless/orinoco/orinoco.ko] =
undefined!
> ERROR: "cfg80211_wext_giwscan" [drivers/net/wireless/orinoco/orinoco.ko] =
undefined!
> ERROR: "cfg80211_wext_giwname" [drivers/net/wireless/ipw2x00/ipw2200.ko] =
undefined!
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/net/wireless/ipw2x00/Kconfig |    2 +-
>  drivers/net/wireless/orinoco/Kconfig |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> --- linux-next-20091006.orig/drivers/net/wireless/ipw2x00/Kconfig
> +++ linux-next-20091006/drivers/net/wireless/ipw2x00/Kconfig
> @@ -65,7 +65,7 @@ config IPW2100_DEBUG
> =20
>  config IPW2200
>  	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
> -	depends on PCI && WLAN_80211 && CFG80211
> +	depends on PCI && WLAN_80211 && CFG80211 && CFG80211_WEXT

Interesting approach, thanks. I completely forgot about the
half-converted drivers. The alternative would be to ifdef the code
blobs, but I'm happy with this.

johannes

--=-mlIR3prWWHjimdDtAY9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKy7e6AAoJEODzc/N7+Qmat9QP/jU4JKxcY8zrwS3TBC8hWP4/
LoVAXBV922pZ6mywE+J4DN3DCRYpBLYiMc7+6Ip5gosNSoRTv8p9+Nik3BeBKbR6
9qxz1Nxq+9M+eQLkj0eMRI1CVGGFhh+2VyjPdN71WWUjL1/wyskLLVITL5La/aB6
stbLBsnwNXnlgFvsEjWlgWUaGqjstpJrG2OK0mGMH9tDSF/RqLKnuwqxwTk4VyH8
NLqhTbLHEBr3Pkjh0B/kM8HiZ43J7s0yvLpXZqPQaVOMHMGJ9onlFGc8n4Wit905
hjxGLR0onTqijjkhw4ARXlGsb7iwGKbO7Q1uNkb5Lbdo3jg1XJlFNnf0gUBpmL+b
3ws0l0yeUdNPRnKPVUlGkThyBgmtwE+ycyWRPusCoGt/efPwL1ssEAt9Jf2LJod/
rEOzjGSTs1MYm3UVOQACqfGfo6CNFju47D7X7Kalb26M8vBRc7ItquaMN+1aWfMN
aKowUw8Dhw6HjvcFS8ySfDn72tmXqquW806fAaJgQ9sQ2O8DK00UpZdpfNHWdC7v
tZwRtlNlTKY6BX1FZnsCS2v2pZEtHSe3BV7MEu21qyW7WszbtxGnku19L5mhLcF2
cY7/ZG3AzCIrnmNKt04U3XFlyr3Bf5yc1KCDoEUxq1jQD1uZDS6Wu6G/ko1hJ5KY
hXsomFmGcu7ddhWxr1SY
=Udyl
-----END PGP SIGNATURE-----

--=-mlIR3prWWHjimdDtAY9E--

