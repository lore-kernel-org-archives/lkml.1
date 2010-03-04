Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab0CDXAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:00:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329Ab0CDXAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:00:24 -0500
Subject: Re: [git pull] drm request 3
From: Adam Jackson <ajax@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <4B903273.90305@garzik.org>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	 <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
	 <20100304185002.GA23532@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	 <20100304190450.GA23807@srcf.ucam.org>  <4B900AB2.1020603@garzik.org>
	 <1267741133.1316.9.camel@atropine.boston.devel.redhat.com>
	 <4B903273.90305@garzik.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AtN9CzPVB6xRUGkLaNqR"
Date: Thu, 04 Mar 2010 17:59:59 -0500
Message-Id: <1267743599.1316.47.camel@atropine.boston.devel.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AtN9CzPVB6xRUGkLaNqR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-03-04 at 17:21 -0500, Jeff Garzik wrote:

> > # sed -i 's/\<kernel\>.*/&  nouveau.modeset=3D0/g' /etc/grub.conf
>=20
> Never tried this part.

The bug I'm assuming you're referring to is

https://bugzilla.redhat.com/show_bug.cgi?id=3D519298

in which you merely remove the nouveau userspace component, and in which
I can't tell if you built nouveau into the kernel or not, but I assume
you didn't based on your previous post.  The X server does only try the
one driver before falling back to vesa, which is a bug in the fallback
logic I suppose.  I've (blindly) fixed that for F13 now.

However, the log in that bug only shows you using the built-in
autoconfig logic, and not an xorg.conf file.  So, given you were talking
about a kernel without nouveau, I am left to assume one of:

- you didn't try writing an xorg.conf fragment
- you did, and it didn't work anyway

The latter case is entirely plausible, as nv is not the sort of driver
that gets a lot of love, but I'm not aware of any open bugs about gf9800
in particular in nv.

- ajax

--=-AtN9CzPVB6xRUGkLaNqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkuQO24ACgkQW4otUKDs0NM5pwCcDz3//urOn94mPt5nFINAbZOA
rm0AoJ/hfBLnds6D367aHzH71x+rlr3S
=1l59
-----END PGP SIGNATURE-----

--=-AtN9CzPVB6xRUGkLaNqR--

