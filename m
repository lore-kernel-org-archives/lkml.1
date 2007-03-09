Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbXCIJES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbXCIJES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXCIJER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:04:17 -0500
Received: from vesl.donpac.ru ([80.254.111.33]:38422 "EHLO vesl.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbXCIJEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:04:15 -0500
Date: Fri, 9 Mar 2007 12:04:11 +0300
To: Amit Choudhary <amit2030@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/media/video/videocodec.c: check kmalloc() return value.
Message-ID: <20070309090411.GC18056@pazke.donpac.ru>
Mail-Followup-To: Amit Choudhary <amit2030@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070308231401.42679647.amit2030@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
Content-Disposition: inline
In-Reply-To: <20070308231401.42679647.amit2030@gmail.com>
X-Uname: Linux 2.6.18-1-amd64 x86_64
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andrey Panin <pazke@donpac.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 067, 03 08, 2007 at 11:14:01PM -0800, Amit Choudhary wrote:
> Description: Check the return value of kmalloc() in function videocodec_b=
uild_table(), in file drivers/media/video/videocodec.c.
>=20
> Signed-off-by: Amit Choudhary <amit2030@gmail.com>
>=20
> diff --git a/drivers/media/video/videocodec.c b/drivers/media/video/video=
codec.c
> index 2ae3fb2..16fc1dd 100644
> --- a/drivers/media/video/videocodec.c
> +++ b/drivers/media/video/videocodec.c
> @@ -348,6 +348,8 @@ #define LINESIZE 100
>  	kfree(videocodec_buf);
>  	videocodec_buf =3D (char *) kmalloc(size, GFP_KERNEL);
> =20
> +	if (!videocodec_buf)
> +		return 0;
>  	i =3D 0;
>  	i +=3D scnprintf(videocodec_buf + i, size - 1,
>  		      "<S>lave or attached <M>aster name  type flags    magic    ");

Can you also remove useless (char *) cast above ?

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFF8SMLIWZCBzwS8mkRAu3VAJwL7UKssB9zoyFU+8wruTpzEGQCGwCeOT2W
DsF7sxI+yAA+0fIXRLpo/2Y=
=CCtZ
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
