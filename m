Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYKLReX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYKLReX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYKLReO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:34:14 -0500
Received: from mx39.mail.ru ([194.67.23.35]:64796 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbYKLReN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:34:13 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] Fix argument type for acpi_evaluate_integer in acpi_get_physical_pci_device
Date: Wed, 12 Nov 2008 20:34:07 +0300
User-Agent: KMail/1.9.10
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200811031216.15690.arvidjaar@mail.ru> <alpine.LFD.2.00.0811120137070.3828@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0811120137070.3828@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart18603602.VjaherT0so";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811122034.08092.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart18603602.VjaherT0so
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 12 November 2008, Len Brown wrote:
> unclear what kernel this is supposed to apply to.
>=20

The patch was against 2.6.28-rc3 and applies to rc4 as well. Sorry
for not mentioning this (I thought I did)

> On Mon, 3 Nov 2008, Andrey Borzenkov wrote:
>=20
> > Subject: [PATCH] Fix argument type for acpi_evaluate_integer in acpi_ge=
t_physical_pci_device
> > From: Andrey Borzenkov <arvidjaar@mail.ru>
> >=20
> > CC      drivers/acpi/glue.o
> > /home/bor/src/linux-git/drivers/acpi/glue.c: In function 'acpi_get_phys=
ical_pci_device':
> > /home/bor/src/linux-git/drivers/acpi/glue.c:157: warning: passing argum=
ent 4 of 'acpi_evaluate_integer' from incompatible pointer type
> >=20
> > acpi_evaluate_integer takes pointer to unsigned long long as fourth arg=
ument
> >=20
> > Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
> >=20
> > ---
> >=20
> >  drivers/acpi/glue.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >=20
> >=20
> > diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
> > index 98c9c76..436c8a3 100644
> > --- a/drivers/acpi/glue.c
> > +++ b/drivers/acpi/glue.c
> > @@ -150,7 +150,7 @@ EXPORT_SYMBOL(acpi_get_physical_device);
> >  struct device *acpi_get_physical_pci_device(acpi_handle handle)
> >  {
> >  	struct device *dev;
> > -	long device_id;
> > +	unsigned long long device_id;
> >  	acpi_status status;
> > =20
> >  	status =3D
> >=20
>=20
>=20



--nextPart18603602.VjaherT0so
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkbE48ACgkQR6LMutpd94ysiQCdEvh0C50/IIZlvZOJHtYbJwOw
i+4AoJiquPec9lg0Zr70rppTrhahU7Kf
=c9im
-----END PGP SIGNATURE-----

--nextPart18603602.VjaherT0so--
