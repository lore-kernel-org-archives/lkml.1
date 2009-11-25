Return-Path: <linux-kernel-owner+w=401wt.eu-S964918AbZKYOfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964918AbZKYOfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934717AbZKYOfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:35:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43211 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934659AbZKYOfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:35:05 -0500
Date: Thu, 26 Nov 2009 01:35:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?IlJpY2hhcmQgUsO2amZvcnMi?= 
	<richard.rojfors@mocean-labs.com>,
       spi-devel-general@lists.sourceforge.net
Subject: Re: linux-next: spi tree build warning
Message-Id: <20091126013505.037e5751.sfr@canb.auug.org.au>
In-Reply-To: <fa686aa40911250630h764c4f26xb2e7cc735261e987@mail.gmail.com>
References: <20091125212959.601673f5.sfr@canb.auug.org.au>
	<fa686aa40911250630h764c4f26xb2e7cc735261e987@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Nov_2009_01_35_05_+1100_tbhnh57s9se/R6kc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Nov_2009_01_35_05_+1100_tbhnh57s9se/R6kc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Wed, 25 Nov 2009 07:30:19 -0700 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> Trivial fix committed to next-spi branch:
>=20
> diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
> index b927812..9f38637 100644
> --- a/drivers/spi/xilinx_spi.c
> +++ b/drivers/spi/xilinx_spi.c
> @@ -408,8 +408,8 @@ struct spi_master *xilinx_spi_init(struct device *dev=
, struc
>                 goto free_irq;
>         }
>=20
> -       dev_info(dev, "at 0x%08X mapped to 0x%08X, irq=3D%d\n",
> -               (u32)mem->start, (u32)xspi->regs, xspi->irq);
> +       dev_info(dev, "at 0x%08llX mapped to 0x%p, irq=3D%d\n",
> +               (unsigned long long)mem->start, xspi->regs, xspi->irq);
>         return master;

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Nov_2009_01_35_05_+1100_tbhnh57s9se/R6kc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksNQJkACgkQjjKRsyhoI8xBwgCeO+SzowWVPNo2nHEM1u6qkKIl
6fgAn0GHimYYVopCh9h954oQAW2rFygD
=MEzm
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Nov_2009_01_35_05_+1100_tbhnh57s9se/R6kc--
