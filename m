Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYL2MmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYL2MmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYL2MmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:42:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:49954 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYL2MmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:42:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer;
        b=GlPWeQeUGXhNLet5t1FZyEeVqx7UqEQ3kmbNi2FpF3dqQ3u1yjdIjQ3KxgPmukmwQ3
         I8ihLLXCdTR1RJcen/9eXT3H8xTsmHcuO8lF3mec3/Z3U/J20iYGOas8LpNKTiZBKnba
         NOINef8kkcukEBlAIhdMGS8d1Q/5XAv+rgM9Q=
Subject: Re: fs/cifs/cifsfs.c Compilation error latest git
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, sfrench@samba.org,
       linux-cifs-client@lists.samba.org
In-Reply-To: <200812290039.28638.a.miskiewicz@gmail.com>
References: <1230507271.27845.4.camel@varda>
	 <200812290039.28638.a.miskiewicz@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FTFm7FYNTlIEa9iSv7+f"
Date: Mon, 29 Dec 2008 13:42:08 +0100
Message-Id: <1230554528.5701.1.camel@varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FTFm7FYNTlIEa9iSv7+f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

El lun, 29-12-2008 a las 00:39 +0100, Arkadiusz Miskiewicz escribi=C3=B3:
> On Monday 29 of December 2008, Alejandro Riveira Fern=C3=A1ndez wrote:
> > $ git describe
> > v2.6.28-2929-g541ef5c
>=20
> Something like:
>=20
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 974c8f0..79411d4 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -361,8 +361,7 @@ cifs_show_options(struct seq_file *s, struct vfsmount=
 *m)
>                                         switch (server->addr.sockAddr6.
>                                                 sin6_family) {
>                                         case AF_INET6:
> -                                               seq_printf(s, NIP6_FMT,
> -                                                          NIP6(server->a=
ddr.sockAddr6.sin6_addr));
> +                                               seq_printf(s, "%p6", &ser=
ver->addr.sockAddr6.sin6_addr);
>                                                 break;
>                                         case AF_INET:
>                                                 seq_printf(s, NIPQUAD_FMT=
,
>=20
>=20

git am does not like this email on top of v2.6.28-2929-g541ef5c so
i did the change manually and it works thanks.

>=20

--=-FTFm7FYNTlIEa9iSv7+f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta parte del mensaje =?ISO-8859-1?Q?est=E1?= firmada
 digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklYxZsACgkQ3GEkiSnUSOEqOwCeJNvAP9u474cYYWvmeObeDFGw
uS8AnRZP8gDrAt607Nh0fiydgmB0UCor
=UfxE
-----END PGP SIGNATURE-----

--=-FTFm7FYNTlIEa9iSv7+f--

