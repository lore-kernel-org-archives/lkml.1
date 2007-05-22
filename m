Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbXEVAvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbXEVAvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbXEVAvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:51:40 -0400
Received: from home.keithp.com ([63.227.221.253]:1074 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918AbXEVAvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:51:39 -0400
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
From: Keith Packard <keithp@keithp.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: keithp@keithp.com, Jesse Barnes <jesse.barnes@intel.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@gmail.com>,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <1179792587.32247.769.camel@localhost.localdomain>
References: <200705171423.46748.jesse.barnes@intel.com>
	 <1179792587.32247.769.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lyl7qq3a5uuAVnHkYeDI"
Date: Mon, 21 May 2007 17:51:32 -0700
Message-Id: <1179795093.5826.391.camel@neko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lyl7qq3a5uuAVnHkYeDI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-05-22 at 10:09 +1000, Benjamin Herrenschmidt wrote:

> I do stongly beleive that the decision of what mode to choose should not
> be made in the kernel.

That's the plan; the kernel just provides mechanism. The architecture
used in the X server splits precisely at this point with the mechanism
in the driver and the configuration and policy up in the X server
proper. Quite a bit of that code could be broken out into a shared
library for fbdev-based apps and the X server to share, but that's down
the road a bit after the kernel APIs look a lot more solid.

With the goal of getting to a single-mode-set boot to avoid screen
flashing before login, the key here is to make any early user-mode
graphics apps share the same kernel graphics infrastructure as the X
server to identify the common cases where the startup and X modes are
the same and avoid resetting the configuration.

--=20
keith.packard@intel.com

--=-lyl7qq3a5uuAVnHkYeDI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGUj6UQp8BWwlsTdMRAlWpAKCuBZxQhJa2HycNYGhFHYp1oZoWKACffdxN
NiAHBS3wI5+nbrv+vAKmgAU=
=PCw9
-----END PGP SIGNATURE-----

--=-lyl7qq3a5uuAVnHkYeDI--
