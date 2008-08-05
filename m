Return-Path: <linux-kernel-owner+w=401wt.eu-S1764798AbYHEVsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764798AbYHEVsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760378AbYHEVr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:47:56 -0400
Received: from molly.corsac.net ([81.57.48.219]:41860 "EHLO molly.corsac.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102AbYHEVry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:47:54 -0400
X-Greylist: delayed 7405 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Aug 2008 17:47:54 EDT
Subject: Re: [PATCH] Add Intel ACPI IGD OpRegion support
From: Yves-Alexis Perez <corsac@debian.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <1217965470.5449.4.camel@hidalgo>
References: <20080805183725.GA4468@srcf.ucam.org>
	 <1217965470.5449.4.camel@hidalgo>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6S+up+VBrlHFuEN81g2P"
Date: Tue, 05 Aug 2008 23:47:54 +0200
Message-Id: <1217972874.4540.3.camel@hidalgo>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6S+up+VBrlHFuEN81g2P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On mar, 2008-08-05 at 21:44 +0200, Yves-Alexis Perez wrote:
> On mar, 2008-08-05 at 19:37 +0100, Matthew Garrett wrote:
> > This adds the support necessary for allowing ACPI backlight control
> > to=20
> > work on some newer Intel-based graphics systems. Tested on Thinkpad
> > T61=20
> > and HP 2510p hardware.
>=20
> Ok, I managed to apply it against drm-2.6/drm-next but it won't apply
> against linux-acpi-2.6/test and I'm not sure how hard it is to cherry
> pick the needed stuff from drm to acpi.
>=20
> I'll try to build the drm-2.6/drm-next + patch but I guess it won't be
> enough to test brightness keys?

Ok, I checked out drm-2.6/drm-next, created a local branch drm-next and
applied OpRegion.
Then I checked out linux-acpi-2.6/test, created a local branched, and
merged then my local drm-next into it.

Built fine, rebooted into single user (without using acpi_backlight=3D).
In single user, brightness keys still don't work.

In booted into X (with hal, powersaved, dbus etc. running), and then,
tada, brightness keys work. There is a 750ms (I guess) delay, and I
don't know who is really responsible, I guess X is. (and thus I guess
the opregion is the one needed, and X manages the brightness. If the
kernel was, it would be working even in single user)

Hope that can help understand the issues. Feel free to ask more info.

Cheers,
--=20
Yves-Alexis

--=-6S+up+VBrlHFuEN81g2P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiYyoUACgkQTUTAIMXAW64tPgCfdhbDmrvKm+nDe9qOaVOA2W/E
7TEAoIE4+UwOkwC/Ko/+l1CIr5l65lEQ
=bE5N
-----END PGP SIGNATURE-----

--=-6S+up+VBrlHFuEN81g2P--
