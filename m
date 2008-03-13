Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYCMAL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYCMAL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 20:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYCMALt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 20:11:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51981 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbYCMALs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 20:11:48 -0400
Date: Thu, 13 Mar 2008 11:10:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: York Sun <yorksun@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] Driver for Freescale 8610 and 5121 DIU
Message-Id: <20080313111029.55c74396.sfr@canb.auug.org.au>
In-Reply-To: <12053582231281-git-send-email-yorksun@freescale.com>
References: <12053582234100-git-send-email-yorksun@freescale.com>
	<12053582231281-git-send-email-yorksun@freescale.com>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Mar_2008_11_10_29_+1100_on1X=JxsAQNs1mNA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Mar_2008_11_10_29_+1100_on1X=JxsAQNs1mNA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi York,

Just a few things from a first pass.

On Wed, 12 Mar 2008 16:43:42 -0500 York Sun <yorksun@freescale.com> wrote:
>
> +++ b/drivers/video/fsl-diu-fb.c
>
> +#include <asm/of_platform.h>

Please include <linux/of_platform.h> instead.

> +/* Align to 64-bit(8-byte), 32-byte, etc. */
> +static int allocate_buf(struct diu_addr *buf, u32 size, u32 bytes_align)
> +{
>
> +	buf->vaddr =3D dma_alloc_coherent(0, ssize,
> +					(dma_addr_t *) &(buf->paddr),

This cast is unnecessary as buf->paddr is a dma_addr_t ...

> +++ b/drivers/video/fsl-diu-fb.h
>
> +static struct fb_videomode __devinitdata fsl_diu_default_mode =3D {
> +static struct fb_videomode __devinitdata fsl_diu_mode_db[] =3D {

Why are these in the .h file?  They should be in the .c file.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Mar_2008_11_10_29_+1100_on1X=JxsAQNs1mNA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH2HD5TgG2atn1QN8RArSjAJ91lNPhlZm3Z9ZmoceENm9mYY/HUgCeNwaq
udTkfvbS8CPQjADmFiv6OHM=
=HYwh
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Mar_2008_11_10_29_+1100_on1X=JxsAQNs1mNA--
