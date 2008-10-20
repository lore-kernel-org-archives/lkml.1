Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364AbYJTBgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbYJTBgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 21:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYJTBfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 21:35:55 -0400
Received: from home.keithp.com ([63.227.221.253]:39959 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbYJTBfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 21:35:54 -0400
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
From: Keith Packard <keithp@keithp.com>
To: Andres Freund <andres@anarazel.de>
Cc: keithp@keithp.com, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200810200300.01411.andres@anarazel.de>
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie>
	 <200810200144.44383.andres@anarazel.de>
	 <1224461977.5303.34.camel@koto.keithp.com>
	 <200810200300.01411.andres@anarazel.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8oJ0Kojpfl6BLjhbd7WI"
Date: Sun, 19 Oct 2008 18:35:21 -0700
Message-Id: <1224466521.5303.41.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8oJ0Kojpfl6BLjhbd7WI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 03:00 +0200, Andres Freund wrote:

> Hm. But still, there is at least one distribution (ubuntu intrepid) which=
 will=20
> propably will ship 2.4.1 in its stable version soon (it seems unlikely th=
at=20
> they will update to an unstable version just before an release).

We can backport the fix (it's tiny) to the 2.4 2D driver.

> Which means, that this driver will get quite some spread...
> Is it accepted that the kernel abi breaks that radically/fast?

We tested a pile of hardware and didn't find any GM45s that worked, so
we assumed they were all broken and that fixing the bug wouldn't cause
any working configurations to stop working.

We can hack up the kernel so the old X server just gets a WARN_ON
instead of breaking. This is a bit worrying though; the "fix" would let
user space continue to mis-program the hardware.

My concern here is that a common failure mode with this bug was to lock
up the graphics hardware and require a reboot. Having the X server fail
to start and leave the system in text mode where new packages can be
installed seems like a better mode than making the system hang during
boot.

--=20
keith.packard@intel.com

--=-8oJ0Kojpfl6BLjhbd7WI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI++BZQp8BWwlsTdMRApUQAJwJo+Q4ztt1M2BnYp0TJ81XbPVDJgCgnl5l
qQVjtcI1UxlHKM3cbomFSZU=
=jc7P
-----END PGP SIGNATURE-----

--=-8oJ0Kojpfl6BLjhbd7WI--

