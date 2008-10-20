Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbYJTAUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbYJTAUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 20:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYJTATz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 20:19:55 -0400
Received: from home.keithp.com ([63.227.221.253]:51288 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbYJTATy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 20:19:54 -0400
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
From: Keith Packard <keithp@keithp.com>
To: Andres Freund <andres@anarazel.de>
Cc: keithp@keithp.com, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200810200144.44383.andres@anarazel.de>
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie>
	 <200810200111.06461.andres@anarazel.de>
	 <alpine.DEB.0.82.0810200022500.27788@skynet.skynet.ie>
	 <200810200144.44383.andres@anarazel.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ariQnRrjnYfXA2dxD4P6"
Date: Sun, 19 Oct 2008 17:19:37 -0700
Message-Id: <1224461977.5303.34.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ariQnRrjnYfXA2dxD4P6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 01:44 +0200, Andres Freund wrote:
> Hi Dave,
>=20
> On Monday 20 October 2008 01:25:22 Dave Airlie wrote:
> > What type of laptop is it and what GPU has it.
> > if distros are carrying GM45 supporting stuff we might be in trouble..

The GM45/G45 support in both kernel and user space was horribly broken,
causing the kernel to either overwrite stolen entries with freshly
allocated pages, and potentially corrupt the system, or leave some GTT
entries uninitialized and cause the hardware to lock up.

You appear to have a happy situation where this bug isn't obviously
breaking things. We couldn't find any machines where even simple 2D
graphics was stable for very long.

We applied a patch to both kernel and 2D driver (as both end up
computing the size of the GTT stolen area for historical reasons) to fix
this mistake. Updating your 2D driver to 2.4.98 should get you the other
half of the fix.

> Its a Thinkpad T500 with a hybrid ATI/intel card, but the ATI card is dis=
abled=20
> in bios (Intel card is not recognized properly if its enabled, havent sta=
rted=20
> trying to track this down).

Yeah, I'm getting information about how 'hybrid' graphics hardware
works.

--=20
keith.packard@intel.com

--=-ariQnRrjnYfXA2dxD4P6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI+86ZQp8BWwlsTdMRApGTAJ94he7uDixwHdUn/oll5XvwWdBnBwCfddFO
ZwhXHebv8rqn19oUk3FNgQc=
=znIM
-----END PGP SIGNATURE-----

--=-ariQnRrjnYfXA2dxD4P6--

