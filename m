Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab0CGHIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 02:08:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42907 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0CGHH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 02:07:59 -0500
Date: Sun, 7 Mar 2010 18:07:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       kay.sievers@vrfy.org, gregkh@suse.de
Subject: Re: [RFC] drivercore: Add of_match_table to the common device
 drivers
Message-Id: <20100307180744.956998c5.sfr@canb.auug.org.au>
In-Reply-To: <20100307064111.1442.63478.stgit@angua>
References: <20100307064111.1442.63478.stgit@angua>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__7_Mar_2010_18_07_44_+1100_t/SLSVRYrNVMKvge"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__7_Mar_2010_18_07_44_+1100_t/SLSVRYrNVMKvge
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Just a quick note:

On Sat, 06 Mar 2010 23:47:00 -0700 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asi=
c.c
> index 67fe13f..a5806ab 100644
> --- a/drivers/macintosh/macio_asic.c
> +++ b/drivers/macintosh/macio_asic.c
> @@ -40,8 +40,7 @@ static struct macio_chip      *macio_on_hold;
>  static int macio_bus_match(struct device *dev, struct device_driver *drv=
)=20
>  {
>  	struct macio_dev * macio_dev =3D to_macio_device(dev);
> -	struct macio_driver * macio_drv =3D to_macio_driver(drv);
> -	const struct of_device_id * matches =3D macio_drv->match_table;
> +	const struct of_device_id * matches =3D drv->match_table;
                                                   ^^^^^^^^^^^
of_match_table

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__7_Mar_2010_18_07_44_+1100_t/SLSVRYrNVMKvge
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuTUMAACgkQjjKRsyhoI8xYvgCfSaC9bQ7bF9GWY3q/HYpa96fm
h4wAn0u1SZgN6+q95twIDeqPglbbcxlX
=zF28
-----END PGP SIGNATURE-----

--Signature=_Sun__7_Mar_2010_18_07_44_+1100_t/SLSVRYrNVMKvge--
