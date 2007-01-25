Return-Path: <linux-kernel-owner+w=401wt.eu-S1750853AbXAYL1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853AbXAYL1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 06:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXAYL1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 06:27:46 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41071 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbXAYL1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 06:27:46 -0500
Message-ID: <45B8942F.7050006@drzeus.cx>
Date: Thu, 25 Jan 2007 12:27:43 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-11376-1169724464-0001-2"
To: "Christopher \"Monty\" Montgomery" <xiphmont@gmail.com>
CC: perex@suse.cz, greg@kroah.com, mclasen@redhat.com, jrb@redhat.com,
       Lennart Poettering <lennart@poettering.net>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       fedora-desktop-list@redhat.com
Subject: Re: [PATCH] alsa: correct nonsensical sysfs device symlinks
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
In-Reply-To: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-11376-1169724464-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Christopher "Monty" Montgomery wrote:
> This patch was generated against 2.6.20-rc5; it fixes a bug that
> cropped up in a late 2.6.19-mm kernel.
>=20
> When ALSA's sysfs device creation was converted from using
> class_device_create() to device_create(), the fourth param from
> class_device_create() [dev] was simply plugged into arg 2 of
> device_create().  This causes the device symlinks under all the
> class/sound/[node] to point to nonsensical places.  Among other
> problems, this breaks HAL and all audio software that depends on HAL.
>=20

There are no device symlinks anymore, so the current behaviour seems
correct. HAL should follow the symlink, then move up in the device tree
to find a suitable parent.

Rgds
Pierre



--=_hera.drzeus.cx-11376-1169724464-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFuJQy7b8eESbyJLgRAsEuAJ9Qlmg66NBRO59pfo95lTTSTrnbqgCfRwbC
pqiWo5eXUTOVQLcNqOKiYKk=
=buKe
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-11376-1169724464-0001-2--
