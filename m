Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbYBJWWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbYBJWWl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 17:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYBJWWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 17:22:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44193 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYBJWWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 17:22:31 -0500
Date: Mon, 11 Feb 2008 09:22:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Julia Lawall <julia@diku.dk>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/8] drivers/block: Use FIELD_SIZEOF
Message-Id: <20080211092224.4181928b.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0802102108000.23906@ask.diku.dk>
References: <Pine.LNX.4.64.0802102108000.23906@ask.diku.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__11_Feb_2008_09_22_24_+1100_VqWY6yVHBSQ4eUZw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Feb_2008_09_22_24_+1100_VqWY6yVHBSQ4eUZw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Feb 2008 21:08:49 +0100 (CET) Julia Lawall <julia@diku.dk> wrote:
>
> From: Julia Lawall <julia@diku.dk>
>=20
> Robert P.J. Day proposed to use the macro FIELD_SIZEOF in replace of code
> that matches its definition.
>=20
> The modification was made using the following semantic patch
> (http://www.emn.fr/x-info/coccinelle/)
>=20
> // <smpl>
> @haskernel@
> @@
>=20
> #include <linux/kernel.h>
>=20
> @depends on haskernel@
> type t;
> identifier f;
> @@
>=20
> - (sizeof(((t*)0)->f))
> + FIELD_SIZEOF(t, f)
>=20
> @depends on haskernel@
> type t;
> identifier f;
> @@
>=20
> - sizeof(((t*)0)->f)
> + FIELD_SIZEOF(t, f)
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__11_Feb_2008_09_22_24_+1100_VqWY6yVHBSQ4eUZw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHr3kkTgG2atn1QN8RAsIIAJoC1YVTppVwPlh/POyn59J6fpQEQgCfb6gy
20Lr+YFGUZNp/UemKhsA874=
=DbZf
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Feb_2008_09_22_24_+1100_VqWY6yVHBSQ4eUZw--
