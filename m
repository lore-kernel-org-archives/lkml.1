Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYLNOIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYLNOIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 09:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYLNOIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 09:08:41 -0500
Received: from server.klug.on.ca ([205.189.48.131]:1138 "EHLO
	server.klug.on.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYLNOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 09:08:40 -0500
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
To: linux-kernel@vger.kernel.org
In-Reply-To: <20081214031659.4b700a2d@liberty.rlwhome.lan>
References: <20081214031659.4b700a2d@liberty.rlwhome.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oZvWWwqU1q+UMm6EyXBq"
Date: Sun, 14 Dec 2008 09:08:34 -0500
Message-Id: <1229263715.330.29.camel@pc.interlinx.bc.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oZvWWwqU1q+UMm6EyXBq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-14 at 03:16 -0600, Robby Workman wrote:
> In linux.kernel, Brian J. Murrell wrote:
> > I'm trying to debug a resume problem on a compaq presario C700 laptop
> > on the Ubuntu 2.6.24-22-generic kernel.
> >
> > SNIPPED
> >
> > These symptoms mirror a lot of other reports with this machine in that
> > the first suspend/resume cycle works but a second attempts
> > (apparently) suspends fine but fails on resume.  The backlight on the
> > video does not come back and neither does the wireless connection, so
> > I'm not positive the problems are purely video related.
> >
> > How can I proceed from here to further debug what kind of workarounds
> > or solutions I might be able to use to get reliable suspend/resume
> > functionality?
>=20
>=20
> Assuming Ubuntu uses pm-utils for suspend/hibernate operations, then I
> suspect you're needing this patch - the symptoms fit (suspend works
> the first time, but fails thereafter), especially if a reboot causes
> suspend to work fine again the first time...
>=20
> http://cgit.freedesktop.org/pm-utils/commit/?id=3D6c9f2959a36e608e4d1f712=
30a9eaaa77940c54e

I wish (and was hoping) it was that simple.  The problem is the nature
of that patch really has no effect on my system because $acpi_flag =3D=3D 0
when the sysctl on line 147 is applied.  Presumably this patch has more
effect if $acpi_flag !=3D 0, by nature of either $QUIRK_S3_BIOS or
$QUIRK_S3_MODE being =3D=3D true, neither of which is in my case.  Maybe on=
e
or both should be.  I dunno.  I'm not sure how these "video quirks"
work.

b.


--=-oZvWWwqU1q+UMm6EyXBq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklFEqMACgkQl3EQlGLyuXCOcgCfdeN8fjKCNRdlY+Tztl5WToVc
L2UAn2hHRodeR6wLQQH92D8qzleP7axn
=t5WS
-----END PGP SIGNATURE-----

--=-oZvWWwqU1q+UMm6EyXBq--

