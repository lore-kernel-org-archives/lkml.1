Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbYGZXeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbYGZXeu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 19:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYGZXen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 19:34:43 -0400
Received: from server.drzeus.cx ([85.8.24.28]:49392 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752182AbYGZXen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 19:34:43 -0400
Date: Sun, 27 Jul 2008 01:34:38 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Thomas Kunze <thommycheck@gmx.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, thommycheck@gmx.de,
       david-b@packbell.net
Subject: Re: mmc_test with mmc_spi
Message-ID: <20080727013438.26ff87e5@mjolnir.drzeus.cx>
In-Reply-To: <4888825A.1080503@gmx.de>
References: <4888825A.1080503@gmx.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-3655-1217115282-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-3655-1217115282-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Jul 2008 15:23:38 +0200
Thomas Kunze <thommycheck@gmx.de> wrote:

> Hi Pierre,
>=20
> I wrote a small hack to be able to use the mmc_test driver on mmc-spi hos=
t. You or somebody else might find it useful.
> All test but "Correct xfer_size at write (start failure)", "Correct xfer_=
size at read (start failure)" and "Correct xfer_size=20
> at write (midway failure)" passed.
> I'm not sure what these tests try to do and how they do it, so I don't kn=
ow if my modifcations of mmc_test, my spi driver or the=20
> mmc-spi driver are responsible.
>=20
> It would be great if you could provide some insight.
>=20

I haven't really thought about the SPI part that much. It has just the
one driver, so bugs should not be that reoccuring. There's no harm in
making mmc_test handle it though.

I don't know why those tests fail. There's a bit hackish, so they might
not work as intended with the SPI version of the protocol. Basically,
the send and invalid request to the controller where the card will stop
the data transaction too early. This is a crude test to make sure the
controller doesn't over-estimate the amount of data transferred.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-3655-1217115282-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiLtJAACgkQ7b8eESbyJLgi0QCgqYZrFa2BPvTU4Hhmc5+OobDn
pSIAoPQBy6yYa2cLSfPoGNrOqnLe7EMt
=o3oo
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-3655-1217115282-0001-2--
