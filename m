Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbZE2MgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbZE2MgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZE2MgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:36:11 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:40710 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513AbZE2MgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:36:10 -0400
Date: Fri, 29 May 2009 14:36:01 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org,
       Ian Molton <spyro@f2s.com>
Subject: Re: [PATCH 1/5] MFD,mmc: tmio_mmc: make HCLK configurable
Message-ID: <20090529143601.28a61272@mjolnir.ossman.eu>
In-Reply-To: <20090529112035.GA12307@sortiz.org>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
	<1243279681-4233-2-git-send-email-philipp.zabel@gmail.com>
	<20090529112035.GA12307@sortiz.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-24449-1243600568-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-24449-1243600568-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 29 May 2009 13:20:35 +0200
Samuel Ortiz <sameo@openedhand.com> wrote:

> On Mon, May 25, 2009 at 09:27:57PM +0200, Philipp Zabel wrote:
> > The Toshiba parts all have a 24 MHz HCLK, but HTC ASIC3 has a 24.576 MH=
z HCLK
> > and AMD Imageon w228x's HCLK is 80 MHz. With this patch, the MFD driver
> > provides the HCLK frequency to tmio_mmc via mfd_cell->driver_data.
> Looks good to me. Ian, are you ok with this one ?
>=20
> Pierre, are you fine with me pushing the mmc bits of this patch through t=
he
> mfd tree ?

Sure, as long as Ian acks them.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-24449-1243600568-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkof1rUACgkQ7b8eESbyJLgAjwCeLQh0Yk1gJOb7EKESoz5oFUTZ
OBUAnRBnKdal08dISe01nwrLpz+/OhcF
=HBXD
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-24449-1243600568-0001-2--
