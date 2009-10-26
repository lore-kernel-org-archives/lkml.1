Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZJZHxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZJZHxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZJZHxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:53:09 -0400
Received: from mail.nomovok.com ([83.150.122.238]:37749 "EHLO mail.nomovok.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbZJZHxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:53:08 -0400
Subject: Re: [PATCH] fix hso soft-lockup
From: Antti =?ISO-8859-1?Q?Kaijanm=E4ki?= <antti.kaijanmaki@nomovok.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1256200578.3057.113.camel@nomovok.homedomain>
References: <1256200578.3057.113.camel@nomovok.homedomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9nee1o9x7WnGMjKTcHKK"
Date: Mon, 26 Oct 2009 09:53:04 +0200
Message-ID: <1256543584.3591.2.camel@nomovok.homedomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9nee1o9x7WnGMjKTcHKK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-22 at 11:36 +0300, Antti Kaijanm=C3=A4ki wrote:
> Fix soft-lockup in hso.c which is triggered on SMP machine when
> modem is removed while file descriptor(s) under /dev are still open:
>=20
>   old version called kref_put() too early which resulted in destroying
>   hso_serial and hso_device objects which were still used later on.
>=20
> Also fix driver debug routines (not compiled in by default).

I created a new bug report out of this with some additional info:

    http://bugzilla.kernel.org/show_bug.cgi?id=3D14469


 -- Antti


--=-9nee1o9x7WnGMjKTcHKK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrlVVkACgkQJ/yWUtJ8RGqTIgCfWH/3QF1oDIxjQ7RFcu2w/uhE
7rAAn3RnI7i+9av0hImhC+y9FDsE2Bpe
=WrPz
-----END PGP SIGNATURE-----

--=-9nee1o9x7WnGMjKTcHKK--

