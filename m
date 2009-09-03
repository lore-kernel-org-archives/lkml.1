Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbZICSM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbZICSM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZICSM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:12:58 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbZICSM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:12:58 -0400
Subject: Re: Exporting kmemleak.h to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <43e72e890909031106q1dc3ebf0nb5281e2aeddd215e@mail.gmail.com>
References: <43e72e890909021729q7c40f907v7a81eaf5c8b73a61@mail.gmail.com>
	 <84144f020909022323na828156v4eb9a8497cadaef8@mail.gmail.com>
	 <1251983939.22485.18.camel@pc1117.cambridge.arm.com>
	 <1251984845.3336.25.camel@johannes.local>
	 <43e72e890909031100l5f28dd4cu30cf1e1c735e0e9d@mail.gmail.com>
	 <1252001060.9336.0.camel@johannes.local>
	 <43e72e890909031106q1dc3ebf0nb5281e2aeddd215e@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Vz7YKtWHtpaMscJTGW9i"
Date: Thu, 03 Sep 2009 20:12:31 +0200
Message-Id: <1252001551.9336.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Vz7YKtWHtpaMscJTGW9i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-03 at 11:06 -0700, Luis R. Rodriguez wrote:
> On Thu, Sep 3, 2009 at 11:04 AM, Johannes Berg<johannes@sipsolutions.net>=
 wrote:
> > On Thu, 2009-09-03 at 11:00 -0700, Luis R. Rodriguez wrote:
> >
> >> Anyway my point was that userspace does not need kmemleak.h and we are
> >> providing it to userspace.
> >
> > No, we're not providing it to userspace.
> >
> > If you actually build userspace headers it won't be included.
>=20
> Ah then I completely mispoke. Ignore this then.
>=20
> How *do* you export headers through kbuild then?

You mention them in include/linux/Kbuild, and then you run "make
headers_install" (I think)

johannes

--=-Vz7YKtWHtpaMscJTGW9i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKoAcLAAoJEODzc/N7+QmaqioP/1wyP3InSDswlUvBgiPFihD7
v66WHwaS87BFE1a5PQUpIH1o7XaY0QVo4nZh/LW1cx7Qlh7sKC9VYNaP62t2p/24
k+CZY65uCQgBPOvBN2Iu7uknL2MV24PaDhZlgP8YwWKXEIyo6rfAKN3qfiep3ANm
vzpLzrio258+lqzH8T6Fyrm9DVJ9SZTd/pcQfHxPP9gTOCP3RB+tdAA3DsqX/2xZ
l6AqPhDQhAcPk1AnlvzWLeUuO6WvLuchuEfm4CZlzOZy67ldbuNxFkvGCBzOBVoP
vfMAQHelEluo0oIVNDTBBakonjkSoBjK8cMC8eEdIVpMY3cnLoOEJZSZmvFNIQxW
Dxa9EPm/g4nnxFNHzIdaGIZlObjkN1gAOjJlaOvH4tvO7lkgm2EAttqLkeNomS8I
jpScpfYX6V9UCH74XGKFFlLMYQWID+MC4LFWBBZIuOcKLAvsAiXL5Ok/HesASBeG
ROAZ+6MewnV3MBiPO19Pp9KVTdIShMl1uAfL6hEiXp+BynzTD0gbxhMKHb7AGj8W
4AQ4YXY09JO8PASLsFLnwgtdT7cJRwdAHpvlVKzs3AZX3erY1+xqfnisq/ElAcue
HiVYL5E5vxj/Y37dxrWmdTHISYEvHBDOXrEhV/Cm5+jjVhPpIOq7MqliT8BFMl92
hTLMwoJbYFCP0yhIg11d
=awMg
-----END PGP SIGNATURE-----

--=-Vz7YKtWHtpaMscJTGW9i--

