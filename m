Return-Path: <linux-kernel-owner+w=401wt.eu-S1757681AbZKDSUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbZKDSUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZKDSUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:20:13 -0500
Received: from smtp6.netcologne.de ([194.8.194.26]:41609 "EHLO
	smtp6.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581AbZKDSUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:20:12 -0500
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2009 13:20:12 EST
Date: Wed, 04 Nov 2009 19:12:21 +0100
From: Albrecht =?iso-8859-1?b?RHJl3w==?= <albrecht.dress@arcor.de>
Subject: Re: Fwd: [PATCH] arch/powerpc: Improve _memcpy
To: Chris Friesen <cfriesen@nortel.com>,
       Grant Likely <grant.likely@secretlab.ca>
Cc: Linux kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Dirk Eibach <eibach@gdsys.de>
In-Reply-To: <4AF084C6.3020602@nortel.com> (from cfriesen@nortel.com on Tue
	Nov  3 20:30:14 2009)
X-Mailer: Balsa 2.4.1
Message-Id: <1257358349.2489.0@antares>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg=PGP-SHA1; boundary="=-oJok7Z4CP/8vAK7zhpA/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-oJok7Z4CP/8vAK7zhpA/
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

See <http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-May/072582.html>. =
 =20
Any chance to get this one into the tree?  Grant?

Cheers, Albrecht.

Am 03.11.09 20:30 schrieb(en) Chris Friesen:
>=20
> Forwarding to the ppc mailing list.
>=20
> Chris
>=20
>=20
> -------- Original Message --------
> Subject: [PATCH] arch/powerpc: Improve _memcpy
> Date: Tue,  3 Nov 2009 15:20:56 +0100
> From: Dirk Eibach <eibach@gdsys.de>
> To: linux-kernel@vger.kernel.org
> CC: Dirk Eibach <eibach@gdsys.de>
>=20
> The implementation of _memcpy_fromio and _memcpy_toio seems to be
> suboptimal for size 4.
>=20
> Signed-off-by: Dirk Eibach <eibach@gdsys.de>
> ---
>  arch/powerpc/kernel/io.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/powerpc/kernel/io.c b/arch/powerpc/kernel/io.c
> index 1882bf4..8dc7547 100644
> --- a/arch/powerpc/kernel/io.c
> +++ b/arch/powerpc/kernel/io.c
> @@ -161,7 +161,7 @@ void _memcpy_fromio(void *dest, const volatile void
> __iomem *src,
>  		dest++;
>  		n--;
>  	}
> -	while(n > 4) {
> +	while(n >=3D 4) {
>  		*((u32 *)dest) =3D *((volatile u32 *)vsrc);
>  		eieio();
>  		vsrc +=3D 4;
> @@ -190,7 +190,7 @@ void _memcpy_toio(volatile void __iomem *dest, const
> void *src, unsigned long n)
>  		vdest++;
>  		n--;
>  	}
> -	while(n > 4) {
> +	while(n >=3D 4) {
>  		*((volatile u32 *)vdest) =3D *((volatile u32 *)src);
>  		src +=3D 4;
>  		vdest +=3D 4;
> --
> 1.5.6.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>=20
>=20


--=-oJok7Z4CP/8vAK7zhpA/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iD8DBQBK8cQNn/9unNAn/9ERAhoJAKCMYURtoUiTBFh9FJDvVAPafU/S3wCfSPf3
C1aooTfXAkeU66JsXf0+fSU=
=sxSi
-----END PGP SIGNATURE-----

--=-oJok7Z4CP/8vAK7zhpA/--
