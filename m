Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYKSSgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYKSSgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYKSSgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:36:42 -0500
Received: from server.drzeus.cx ([85.8.24.28]:49687 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753919AbYKSSgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:36:41 -0500
Date: Wed, 19 Nov 2008 19:36:31 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Ben Dooks <ben-linux@fluff.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: Re: [PATCH] mmc: atmel-mci: move atmel-mci.h file to include/linux
Message-ID: <20081119193631.448ae25e@mjolnir.drzeus.cx>
In-Reply-To: <491C3D16.1050501@atmel.com>
References: <491C0C05.6040301@atmel.com>
	<20081113134818.GA9161@fluff.org.uk>
	<491C3D16.1050501@atmel.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-8867-1227119797-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-8867-1227119797-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Nov 2008 15:43:34 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> Ben Dooks :
> >=20
> > Would people object to putting this in include/linux/mmc/atmel.h
> > to avoid making include/linux abound with device/subsystem/machine
> > specific header files?
>=20
> I tend to agree *but* it seems that header files in include/linux/mmc
> are mostly sd/mmc subsystem core files (I mean, not driver ones).
> Although, a bunch of atmel-a_driver.h files are already in include/linux.=
..
>=20
> Pierre, a comment ?
>=20

I'd prefer if include/linux/mmc could stay clean and just have core
stuff since the header files are basically the reference documentation
for the subsystem. But if you can't find any other way...

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-8867-1227119797-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkkXLUACgkQ7b8eESbyJLhzXwCfSy7x0WlXmnEvwawT/ulYVGIB
BMAAoJ7pldzsyn3IISniBuke5W9ZiX0c
=KSA1
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-8867-1227119797-0001-2--
