Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbYB2Raw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbYB2Raw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYB2Ram
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:30:42 -0500
Received: from mx38.mail.ru ([194.67.23.16]:54590 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757616AbYB2Rak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:30:40 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [repost] Make real parent for ACPI button input devices
Date: Fri, 29 Feb 2008 20:30:18 +0300
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200802282114.28680.arvidjaar@mail.ru> <20080228172724.e93f6b8d.akpm@linux-foundation.org>
In-Reply-To: <20080228172724.e93f6b8d.akpm@linux-foundation.org>
MIME-Version: 1.0
Message-Id: <200802292030.19481.arvidjaar@mail.ru>
Content-Type: multipart/signed;
  boundary="nextPart5453444.b9aSijMykW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5453444.b9aSijMykW
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 29 February 2008, Andrew Morton wrote:
> On Thu, 28 Feb 2008 21:14:26 +0300 Andrey Borzenkov <arvidjaar@mail.ru> w=
rote:
>=20
> > From: Andrey Borzenkov <arvidjaar@mail.ru>
> >=20
> > Make sure input device for  ACPI button gets proper place
> > in device tree.
> >=20
> > Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
> >=20
> > ---
> >=20
> >  drivers/acpi/button.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >=20
> >=20
> > diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
> > index 24a7865..6c5da83 100644
> > --- a/drivers/acpi/button.c
> > +++ b/drivers/acpi/button.c
> > @@ -449,6 +449,7 @@ static int acpi_button_add(struct acpi_device *devi=
ce)
> >  	input->phys =3D button->phys;
> >  	input->id.bustype =3D BUS_HOST;
> >  	input->id.product =3D button->type;
> > +	input->dev.parent =3D &device->dev;
> > =20
> >  	switch (button->type) {
> >  	case ACPI_BUTTON_TYPE_POWER:
> >=20
>=20
> What are the consequences of the bug which you've fixed?
>=20

There is no direct negative impact; this is mostly cleanup that unifies
sysfs representation of ACPI input devices. The patch was submitted for
2.6.24-rc at the same time as similar patches for other ACPI input devices
but was lost for whatever reason.

> It helps very much if the changelog explains things like this so we can
> decide whether the patch is needed in 2.6.25 or even 2.6.24.x.
>=20

I guess it can safely wait for post-2.6.25.

--nextPart5453444.b9aSijMykW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEABECAAYFAkfIQSsACgkQR6LMutpd94wL7ACgiAvMiYDToHcL+w7YMOU30b0Q
um4AnjxDDuZDR4+fgWQ/+wuaPKVIJxgK
=TM6w
-----END PGP SIGNATURE-----

--nextPart5453444.b9aSijMykW--
