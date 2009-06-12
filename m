Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbZFLMLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbZFLMLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZFLMLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:11:34 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:59585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZFLMLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:11:34 -0400
Subject: Re: linux-next: Tree for June 11 (bluetooth/rfkill)
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, marcel@holtmann.org
In-Reply-To: <4A318519.2080708@oracle.com>
References: <20090611191420.1f4d5e4f.sfr@canb.auug.org.au>
	 <4A318519.2080708@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vE68nYjUDZRxZ0Sn3FzT"
Date: Fri, 12 Jun 2009 14:12:06 +0200
Message-Id: <1244808726.29447.11.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vE68nYjUDZRxZ0Sn3FzT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-11 at 15:28 -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Changes since 20090610:
>=20
>=20
> CONFIG_RFKILL=3Dm
> CONFIG_BT=3Dy
>=20
> (.text+0xb7bf7): undefined reference to `rfkill_unregister'
> (.text+0xb7c03): undefined reference to `rfkill_destroy'
> (.text+0xb962f): undefined reference to `rfkill_blocked'
> (.text+0xba173): undefined reference to `rfkill_alloc'
> (.text+0xba187): undefined reference to `rfkill_register'
> (.text+0xba197): undefined reference to `rfkill_destroy'

This one's not my fault :) Marcel did that, the solution as usual is to
	depends on RFKILL || !RFKILL

:)

johannes

--=-vE68nYjUDZRxZ0Sn3FzT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMkYRAAoJEODzc/N7+QmaLXQP/2c/qpEkO0hJ/jzCAw3rUTZy
G9qvaoZjoAxRK5Jk21uoTIfjBsi2ed6d0c13SzZOkwjLJp5/b0H5RTyRCUbRzSwT
GhYls8tkY/rqhtuxBNCOGASklmI0jFpejOIViWD0RsllJ1Q4LlaFbTD02xFHox2+
F4HIkR+a+x2XWPCjgnWxV9bwnN1fh4Wvt5XpUniYsjIfvmfF1ha0ENdzqkapRA72
CPmuxGJxQBO2U69TkGmrTtg5XZVqtCQvUs5fP0ygcb6uidqzBjFiI40BUmWMmhek
5dsqIKcrsuuQwP5G3qCMeLNkr21jsx+WHsxh997qvmPMGNmbfkk0iRoAbxuGY2Ne
UrouZ6+0HjWiJWZfjG5OPTC079F0IHo8WL6yBYTj9JuQUizlr4xvLKyf9oKot+iw
20u8I0Gxmp1PgCkGS+t/oNBsSnWwBZFhZ5Jl4jztktDiKnKaOHfQ3oxO5ITD1g9E
sq7L4A9kjtnwuIx+8Mw8fTNmrrLc4ouDblFdJko2Z2T9bdrP4QrX5ogl434BTfeL
+SC22mslV1XmYjRfXbmuE6yxy7Kz4HbD8cAvhAUYtI+aSUb+lKd1dVZe+HDKp7sm
+3XSJJjB+aPEJPyN8rPNYXJZn49nIptiR+U2bgLv2AMNFFVS3UVeIQCRK9icVMcA
aql0orFngAKcxer1h+dK
=XOnr
-----END PGP SIGNATURE-----

--=-vE68nYjUDZRxZ0Sn3FzT--

