Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZL2UCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZL2UCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZL2UCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:02:50 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:43208 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbZL2UCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:02:48 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 3/5] drivers/scsi : Correct the size argument to kmalloc
Date: Tue, 29 Dec 2009 21:02:42 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.85; i686; ; )
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0912292015420.4001@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912292015420.4001@ask.diku.dk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1699455.DbQ32g4QYV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200912292102.43373.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1699455.DbQ32g4QYV
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>=20
> In each case, the destination of the allocation has type struct **, so the
> elements of the array should have pointer type, not structure type.

Maybe they should even by kcalloc'ed?

Eike

--nextPart1699455.DbQ32g4QYV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAks6YGMACgkQXKSJPmm5/E6KCQCgnrkOEo9hY7DsSefSyUa1QSdj
2isAn2F4oFROAFlqgHz5UWGrRjyh+yGp
=scYj
-----END PGP SIGNATURE-----

--nextPart1699455.DbQ32g4QYV--
