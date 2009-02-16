Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZBPKNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZBPKNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 05:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbZBPKNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 05:13:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50427 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbZBPKNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:13:24 -0500
Date: Mon, 16 Feb 2009 21:13:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Sachin P. Sant" <sachinp@in.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, avorontsov@ru.mvista.com
Subject: Re: next Feb 16 build break [usb/host/fhci-*]
Message-Id: <20090216211310.5513de1a.sfr@canb.auug.org.au>
In-Reply-To: <499929CB.2030004@in.ibm.com>
References: <20090216172016.f1d159a7.sfr@canb.auug.org.au>
	<499929CB.2030004@in.ibm.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__16_Feb_2009_21_13_10_+1100_TqEd_u.lQ=vsPHs1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Feb_2009_21_13_10_+1100_TqEd_u.lQ=vsPHs1
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sachin,

On Mon, 16 Feb 2009 14:24:35 +0530 "Sachin P. Sant" <sachinp@in.ibm.com> wr=
ote:
>
> Feb 16 next tree randconfig build fails with
>=20
> drivers/usb/host/fhci-hcd.c: In function =E2=80=98of_fhci_probe=E2=80=99:
> drivers/usb/host/fhci-hcd.c:586: error: =E2=80=98struct device=E2=80=99 h=
as no member named =E2=80=98bus_id=E2=80=99
> drivers/usb/host/fhci-hcd.c:653: error: =E2=80=98struct device=E2=80=99 h=
as no member named =E2=80=98bus_id=E2=80=99
>=20
> drivers/usb/host/fhci-dbg.c: In function =E2=80=98fhci_dfs_create=E2=80=
=99:
> drivers/usb/host/fhci-dbg.c:111: error: =E2=80=98struct device=E2=80=99 h=
as no member named =E2=80=98bus_id=E2=80=99

That would be the driver-core removing bus_id from struct device.  cc's add=
ed.

fhci-hcd appeared between 2.6.29-rc2 and rc3.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__16_Feb_2009_21_13_10_+1100_TqEd_u.lQ=vsPHs1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmZPDYACgkQjjKRsyhoI8xBIQCeNJrwIAuqISX0YJ/BoldOq4r1
yVAAn1Qs2FK31zyGV6jsFYprIr7jNoB2
=bsbL
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Feb_2009_21_13_10_+1100_TqEd_u.lQ=vsPHs1--
