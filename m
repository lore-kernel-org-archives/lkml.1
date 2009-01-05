Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbZAETCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbZAETCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZAETCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:02:11 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:53767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZAETCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:02:09 -0500
Subject: Re: [PATCH 1/1] IWL: fix WARN typo
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1231171404-22822-1-git-send-email-jirislaby@gmail.com> (sfid-20090105_170346_728743_CFC4B367)
References: <1231171404-22822-1-git-send-email-jirislaby@gmail.com>
	 (sfid-20090105_170346_728743_CFC4B367)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bIxsPomByoH6jo4BkF9d"
Date: Mon, 05 Jan 2009 20:02:18 +0100
Message-Id: <1231182138.3697.0.camel@johannes>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bIxsPomByoH6jo4BkF9d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-05 at 17:03 +0100, Jiri Slaby wrote:
> new kew -> a new key
>=20
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-sta.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireles=
s/iwlwifi/iwl-sta.c
> index 412f66b..b28564a 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-sta.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
> @@ -638,7 +638,7 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_pr=
iv *priv,
>  	 * in uCode. */
> =20
>  	WARN(priv->stations[sta_id].sta.key.key_offset =3D=3D WEP_INVALID_OFFSE=
T,
> -		"no space for new kew");
> +		"no space for a new key");

Eh, if anything shouldn't that be "the new key"?

johannes

--=-bIxsPomByoH6jo4BkF9d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJYlk3AAoJEKVg1VMiehFYSdgQAKAwvJ2j/TCkHdRfGdRzEXPw
A5rrVFtLaNWIpb2IQD6R/3X49EUHDwJiPTurqfyTEdBf9B8a7/9SlnjjD8qWUMht
HY+35bpTfE5xSXXVi83GRP2lp3sbHiIZ6Mp2pAd8s5HQUCfMmF6w7k1SWdkYMwsh
g8VMqqBI6tZHFk2+8KD7uO3lmmLxjM06Gxw7AxrS6L4C+v86Je510XEhtL2BVrvG
TMizRnaUSm4bNmINbxoqDpVX9isYLAgFqmqvH74FavqCZ8KP0ByBBGO6JfAAvub0
CQsG1unFzCraB+w2O4XoWmFLxt0+OE43vW0GY+odbyz8DHIBQfSbyPkCRV3bbusn
a5vjRQYGMVG0WWlwf4FU2xPXcwAZ+Z4f//OXzFre6UelDstFepXj+q8GdVwBYjg3
mnUp/mpdVHUBI5mQ84aRw17m5JlTkq87NHL3USyQV/tXmRQO1y9cLf6RYuoilPjS
jrrjpHIMUDP1InSFGB86U3kzT/9TdDq4ZQjaQYhdakCZ5kejEqr7T9ZhhpewE/6e
++y9NziZcPOYh5V8uwdPsaBMn1oC3gHPw4edruL+DDUpZECWtNIl9jN6TcMhwUer
VAD61ODs/uSjOrV9Km/jZzVNamkyRLjwLyK37eZ9UE4NIzkWqJqt+apOvM07lXMh
AMRHDtn80s6X7yyTYQjb
=EPeo
-----END PGP SIGNATURE-----

--=-bIxsPomByoH6jo4BkF9d--

