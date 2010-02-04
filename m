Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab0BDPxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:53:53 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:36060 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab0BDPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:53:51 -0500
X-Greylist: delayed 664 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2010 10:53:51 EST
From: Eric Anholt <eric@anholt.net>
To: Thomas Meyer <thomas@m3y3r.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] i915: slow acpi_lid_open() causes flickering
In-Reply-To: <1265048453.2619.8.camel@localhost.localdomain>
References: <1265048453.2619.8.camel@localhost.localdomain>
Date: Thu, 04 Feb 2010 07:43:12 -0800
Message-ID: <87vdedgg6n.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 01 Feb 2010 19:20:53 +0100, Thomas Meyer <thomas@m3y3r.de> wrote:
> acpi_lid_open() could take up to 10ms on my computer.
> Some component is calling the drm GETCONNECTOR ioctl many times in a row.
> This results in flickering (for example, when starting a video).
> Fix it by assuming an always connected lid status.
>=20
> This fixes bug http://bugzilla.kernel.org/show_bug.cgi?id=3D14670

If it's that unusable, this should just be put in bad_lid_status and
bad_lid_status checked before asking ACPI.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktq6xEACgkQHUdvYGzw6vfj4gCfZFRm2HgFb7D0sfKaNbU47Aye
9bgAnR5vlA5QpcXfm81f75m0P6HdKjAH
=jwbW
-----END PGP SIGNATURE-----
--=-=-=--
