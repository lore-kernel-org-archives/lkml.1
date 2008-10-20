Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbYJTCTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbYJTCTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 22:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYJTCTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 22:19:22 -0400
Received: from home.keithp.com ([63.227.221.253]:37553 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbYJTCTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 22:19:22 -0400
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
From: Keith Packard <keithp@keithp.com>
To: Andres Freund <andres@anarazel.de>
Cc: keithp@keithp.com, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200810200358.52147.andres@anarazel.de>
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie>
	 <200810200300.01411.andres@anarazel.de>
	 <1224466521.5303.41.camel@koto.keithp.com>
	 <200810200358.52147.andres@anarazel.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RKXGb9XUL7e6gZ1feOrf"
Date: Sun, 19 Oct 2008 19:19:07 -0700
Message-Id: <1224469147.5303.47.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RKXGb9XUL7e6gZ1feOrf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 03:58 +0200, Andres Freund wrote:

> Its basically only this, right?

Yup.

> Barring that I have absolutely idea about the code and all related stuff,=
 do I=20
> see it correct, that this also will result in problems if the kernel does=
n't=20
> have the related fix?

Yes, on this hardware, the kernel is smashing the last few stolen
entries with a bad value, so running a new driver against an old kernel
will fail as well. There's not a lot we can do about this direction
though; until we have all of this hardware management in one place,
we're stuck trying to synchronize fixes across two code bases.

> If its really only a that small portion of hardware... At least the T500/=
T400=20
> series, containing the same hw as mine, from Lenovo propably is not yet r=
eally=20
> wide spread (Laptop is 4weeks old or so and wasn't available before).

I haven't even received my x200s yet as they've just entered production.
The problem here was that the prototype hardware had a different
behavior than what is now shipping, so we didn't catch this mistake
until the first production machines were tested.

If you care to try the above fix against your current driver sources,
that would be helpful for us.

--=20
keith.packard@intel.com

--=-RKXGb9XUL7e6gZ1feOrf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI++qbQp8BWwlsTdMRAnoZAJ9zUicS38UKSWW0bGfATvhjQxk84QCfTXKy
K6tuuWUjVCuH08NcU+HyYP4=
=vdPR
-----END PGP SIGNATURE-----

--=-RKXGb9XUL7e6gZ1feOrf--

