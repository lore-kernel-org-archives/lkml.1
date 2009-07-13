Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZGMHvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZGMHvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 03:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZGMHvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 03:51:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42662 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbZGMHvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 03:51:14 -0400
Date: Mon, 13 Jul 2009 17:51:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: linux-next: driver-core tree build warning
Message-Id: <20090713175106.d2efbd60.sfr@canb.auug.org.au>
In-Reply-To: <20090713172831.8875ac2c.sfr@canb.auug.org.au>
References: <20090713172646.55b9acee.sfr@canb.auug.org.au>
	<20090713172831.8875ac2c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__13_Jul_2009_17_51_06_+1000_.UbTw__YgtM6xFDP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jul_2009_17_51_06_+1000_.UbTw__YgtM6xFDP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 13 Jul 2009 17:28:31 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 13 Jul 2009 17:26:46 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > Today's linux-next build (x86_64 allmodconfig) produced this warning:
> >=20
> > drivers/firewire/core-device.c: In function 'init_fw_attribute_group':
> > drivers/firewire/core-device.c:315: warning: assignment from incompatib=
le pointer type
> >=20
> > Introduced by commit 025a6a26b70e5dc12ab9333ea43d70c735f459ac ("driver
> > model: constify attribute groups").
>=20
> Also:
>=20
> drivers/mtd/mtdcore.c:227: warning: initialization from incompatible poin=
ter type

And from a PowerPC allyesconfig build:

drivers/block/cciss.c:582: warning: initialization from incompatible pointe=
r type

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__13_Jul_2009_17_51_06_+1000_.UbTw__YgtM6xFDP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpa52sACgkQjjKRsyhoI8xM9ACgre1lzsLZmowX9dLDejNcOHNb
XaMAn0W8HjVzkeOBmRXWGmA2WJQU975v
=Wtov
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jul_2009_17_51_06_+1000_.UbTw__YgtM6xFDP--
