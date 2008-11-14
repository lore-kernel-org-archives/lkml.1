Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYKNSHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYKNSHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYKNSHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:07:43 -0500
Received: from systemlinux.org ([83.151.29.59]:42669 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYKNSHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:07:43 -0500
Date: Fri, 14 Nov 2008 18:53:42 +0100
From: Andre Noll <maan@systemlinux.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: typo in raid[456] kernel code/no change based on type?
Message-ID: <20081114175342.GK17300@skl-net.de>
References: <alpine.DEB.1.10.0811121855470.10512@p34.internal.lan> <alpine.DEB.1.10.0811121858300.10512@p34.internal.lan> <20081114121942.GN17966@skl-net.de> <alpine.DEB.1.10.0811140743050.20662@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cy+5HEalSgyXkpVS"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811140743050.20662@p34.internal.lan>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Cy+5HEalSgyXkpVS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08:05, Justin Piszcz wrote:
> [ patch ]
>=20
> # patch -p1 < /home/jpiszcz/patch=20
> patching file drivers/md/raid5.c
> Hunk #1 succeeded at 4302 (offset -41 lines).
>=20
> Ok, fixed some of them but not all:

Sure. The main part of the raid 4/5/6 code is in the single file raid5.c
which frequently calls all its supported raid levels "raid5". The patch
I've posted only cleans up one function in that file.

> Here is the current output that still contains 'raid5':
>=20
> $ dmesg | grep -i raid5
> [   19.881548] md: raid5 personality registered for level 5
> [   21.408354] raid5: device sdl1 operational as raid disk 8
> [   21.410583] raid5: device sdk1 operational as raid disk 1
> [   21.412789] raid5: device sdj1 operational as raid disk 5
> [   21.414994] raid5: device sdi1 operational as raid disk 9
> [   21.417217] raid5: device sdh1 operational as raid disk 7
> [   21.419420] raid5: device sdg1 operational as raid disk 6
> [   21.421622] raid5: device sdf1 operational as raid disk 3
> [   21.423810] raid5: device sde1 operational as raid disk 2
> [   21.425970] raid5: device sdd1 operational as raid disk 0
> [   21.428090] raid5: device sdc1 operational as raid disk 4
> [   21.430884] raid5: allocated 10568kB for md3
> [   21.433023] raid5: raid level 6 set md3 active with 10 out of 10=20
> devices, algorithm 2

Of course these can also be fixed easily. But let's first see whether
Neil wants to take such trivial stuff ATM.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Cy+5HEalSgyXkpVS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJHbsmWto1QDEAkw8RAiuuAJ0YCThKJcBibv+C3H0e51elcgkcawCcDFGQ
pnDsCI+yxn+3GxrtK28AIgQ=
=Y+Lb
-----END PGP SIGNATURE-----

--Cy+5HEalSgyXkpVS--
