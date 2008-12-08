Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbYLHGcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbYLHGcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 01:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYLHGci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 01:32:38 -0500
Received: from molly.corsac.net ([81.57.48.219]:52338 "EHLO molly.corsac.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbYLHGch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 01:32:37 -0500
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2008 01:32:37 EST
Subject: Re: [Bug #12152] Huge wakeups number from i1915
From: Yves-Alexis Perez <corsac@debian.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <1228717448.9677.3.camel@hidalgo>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera>
	 <07Xes05z25M.A.VtF.ksEPJB@chimera> <20081207145203.0f998d5b@infradead.org>
	 <200812072352.07151.rjw@sisk.pl>  <20081207151203.46c01a0d@infradead.org>
	 <1228717448.9677.3.camel@hidalgo>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N7OvyR/HkP2IoUFv5dAc"
Date: Mon, 08 Dec 2008 07:32:49 +0100
Message-Id: <1228717969.9677.9.camel@hidalgo>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-N7OvyR/HkP2IoUFv5dAc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On lun, 2008-12-08 at 07:24 +0100, Yves-Alexis Perez wrote:
> On dim, 2008-12-07 at 15:12 -0800, Arjan van de Ven wrote:
> >=20
> > > > at least in some of the cases where this has been seen the cause
> > is
> > > > the following:
> > > > The i915 DRM driver used to do polling for completion, busy
> > > > waiting. It moved to be interrupt driven, which is usually better
> > > > for power, but it will show up as more wakeups in powertop....
> > >=20
> > > IOW, this is not a regression?
> >=20
> > I don't know about this specifc case (not enough information) but for
> > the case I described it's not a regression. Going to interrupt driven
> > from busy waiting is an improvement not a regression :)
>=20
> Well, several thousand or more interrupts really seems like a
> regression :). But it seems that's the same thing as the =E2=80=9CIRQ
> spinning=E2=80=9D (there was a thread on dri-devel about that).
>=20
> It seems fixed with a patch from Matthew Garrett applied to
> drm-intel/for-airlied but I don't think this has been applied to Linus
> master.

And it seems the same thing as
https://bugs.freedesktop.org/show_bug.cgi?id=3D18609

Cheers,
--=20
Yves-Alexis

--=-N7OvyR/HkP2IoUFv5dAc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk8v5EACgkQTUTAIMXAW65VPACgjy4sTQKfUdrovAB0Gl85du7e
upwAoLDQfHNRZBvuIgE7W5ZHmvxPS2Uj
=UzHe
-----END PGP SIGNATURE-----

--=-N7OvyR/HkP2IoUFv5dAc--
