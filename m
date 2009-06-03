Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbZFCP32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbZFCP32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbZFCP3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:29:19 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbZFCP3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:29:17 -0400
Subject: Re: linux-next: Tree for June 3 (rfkill)
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A269539.8020607@oracle.com>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
	 <4A269539.8020607@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QkqTClLmTdUR2xiL+kR+"
Date: Wed, 03 Jun 2009 17:29:10 +0200
Message-Id: <1244042950.4862.10.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QkqTClLmTdUR2xiL+kR+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-03 at 08:22 -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:

> CFG80211=3Dy
> MAC80211=3Dy
> RFKILL=3Dm
>=20
> net/built-in.o: In function `cfg80211_netdev_notifier_call':
> core.c:(.text+0xa678b): undefined reference to `rfkill_blocked'
> net/built-in.o: In function `cfg80211_dev_free':

Hrm. I thought

config CFG80211
	tristate "Improved wireless configuration API"
	depends on RFKILL || !RFKILL

would avoid that. Why doesn't it?

johannes

--=-QkqTClLmTdUR2xiL+kR+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJpbCAAoJEODzc/N7+Qma29UP/31xLzunD84G90EkhPiI2twv
+fhSiLtA/o30bghV3NRKAuq5f+SmoCJzrPvl6uUzZ8RTLrHxKp2Ur5MC2bOqgWm+
7v7j6uBv/LuHMuNdcXmGQWvzQQbSIckWzeuo2oizaMjxnxB7+FCX4titM34ileFD
S5HYEEyP9/Y6Tfdmj6Nkvt+9JhXx2U3C5P4jkfzXs7nVZnODoEjkgQxavWQy341V
bVQdfnCPf8RgbYpopUkb1ovZc8DkUBbkLku8w+eRtSmm0D/pMO9xSla4/lqCMhqU
f5cc7wL5MnZPvx13hjuP13P+vxC5aKXs+XdH0c1bpasxQ5wWtwmsoF56NJ7Y/mbX
G19KxOMfANWe/Xer7Hk+tkxQx3Q7BrRPUENFgjSbaBhQoaCuLfET+3CCRx7JS823
3OplGgu6YLuzvPE/OjFI8yL9pe77251U8y76QP5cmso/IWqaihA/vdELfO69x8S9
1wr/Me0jTn2zF+/q6Lhs4VE+fB3MRZ+xHt+ue61c9zqKPQmZk6SGENpf4IIxtbA2
RSJoEhbdMTCRbLcSI9WjZWamCJIuTvwNcGBGcj7BvulTlc4W5NcoXLHpamvlFk3n
cEFLnwGCv6jgDerv2+2Bv6mxyuch94xZWuGYoZ6mv5QCGjo9PZFOjvSNHn+gaxc3
j0/RtkqHYxVrxGPTqf8v
=yF4V
-----END PGP SIGNATURE-----

--=-QkqTClLmTdUR2xiL+kR+--

