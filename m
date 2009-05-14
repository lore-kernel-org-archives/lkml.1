Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZENVQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZENVQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 17:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbZENVQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 17:16:50 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:34650 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZENVQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 17:16:50 -0400
Subject: Re: [PATCH resend] drm: ignore LVDS on intel graphics systems that
 lie about having it
From: Eric Anholt <eric@anholt.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xorg-devel@lists.x.org, notting@redhat.com
In-Reply-To: <200905051000.26701.jarod@redhat.com>
References: <200905051000.26701.jarod@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OqDlXE/3U/2xsysIbo4t"
Date: Thu, 14 May 2009 14:16:48 -0700
Message-Id: <1242335808.9887.61.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OqDlXE/3U/2xsysIbo4t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-05 at 10:00 -0400, Jarod Wilson wrote:
> There are a number of small form factor desktop systems with Intel mobile
> graphics chips that lie and say they have an LVDS. With kernel mode-setti=
ng,
> this becomes a problem, and makes native resolution boot go haywire -- fo=
r
> example, my Dell Studio Hybrid, hooked to a 1920x1080 display claims to
> have a 1024x768 LVDS, and the resulting graphical boot on the 1920x1080
> display uses only the top left 1024x768, and auto-configured X will end
> up only 1024x768 as well. With this change, graphical boot and X
> both do 1920x1080 as expected.
>=20
> Note that we're simply embracing and extending the early bail-out code
> in place for the Mac Mini here. The xorg intel driver uses pci subsystem
> device and vendor id for matching, while we're using dmi lookups here.
> The MSI addition is courtesy of and tested by Bill Nottingham.
>=20
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> Tested-by: Bill Nottingham <notting@redhat.com>

Looks good, I'm pulling it for 2.6.30.  Thanks!

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-OqDlXE/3U/2xsysIbo4t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoMikAACgkQHUdvYGzw6vfpgACfX5xlCDQICQWj3O7B7mUxHUBD
vxMAn2I07r21u/kpXyWVEY6w6ANIuKZT
=PWeC
-----END PGP SIGNATURE-----

--=-OqDlXE/3U/2xsysIbo4t--
