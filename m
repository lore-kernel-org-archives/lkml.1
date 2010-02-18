Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab0BRXhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:37:11 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58571 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059Ab0BRXhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:37:08 -0500
X-Sasl-enc: ecUHlM6JK6SFFsjZWBu3AxCGGrcy/Lx7wqlc+uJDU3Qk 1266536224
Message-ID: <4B7DCEE9.4080208@imap.cc>
Date: Fri, 19 Feb 2010 00:36:09 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCH 01/12] isdn: remove ishexdigit() in regard to isxdigit()
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com> <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
In-Reply-To: <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig90F0D5CD61A9A4BFE1AF4227"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig90F0D5CD61A9A4BFE1AF4227
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 18.02.2010 19:55 schrieb Andy Shevchenko:
> From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
>=20
> Samll cleanup in drivers/isdn/gigaset/capi.c where own implementation o=
f
> isxdigit() has been changed to kernel native one.
>=20
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Acked-by: Tilman Schmidt <tilman@imap.cc>

Thanks,
Tilman

> ---
>  drivers/isdn/gigaset/capi.c |   16 +---------------
>  1 files changed, 1 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
> index 3f5cd06..83c4e2f 100644
> --- a/drivers/isdn/gigaset/capi.c
> +++ b/drivers/isdn/gigaset/capi.c
> @@ -169,20 +169,6 @@ static inline void ignore_cstruct_param(struct car=
dstate *cs, _cstruct param,
>  }
> =20
>  /*
> - * check for legal hex digit
> - */
> -static inline int ishexdigit(char c)
> -{
> -	if (c >=3D '0' && c <=3D '9')
> -		return 1;
> -	if (c >=3D 'A' && c <=3D 'F')
> -		return 1;
> -	if (c >=3D 'a' && c <=3D 'f')
> -		return 1;
> -	return 0;
> -}
> -
> -/*
>   * convert hex to binary
>   */
>  static inline u8 hex2bin(char c)
> @@ -202,7 +188,7 @@ static int encode_ie(char *in, u8 *out, int maxlen)=

>  {
>  	int l =3D 0;
>  	while (*in) {
> -		if (!ishexdigit(in[0]) || !ishexdigit(in[1]) || l >=3D maxlen)
> +		if (!isxdigit(in[0]) || !isxdigit(in[1]) || l >=3D maxlen)
>  			return -1;
>  		out[++l] =3D (hex2bin(in[0]) << 4) + hex2bin(in[1]);
>  		in +=3D 2;

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig90F0D5CD61A9A4BFE1AF4227
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkt9zvEACgkQQ3+did9BuFtzrgCcCc8wdAiqR5fJ3+uMf0FcVjWE
Cd4An3HIu0quuW4FynhSnwnOpBq3MU/l
=C6jE
-----END PGP SIGNATURE-----

--------------enig90F0D5CD61A9A4BFE1AF4227--
