Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZAGEBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZAGEBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 23:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZAGEBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 23:01:21 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:56392 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbZAGEBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 23:01:20 -0500
Subject: Re: [Regression] X server doesn't start on MSI Wind w/ current
	mainline
From: Eric Anholt <eric@anholt.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>
In-Reply-To: <200901050948.14352.jbarnes@virtuousgeek.org>
References: <200901031328.40574.rjw@sisk.pl>
	 <200901050011.32974.rjw@sisk.pl>
	 <200901050948.14352.jbarnes@virtuousgeek.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U5b/ldxRgTx/fopiPgiC"
Date: Tue, 06 Jan 2009 20:01:17 -0800
Message-Id: <1231300877.4690.46.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U5b/ldxRgTx/fopiPgiC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-05 at 09:48 -0800, Jesse Barnes wrote:
> On Sunday, January 4, 2009 3:11 pm Rafael J. Wysocki wrote:
> > On Saturday 03 January 2009, Rafael J. Wysocki wrote:
> > > Hi,
> > >
> > > With the current mainline and the linux-next branch of your pci-2.6 t=
ree
> > > on top, the X server doesn't start any more on MSI Wind (Intel hardwa=
re)
> > > w/ openSUSE 11.1 .
> > >
> > > I also tested the linux-next branch of the pci-2.6 tree on top of 2.6=
.28
> > > and it doesn't cause any problem with the X server to happen.
> >
> > Well, I pulled the mainline from today, unsetted DRM_I915_KMS and it wo=
rks
> > again.
> >
> > BTW, what user land is necessary for the KMS to work?
>=20
> Ah yeah defaulting to KMS enabled will probably get you undesirable resul=
ts at=20
> this point.  You'll need a bleeding edge 2D driver (from xf86-video-intel=
 git)=20
> and libdrm 2.4.3 to make this all work.  Be sure to pass "--enable-kms" w=
hen=20
> you configure your 2D driver.

The --enable-kms requirement is gone now.  Hopefully soon we'll have a
release out and can mention a version number in the Kconfig.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-U5b/ldxRgTx/fopiPgiC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklkKQ0ACgkQHUdvYGzw6vewMQCfZ4ARvDSn47PHIh20y5yU+Uzn
68MAn3ozI/Yvhhnh0bKbRawFm2daA2xW
=QBgP
-----END PGP SIGNATURE-----

--=-U5b/ldxRgTx/fopiPgiC--

