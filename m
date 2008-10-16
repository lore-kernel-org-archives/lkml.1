Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYJPO7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYJPO7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYJPO6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:58:47 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58482 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbYJPO6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:58:45 -0400
Subject: Re: powerpc allmodconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, tiwai@suse.de,
       linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
       linux-ide@vger.kernel.org, bzolnier@gmail.com, marek.vasut@gmail.com,
       dwmw2@infradead.org, mark.fasheh@oracle.com, ralf@linux-mips.org,
       mchehab@infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20081015.220247.262683261.davem@davemloft.net> (sfid-20081016_070321_484206_CF986FB8)
References: <20081015213337.a99a9595.akpm@linux-foundation.org>
	 <20081015.220247.262683261.davem@davemloft.net>
	 (sfid-20081016_070321_484206_CF986FB8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RwDHazsTlsfHEjp3GDNS"
Date: Thu, 16 Oct 2008 16:57:19 +0200
Message-Id: <1224169039.735.57.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RwDHazsTlsfHEjp3GDNS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-15 at 22:02 -0700, David Miller wrote:
>=20
>=20
> > net/sched/sch_generic.c: In function 'dev_watchdog':
> > net/sched/sch_generic.c:224: warning: unused variable 'drivername'
>=20
> Sucky, if WARN_ONCE() evaluates to nothing the sprintf() string buffer
> on the stack looks unused.

I've complained about this to Arjan before, we actually lose all
messages passed to WARN() or WARN_ONCE() on platforms that use bug traps
for warnings too.

johannes

--=-RwDHazsTlsfHEjp3GDNS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI91ZLAAoJEKVg1VMiehFYYlcQAIVtjS9xcVR3ZmM6893/7UIV
2XEXfwlKMLunk5fBVAPz2DF2x83tlyNHrALOW1zTWjM2teLzKCq0XtFsXIoMrUX5
0AuQBKmN/nf2+93YbfBH73zWmeegBz0yO1IaCdnjDT5P0Orn6mj4h7OBnb1u2Dxo
pNK/wOiX/v/2MKrfQnEBo9LHqMmlGonbvFPxBIVOeONzsjlv5BVMWqPhfxf9D7wI
m1GIDO13dYZ/ZkKuC5SchD+UJhFhPZd2pG1rxK8eRctDJXHa1dFEcVLrQq9zshBL
7xJ5n4jdw1M5PVKNB4Frd3H1nv8PGNKoNliodaNwj/ZC5ULxZXnFxECkPl3VGU63
5cUVGYTsqHUewPT7TigoYTD45AU85LWyhYHtN63hqbkeNH5Sf2QgN5XwQ7Wb3Urm
gk3MMi01RcUvuV0MtiWsqZ/Cu1HM6S4QsgxypZ7gtv867LiB17c3ucVbswPVRGgZ
A036WQSNA+gAQU3tV5J5D9eq8lphlmioLfUq4/mPKSn+UgI22iYMTPk9hMY/3dkZ
Iox3vd7GfiDiPmNoHaF27w9dlQURjU3ue0eC5G5gUvImzawU3l6bmVEHoNhT/DUJ
Q+2NSFvtZhYzFm1TUnHpyF0KYnAz6pogNY8155qCZ5dX7Wlc2wgpUkZJpdhc8iv9
nb5xAVWpNharfmm23n+R
=pg7B
-----END PGP SIGNATURE-----

--=-RwDHazsTlsfHEjp3GDNS--

