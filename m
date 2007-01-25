Return-Path: <linux-kernel-owner+w=401wt.eu-S1030209AbXAYPks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030209AbXAYPks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030215AbXAYPks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:40:48 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41097 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030209AbXAYPkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:40:47 -0500
Message-ID: <45B8CF7E.2040908@drzeus.cx>
Date: Thu, 25 Jan 2007 16:40:46 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-15853-1169739646-0001-2"
To: "Christopher \"Monty\" Montgomery" <xiphmont@gmail.com>
CC: Greg KH <greg@kroah.com>, perex@suse.cz, mclasen@redhat.com,
       jrb@redhat.com, Lennart Poettering <lennart@poettering.net>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       fedora-desktop-list@redhat.com
Subject: Re: [PATCH] alsa: correct nonsensical sysfs device symlinks
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>	 <20070125042616.GA21813@kroah.com>	 <806dafc20701250611u9935049ja8f88deb2aac4d40@mail.gmail.com>	 <45B8C9A3.6060107@drzeus.cx> <806dafc20701250736yc5c3048u14ec98e9b6b92574@mail.gmail.com>
In-Reply-To: <806dafc20701250736yc5c3048u14ec98e9b6b92574@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-15853-1169739646-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Christopher "Monty" Montgomery wrote:
>=20
> Interesting to know.  Looking more closely, it looks like machines
> here are split between the messed up output I forwarded previously and
> the output that is expected.  All of my personal boxes are messed up.
>=20

There is some option about deprecated sysfs stuff. Perhaps this is the
cause of your twisted tree. It's off here:

# CONFIG_SYSFS_DEPRECATED is not set

Rgds
Pierre



--=_hera.drzeus.cx-15853-1169739646-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFuM9+7b8eESbyJLgRAggKAJ0X1bf23DqlfgKGpRK84BxyRMiaygCgiolP
jf/KM4MgkJg3UsS3/adrhfI=
=cMWM
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-15853-1169739646-0001-2--
