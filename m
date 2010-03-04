Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab0CDWTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:19:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0CDWTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:19:21 -0500
Subject: Re: [git pull] drm request 3
From: Adam Jackson <ajax@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <4B900AB2.1020603@garzik.org>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	 <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
	 <20100304185002.GA23532@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	 <20100304190450.GA23807@srcf.ucam.org>  <4B900AB2.1020603@garzik.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-exbPksEjjYGiddrKEvA0"
Date: Thu, 04 Mar 2010 17:18:53 -0500
Message-Id: <1267741133.1316.9.camel@atropine.boston.devel.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-exbPksEjjYGiddrKEvA0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-03-04 at 14:32 -0500, Jeff Garzik wrote:=20
> On 03/04/2010 02:04 PM, Matthew Garrett wrote:
> > F-12 continues to ship the -nv driver, which will work fine with any
> > kernel version as long as nouveau is disabled.
>=20
> FAIL.  I actually tried that.  Have you?  Do you think it is remotely=20
> easy for a technically component, non-Xorg-hacker type to accomplish?

# cat << EOF > /etc/X11/xorg.conf
Section "Device"
    Identifier "Card0"
    Driver "nv"
EndSection
EOF
# sed -i 's/\<kernel\>.*/& nouveau.modeset=3D0/g' /etc/grub.conf
# telinit 6

HTH.

- ajax

--=-exbPksEjjYGiddrKEvA0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkuQMckACgkQW4otUKDs0NO9QgCeKFT6SxS17VfbF5/GQAtJWxjQ
XeYAoN7OZhA15YmL2LyD1kmqGMc/fjDG
=4iqp
-----END PGP SIGNATURE-----

--=-exbPksEjjYGiddrKEvA0--

