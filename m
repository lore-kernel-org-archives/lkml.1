Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbXDETYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbXDETYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 15:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767236AbXDETYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 15:24:24 -0400
Received: from lug-owl.de ([195.71.106.12]:34748 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbXDETYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 15:24:23 -0400
Date: Thu, 5 Apr 2007 21:24:21 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@canonical.com
Subject: Re: [PATCH] HPA support: Revised patch
Message-ID: <20070405192421.GB5131@lug-owl.de>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	kyle@canonical.com
References: <20070405141352.12fddb6e@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <20070405141352.12fddb6e@the-village.bc.nu>
X-Operating-System: Linux mail 2.6.12.3lug-owl 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-05 14:13:52 +0100, Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vani=
lla-2.6.21-rc5-mm4/drivers/ata/libata-core.c linux-2.6.21-rc5-mm4/drivers/a=
ta/libata-core.c
> --- linux.vanilla-2.6.21-rc5-mm4/drivers/ata/libata-core.c	2007-04-03 16:=
56:32.000000000 +0100
> +++ linux-2.6.21-rc5-mm4/drivers/ata/libata-core.c	2007-04-03 17:08:28.00=
0000000 +0100
> @@ -90,6 +90,10 @@
>  module_param_named(fua, libata_fua, int, 0444);
>  MODULE_PARM_DESC(fua, "FUA support (0=3Doff, 1=3Don)");
> =20
> +static int ata_ignore_hpa =3D 0;
> +module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
> +MODULE_PARM_DESC(ignore_hpa, "Ignore HPA (0=3Doff 1=3Don)");
> +
>  static int ata_probe_timeout =3D ATA_TMOUT_INTERNAL / HZ;
>  module_param(ata_probe_timeout, int, 0444);
>  MODULE_PARM_DESC(ata_probe_timeout, "Set ATA probing timeout (seconds)");

For ignore_hpa, it would be nice to not go through inverse logic and
fix the help text a bit (0=3Dhonor HPA, 1=3Dignore HPA).

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:            http://www.chiark.greenend.org.uk/~sgtatham/bugs.h=
tml
the second  :

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGFUzlHb1edYOZ4bsRAg10AJ9E4doOUgLzqrA90M6zj3E7hrOlaACfRgX2
XKTpPvK9gYkzIs7j05z28qY=
=5BK9
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
