Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0CEPrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:47:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab0CEPq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:46:59 -0500
Subject: Re: [git pull] drm request 3
From: Adam Jackson <ajax@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <4B90E9EA.9030708@garzik.org>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	 <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
	 <20100304185002.GA23532@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	 <20100304190450.GA23807@srcf.ucam.org>  <4B900AB2.1020603@garzik.org>
	 <1267741133.1316.9.camel@atropine.boston.devel.redhat.com>
	 <4B903273.90305@garzik.org>
	 <1267743599.1316.47.camel@atropine.boston.devel.redhat.com>
	 <4B90E9EA.9030708@garzik.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-x1w80BvCqQ8gde5JS0QA"
Date: Fri, 05 Mar 2010 10:46:21 -0500
Message-Id: <1267803981.1316.79.camel@atropine.boston.devel.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-x1w80BvCqQ8gde5JS0QA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-03-05 at 06:24 -0500, Jeff Garzik wrote:
> On 03/04/2010 05:59 PM, Adam Jackson wrote:
> > in which you merely remove the nouveau userspace component, and in whic=
h
> > I can't tell if you built nouveau into the kernel or not, but I assume
> > you didn't based on your previous post.  The X server does only try the
> > one driver before falling back to vesa, which is a bug in the fallback
> > logic I suppose.  I've (blindly) fixed that for F13 now.
>=20
> Thanks.  Can this be put into F12 too?

Sure, why not.

> > - you didn't try writing an xorg.conf fragment
> > - you did, and it didn't work anyway
> >
> > The latter case is entirely plausible, as nv is not the sort of driver
> > that gets a lot of love, but I'm not aware of any open bugs about gf980=
0
> > in particular in nv.
>=20
> The latter...  would modeset in grub interfere, perhaps?

It's not going to do anything if you didn't build a KMS driver.  It's
just a kcmdline option like any other; if there's no module to honor it,
then it doesn't do anything.  grub doesn't have any particular KMS
awareness.

I'm really going to have to see an X log and dmesg from the failure mode
when actually using nv to diagnose this any further.

- ajax

--=-x1w80BvCqQ8gde5JS0QA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkuRJ0wACgkQW4otUKDs0NPHFgCeL2rByqTvPXu+N4eCdlAsFFfk
4+sAoOJseyYgWbnKqOKoQK737hAc/5DF
=nMz9
-----END PGP SIGNATURE-----

--=-x1w80BvCqQ8gde5JS0QA--

