Return-Path: <linux-kernel-owner+w=401wt.eu-S934036AbXGRQPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbXGRQPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761033AbXGRQOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:14:54 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:43611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760958AbXGRQOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:14:53 -0400
Subject: Re: Occational lockups during boot with post 2.6.22 kernels
From: Johannes Berg <johannes@sipsolutions.net>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org,
       Bcm43xx-dev@lists.berlios.de,
       "John W. Linville" <linville@tuxdriver.com>,
       Netdev <netdev@vger.kernel.org>
In-Reply-To: <469E2AAB.2010408@redhat.com>
References: <m3sl7mk1f1.fsf@telia.com>  <469E2AAB.2010408@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cFIavx7nPsrz2d1k/Gh7"
Date: Wed, 18 Jul 2007 17:51:10 +0200
Message-Id: <1184773870.4002.8.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cFIavx7nPsrz2d1k/Gh7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-18 at 10:58 -0400, Chuck Ebbert wrote:
> On 07/17/2007 08:20 PM, Peter Osterlund wrote:
> > Current -git kernels sometimes lock up on my computer during boot. I
> > guess it happens about 10-20% of the time. I first saw this maybe a
> > week ago, but never with kernels <=3D 2.6.22.
> >=20
> > The last reported info on the console is that named is started.
> > SysRq-T still works and reports the non-sleeping tasks below.
> >=20
> > My guess is that wpa_supplicant and events/0 deadlock and later the
> > named thread also hangs when it needs a deadlocked resource.
> >=20
> > I'm using the bcm43xx driver.
> > =20
> > No lockdep errors are reported before the lockup. Earlier during boot
> > the kernel reports:
> >=20
> >   Good, all 218 testcases passed! |
>=20
> Try this, it should at least detect the problem:
>=20
> http://lkml.org/lkml/2007/7/17/202
> http://lkml.org/lkml/2007/7/17/204
> http://lkml.org/lkml/2007/7/17/203
>=20
> It's a known bug in wireless/80211, not sure when it will be fixed.

Heh, yes, that's the patchset that came from this bug :)
A patch for this is available but due to process issues hasn't
percolated up yet. See
http://thread.gmane.org/gmane.linux.kernel.wireless.general/3315/focus=3D33=
19

johannes

--=-cFIavx7nPsrz2d1k/Gh7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGnjbu/ETPhpq3jKURAkewAJ4upZrVdlFmk1Iu8lkl57u4JWVe9wCaA1Ja
LtdjTGABatX+Da4zjdqWh40=
=e7Hh
-----END PGP SIGNATURE-----

--=-cFIavx7nPsrz2d1k/Gh7--

