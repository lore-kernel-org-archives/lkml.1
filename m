Return-Path: <linux-kernel-owner+w=401wt.eu-S1762808AbYHFBNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762808AbYHFBNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762703AbYHFBM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:12:26 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:58374 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762305AbYHFBMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:12:24 -0400
Subject: Re: [PATCH] drm: Add GEM ("graphics execution manager") to i915
	driver.
From: Eric Anholt <eric@anholt.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, keithp@keithp.com
In-Reply-To: <20080801084405.62d3c823.randy.dunlap@oracle.com>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <1217573919-7496-2-git-send-email-eric@anholt.net>
	 <1217573919-7496-3-git-send-email-eric@anholt.net>
	 <20080801084405.62d3c823.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AUbXbItARCj4ClNC9AvR"
Date: Tue, 05 Aug 2008 18:11:56 -0700
Message-Id: <1217985116.7524.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AUbXbItARCj4ClNC9AvR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-01 at 08:44 -0700, Randy Dunlap wrote:
> On Thu, 31 Jul 2008 23:58:39 -0700 Eric Anholt wrote:
>=20
> > GEM allows the creation of persistent buffer objects accessible by the
> > graphics device through new ioctls for managing execution of commands o=
n the
> > device.  The userland API is almost entirely driver-specific to ensure =
that
> > any driver building on this model can easily map the interface to indiv=
idual
> > driver requirements.
> >=20
> > GEM is used by the 2d driver for managing its internal state allocation=
s and
> > will be used for pixmap storage to reduce memory consumption and enable
> > zero-copy GLX_EXT_texture_from_pixmap, and in the 3d driver is used to =
enable
> > GL_EXT_framebuffer_object and GL_ARB_pixel_buffer_object.
>=20
> "the 2d driver" ... "the 3d driver".
> Just curious:  Is there only one of each of these?

"The 2D driver" means xf86-video-intel xorg driver in userland.
"The 3D driver" means i9[16]5_dri.so mesa driver in userland.

> > diff --git a/drivers/gpu/drm/drm_agpsupport.c b/drivers/gpu/drm/drm_agp=
support.c
> > index aefa5ac..2639be2 100644
> > --- a/drivers/gpu/drm/drm_agpsupport.c
> > +++ b/drivers/gpu/drm/drm_agpsupport.c
> > @@ -33,6 +33,7 @@
> > =20
> >  #include "drmP.h"
> >  #include <linux/module.h>
> > +#include <asm/agp.h>
> > =20
> >  #if __OS_HAS_AGP
> > =20
> > @@ -452,4 +453,52 @@ int drm_agp_unbind_memory(DRM_AGP_MEM * handle)
> >  	return agp_unbind_memory(handle);
> >  }
> > =20
> > -#endif				/* __OS_HAS_AGP */
> > +/**
>=20
> In the kernel source tree, "/**" means "beginning of kernel-doc notation"=
,
> so please don't use it when kernel-doc isn't being used.
> (in multiple places/files)

The codebase this is coming from uses doxygen.  I hadn't checked to see
if all the doxygen was converted to kernel-doc.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-AUbXbItARCj4ClNC9AvR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiY+lwACgkQHUdvYGzw6vc1yACcDvvbic4exOyJj5YRF638eqwH
RfoAn0qnivlJZRKFdA48d9tfLjDD7grL
=/oJY
-----END PGP SIGNATURE-----

--=-AUbXbItARCj4ClNC9AvR--
