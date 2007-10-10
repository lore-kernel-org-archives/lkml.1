Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbXJJSWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbXJJSWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 14:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbXJJSWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 14:22:30 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:49967 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbXJJSW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 14:22:29 -0400
Date: Wed, 10 Oct 2007 20:22:23 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       davej@codemonkey.org.uk, akpm@osdl.org, linux-sparse@vger.kernel.org,
       Alex Dubov <oakad@yahoo.com>
Subject: Re: idio{,ma}tic typos (was Re: +
 fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree)
Message-ID: <20071010202223.292176a1@poseidon.drzeus.cx>
In-Reply-To: <20071010104540.GA6366@localhost.sw.ru>
References: <20071010104540.GA6366@localhost.sw.ru>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-2283-1192040518-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-2283-1192040518-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Oct 2007 14:45:40 +0400
Alexey Dobriyan <adobriyan@sw.ru> wrote:

> ["if (!x & y)" patch from yanzheng@]
> ["if (!x & y)" patch from adobriyan@]
> ["if (!x & y)" patches from viro@]
>=20
> While we're at it, below is somewhat ugly sparse patch for detecting
> "&& 0x" typos.
>=20

The maintainer for tifm is Alex Dubov, so cc:ing him.

> drivers/mmc/host/tifm_sd.c:183:9: warning: dubious && 0x
>=20
> 	if ((r_data->flags & MMC_DATA_WRITE)
>             && DATA_CARRY)
> 		writel(host->bounce_buf_data[0],
> 		host->dev->addr
> 		+ SOCK_MMCSD_DATA);
>=20
> 	given that DATA_CARRY is always used together with
> ->cmd_flags, this place is asking for obvious fixlet:
>=20
>=20
> [PATCH] tifm_sd.c: fix DATA_CARRY check
>=20
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
>=20
>  drivers/mmc/host/tifm_sd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/drivers/mmc/host/tifm_sd.c
> +++ b/drivers/mmc/host/tifm_sd.c
> @@ -180,7 +180,7 @@ static void tifm_sd_transfer_data(struct tifm_sd
> *host) host->sg_pos++;
>  			if (host->sg_pos =3D=3D host->sg_len) {
>  				if ((r_data->flags & MMC_DATA_WRITE)
> -				    && DATA_CARRY)
> +				    && (host->cmd_flags &
> DATA_CARRY)) writel(host->bounce_buf_data[0],
>  					       host->dev->addr
>  					       + SOCK_MMCSD_DATA);
>=20
>=20
>=20

Rgds
Pierre

--=_hera.drzeus.cx-2283-1192040518-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHDRhh7b8eESbyJLgRAglQAJ9tJ7VSsyuI7LIV4fi6WDHR/S1SugCgyjSI
O17f7Z+JemtEcXFjPl33wFI=
=KhSs
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-2283-1192040518-0001-2--
