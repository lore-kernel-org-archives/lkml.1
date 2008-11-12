Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYKLRI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYKLRI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYKLRIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:08:43 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:46745 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYKLRIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:08:42 -0500
Subject: Re: [PATCH] mac80211: add explicit padding in struct
	ieee80211_tx_info
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <1226502337-11085-1-git-send-email-linville@tuxdriver.com>
References: <Pine.LNX.4.64.0811120854290.13217@anakin>
	 <1226502337-11085-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zjdn6LDXz5BFXHMnSh+o"
Date: Wed, 12 Nov 2008 18:08:44 +0100
Message-Id: <1226509724.14186.14.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zjdn6LDXz5BFXHMnSh+o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-12 at 10:05 -0500, John W. Linville wrote:
> Otherwise, the BUILD_BUG_ON calls in ieee80211_tx_info_clear_status can
> fail on some architectures.
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Why do we have those BUILD_BUG_ON calls anyway?  Hmmm...

Because we actually use those offsets in places to clear things.

>  include/net/mac80211.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index feb52cc..38302d6 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -333,6 +333,7 @@ struct ieee80211_tx_info {
>  	u8 antenna_sel_tx;
> =20
>  	/* 2 byte hole */
> +	u8 pad[2];
> =20
>  	union {
>  		struct {

--=-zjdn6LDXz5BFXHMnSh+o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJGw2YAAoJEKVg1VMiehFYQH8QAIH4pexbeKEbCwTvQCFv7vAZ
cBwkjAkGrG5YDs5kBvlMrM0afzEKK8GQ/IUFCZxqA3cOHKLwR2NFPei1dnZK4v42
4LXmzwfvCnUpzrDdtlcqtWFtB0kG/I6FPTrbLGsAs6qXke8My5pMtOyANJo+EAGM
xH88gSZ4vbQRPspP487/hx3CK1SnpXBEaQ8/Hh/h12GCc6pqCOrrYewcHWY77hCo
V0Nx7v9v/cmdn60oFudHfbAdd1kCT2o6d2cZj7RI7HL2NsKkz+j7LzrcD5KG/48u
ZdAbxvtHn+Si68KZ8AxRM6hyzpnh9Nv5K84ervvKDvbu/Z0qXteWML67ejbYGTod
fngLjocSsRopII153BUR9i8naM7wwYU27jBAAzsOHVzv/uP+wrAfpvrBAzKf0DRY
3v8XMx+nz6prFu6B0w1vooOwr2U0mxssaoVT1Zmn4loME/rxnJ4BAQMp+7hMMGJv
7zvQWMl14qAQ9Dcap+/i47DhK18FpgsNpT4AFZu+kXd0mNUo/xMlxkB1PXng9WM8
D2ENgqIrE6H+FSRa8ccjNkf+AwpMmrOLP4tb6zaV/G4inGVf0QDCpwPHOV4aSTy/
RmOOu6mBK1PvSFbXNlbMsZG2jtIEpRDS+NB7EiIBOTq/13R94cMasqiQjQO8Ni2c
qED7ngc2KGQrGQfBIfq8
=DZPO
-----END PGP SIGNATURE-----

--=-zjdn6LDXz5BFXHMnSh+o--

