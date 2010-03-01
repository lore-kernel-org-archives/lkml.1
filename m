Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab0CAVG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:06:59 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:47903 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab0CAVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:06:57 -0500
Date: Mon, 1 Mar 2010 18:06:40 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: platform-driver-x86@vger.kernel.org
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org, don@syst.com.br
Subject: Re: [PATCH] classmate-laptop: Added some keys present in other
 devices
Message-ID: <20100301210639.GD1471@holoscopio.com>
References: <1267201611-4134-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Content-Disposition: inline
In-Reply-To: <1267201611-4134-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Matthew,

Can you merge this one, please? It's not in your tree.

Regards,
Cascardo.

On Fri, Feb 26, 2010 at 01:26:51PM -0300, Thadeu Lima de Souza Cascardo wro=
te:
> Some new devices have extra keys, which we add to our list. Currently,
> they all generate events that allow us to use a simple table/array,
> without need for the sparse keymap.
>=20
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/platform/x86/classmate-laptop.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x=
86/classmate-laptop.c
> index e315019..9bdd269 100644
> --- a/drivers/platform/x86/classmate-laptop.c
> +++ b/drivers/platform/x86/classmate-laptop.c
> @@ -508,6 +508,10 @@ static int cmpc_keys_codes[] =3D {
>  	KEY_BRIGHTNESSDOWN,
>  	KEY_BRIGHTNESSUP,
>  	KEY_VENDOR,
> +	KEY_UNKNOWN,
> +	KEY_CAMERA,
> +	KEY_BACK,
> +	KEY_FORWARD,
>  	KEY_MAX
>  };
> =20
> --=20
> 1.6.6.1
>=20

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuMLF8ACgkQyTpryRcqtS3S3gCggSjs4y408ZFBmoTy7lNrLF+3
me4AoI+PL5/L8WzwQPzyz+6yOfhnOYlV
=vE6N
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
