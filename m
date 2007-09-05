Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbXIEGMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbXIEGMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 02:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbXIEGMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 02:12:43 -0400
Received: from donetsk.donpac.ru ([80.254.111.38]:40803 "EHLO
	donetsk.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbXIEGMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 02:12:42 -0400
Date: Wed, 5 Sep 2007 10:12:37 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ICH Intel PATA short cable override...
Message-ID: <20070905061237.GC6882@pazke.donpac.ru>
Mail-Followup-To: Daniel J Blueman <daniel.blueman@gmail.com>,
	Tejun Heo <htejun@gmail.com>, jgarzik@pobox.com,
	linux-ide@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <6278d2220709040537n4c96ffcagd9c25c94ddd29ca1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Content-Disposition: inline
In-Reply-To: <6278d2220709040537n4c96ffcagd9c25c94ddd29ca1@mail.gmail.com>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 247, 09 04, 2007 at 01:37:22PM +0100, Daniel J Blueman wrote:
> We see that in ata_piix.c, there is a whitelist for (laptop) Intel ICH
> controllers with short cables, tied to specific vendor subsystem IDs.
> Since my mini-ITX Ibase MI910F has the subsystem IDs specified as
> Intel [1], this is unusable.
>=20
> I can't find another existing mechanism to add short cable
> information, to allow UDMA/66 for my on-board CF socket.

If this board has useful DMI information, you can add DMI quirk for it.
You can look at pata_via.c or pata_ali.c for example.

> Do you suggest I cook a patch to pass a kernel argument eg 'ich=3Dshort'
> or 'pata=3Dshort', or can you think of a better mechanism?
>=20
> Thanks,
>   Daniel
>=20
> --- [1]
>=20
> # lspci -vs 00:1f.2
> 00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
> SATA IDE Controller (rev 03) (prog-if 80 [Master])
>         Subsystem: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA
> IDE Controller
>=20
> # lspci -vns 00:1f.2
> 00:1f.2 0101: 8086:2828 (rev 03) (prog-if 80 [Master])
>         Subsystem: 8086:2828
> --=20
> Daniel J Blueman
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG3kjVIWZCBzwS8mkRAukxAKCPanOf1sslnzkqfa4KjXdaa+vC4gCgwMVn
GBUrjMuHlwDexLiOwWRBsxw=
=028w
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
