Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbZB1AUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbZB1AUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 19:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbZB1AUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 19:20:34 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:57580 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZB1AUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 19:20:34 -0500
Subject: Re: i915 X lockup
From: Eric Anholt <eric@anholt.net>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, airlied@linux.ie,
       keithp@keithp.com, dri-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090227231207.GA4687@silver.sucs.org>
References: <49A7B253.906@gmail.com>
	 <20090227023231.76e7c65f.akpm@linux-foundation.org>
	 <20090227130440.GA24633@silver.sucs.org> <49A7EF52.8080105@gmail.com>
	 <20090227231207.GA4687@silver.sucs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fqHtbxjeOFGstfGFGiOA"
Date: Fri, 27 Feb 2009 16:20:31 -0800
Message-Id: <1235780431.6992.14.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fqHtbxjeOFGstfGFGiOA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-27 at 23:12 +0000, Sitsofe Wheeler wrote:
> On Fri, Feb 27, 2009 at 02:49:06PM +0100, Jiri Slaby wrote:
> > On 27.2.2009 14:04, Sitsofe Wheeler wrote:
> > >On Fri, Feb 27, 2009 at 02:32:31AM -0800, Andrew Morton wrote:
> > >>On Fri, 27 Feb 2009 10:28:51 +0100 Jiri Slaby<jirislaby@gmail.com>  w=
rote:
> > >>
> > >>>everytime I run X, it gets stuck. Currently running on mmotm
> > >>>2009-02-26-16-58, but I think this is wider problem. I had i915 disa=
bled
> > >>>for a long time (until I noticed today).
> > >
> > >Which version of X are you using? Does it support kernel modesetting? =
If
> > >not, did you disable kernel modesetting in the KConfig file for i915?
> >=20
> > xorg-x11-server-7.4-17.3
> > which is
> > X.Org X Server 1.5.2
> >=20
> > modesetting enabled:
> > CONFIG_DRM_I915_KMS=3Dy
> >=20
> > Which X version is needed for that?
>=20
> Good question. I can see that 7.4 supports GEM but I see nothing about
> kernel modesetting (
> http://www.phoronix.com/scan.php?page=3Darticle&item=3Dxorg_74_final&num=
=3D1).
> I know it's enabled in the Fedora (since Fedora 9) xorgs but I have no
> idea about openSUSE (which I believe is what you are using based on
> package numbers). Apparently kernel modesetting can be turned off on the
> kernel command line by using nomodesetting so that might be a quick
> thing to try...

KMS support is not a feature of the server but of your 2D driver.  You
want 2.6.2, or things will be bad.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-fqHtbxjeOFGstfGFGiOA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmog08ACgkQHUdvYGzw6vdL8QCfX9eenavLNpZVQECSJXMV+d+f
iiwAnRQNbmn+i6OdUoTS4hL0nGci3qpJ
=ML6T
-----END PGP SIGNATURE-----

--=-fqHtbxjeOFGstfGFGiOA--
