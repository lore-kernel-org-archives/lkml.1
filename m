Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbZJKJwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbZJKJwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZJKJwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:52:11 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZJKJwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:52:10 -0400
Subject: Re: [mmotm 2009-10-09-01-07] b43/wireless possible circular locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, bcm43xx-dev@lists.berlios.de,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091011094139.GA2778@darkstar>
References: <20091011094139.GA2778@darkstar>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DMU5TS23gmKbTQaiVcnz"
Date: Sun, 11 Oct 2009 11:51:27 +0200
Message-Id: <1255254687.4095.46.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DMU5TS23gmKbTQaiVcnz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-10-11 at 17:41 +0800, Dave Young wrote:
> Hi,
>=20
> I got lockdep warnings about possible circular lock with
> b43 interface startup. It looks like a real problem.
>=20
> [   71.974542] wlan0: deauthenticating from 00:19:e0:db:24:de by local ch=
oice (reason=3D3)
> [   72.004352] b43-phy0 debug: Removing Interface type 2
> [   72.005431]=20
> [   72.005435] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   72.006168] [ INFO: possible circular locking dependency detected ]
> [   72.006759] 2.6.32-rc3-mm1 #4
> [   72.007047] -------------------------------------------------------
> [   72.007617] ifconfig/2175 is trying to acquire lock:
> [   72.007617]  (&(&rfkill->poll_work)->work){+.+...}, at: [<c0239375>] _=
_cancel_work_timer+0x8c/0x18e
> [   72.007617]=20
> [   72.007617] but task is already holding lock:
> [   72.007617]  (&wl->mutex){+.+.+.}, at: [<f8fa5359>] b43_op_stop+0x28/0=
x6a [b43]

I believe this is already taken care of by Larry.

johannes

--=-DMU5TS23gmKbTQaiVcnz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK0aqcAAoJEODzc/N7+Qma8WcQAInEII4zTiCniG8SUrC2OcGx
4IpFUwP8+sxdBErWBbTb3Jzrv6qtgEtCCEbnefzaQkNW/3izgj04T4TXgvOPabqg
fJclT9wDZBMKgnpKNnF5qNTkXSlSWsxarvQW2CjeV5PIsREF1ZLNJyIN+pQT4Bov
t71ommcdxJCBOXwrlQ+dabiuxDv+RPf4HqyY+dcGW4gvpTJS1LR6ScPzeX3Jgn7W
/H674OxCRDIA1Uk7yRvjnqxJLvjTbyIp9Z5L46+Dv9k8SZuY1eNJ39rwlAMgf4qZ
Lt9XIpGIRKS8tpOTlR5PNFcxzw8jnITlTZuuGq50jzfNN9vrcHJcGkQyxOY+NkEL
A+AU/EqlgDSZ+72DAMoEM/N3ALmUHycP4FEzDdzDUEGgpL8w+oiJMfOvtWxxvRH+
xc0dRq5nJGLSt/hs+G79nfFfAEb62dLj+rYMpHkaA5C66cz6xjd0lp1TiZixKnbl
CbEv1I3u6np5tBFbBlC1F2IxUlQ3DBhSG1fNX2/Ivjn8tTkDeidWuUzgR4mZuGz+
gLJaH5J984m8UxfuPhhrpsmzI110oqe/SCxDA1digjc+/as2p4nqAMUqFiBg00MH
4SfOHEC67LmqsOW3ol2FmvicBwKjScvrs9BIAp+XVdWTVfjtLbIYrkixS+hBOuWt
mRn2GKV+Uxpv/RWFca5s
=5l5U
-----END PGP SIGNATURE-----

--=-DMU5TS23gmKbTQaiVcnz--

