Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYHGFJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYHGFJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 01:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYHGFJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 01:09:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43606 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbYHGFJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 01:09:32 -0400
Date: Thu, 7 Aug 2008 14:40:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Brownell <david-b@pacbell.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, dwmw2@infradead.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 5 (MTD build error)
Message-Id: <20080807144027.f805c7b1.sfr@canb.auug.org.au>
In-Reply-To: <200808060413.08723.david-b@pacbell.net>
References: <20080805175914.7649537f.sfr@canb.auug.org.au>
	<20080805175518.9fc09b92.randy.dunlap@oracle.com>
	<200808060320.20064.david-b@pacbell.net>
	<200808060413.08723.david-b@pacbell.net>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Aug_2008_14_40_27_+1000_hHhkR6MQhuzFyJap"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Aug_2008_14_40_27_+1000_hHhkR6MQhuzFyJap
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Wed, 6 Aug 2008 04:13:08 -0700 David Brownell <david-b@pacbell.net> wrot=
e:
>
> On Wednesday 06 August 2008, David Brownell wrote:
> > On Tuesday 05 August 2008, Randy Dunlap wrote:
> > >=20
> > > linux-next-20080805/drivers/mtd/devices/mtd_dataflash.c: In function =
'add_dataflash_otp':
> > > linux-next-20080805/drivers/mtd/devices/mtd_dataflash.c:670: error: t=
oo many arguments to function 'otp_setup'
>=20
> Whoops, sorry ... I see what was going on.  My bad.
>=20
> --- g26.orig/drivers/mtd/devices/mtd_dataflash.c	2008-08-06 04:12:45.0000=
00000 -0700
> +++ g26/drivers/mtd/devices/mtd_dataflash.c	2008-08-06 04:11:55.000000000=
 -0700
> @@ -616,7 +616,7 @@ static char *otp_setup(struct mtd_info *
> =20
>  #else
> =20
> -static char *otp_setup(struct mtd_info *device)
> +static char *otp_setup(struct mtd_info *device, char revision)
>  {
>  	return " (OTP)";
>  }
>=20

I will add this patch to linux-next today in the hope it will be
integrated somewhere soon (hint, hint :-)).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Aug_2008_14_40_27_+1000_hHhkR6MQhuzFyJap
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiafLsACgkQjjKRsyhoI8xjCwCfYHSNDPrvgO6X5Egfc5gbu2nR
oioAn0S+vzgDMXb305h24GKf4Ew1F4YW
=oU/m
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Aug_2008_14_40_27_+1000_hHhkR6MQhuzFyJap--
