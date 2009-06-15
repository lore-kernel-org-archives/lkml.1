Return-Path: <linux-kernel-owner+w=401wt.eu-S933588AbZFOTYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588AbZFOTYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZFOTYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:24:13 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:42332 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZFOTYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:24:12 -0400
Date: Mon, 15 Jun 2009 21:24:09 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: fail gracefully if host or card do not support
 the switch command
Message-ID: <20090615212409.14e7a51b@mjolnir.ossman.eu>
In-Reply-To: <200906151036.05884.wolfgang.mues@auerswald.de>
References: <200906111713.27504.wolfgang.mues@auerswald.de>
	<20090613130829.49216355@mjolnir.ossman.eu>
	<200906151036.05884.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-29012-1245093853-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-29012-1245093853-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Jun 2009 10:36:05 +0200
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> Am Samstag, 13. Juni 2009 schrieb Pierre Ossman:
> > For SD there are several checks=20
> > before the switch command is actually issued.
>=20
> But there are two cases not covered by these checks:
>=20
> a) the switch command is supported, but the card is not capable of switch=
ing=20
> to 50 MHz.
>=20

But a successful switch command (even if the response is that the card
cannot do it) should not need the checks you added. The switch data
structure is checked further down.

> b) the card rejects the switch command in SPI mode, because it is not=20
> mandatory here.

I cannot see anything in the spec backing up this claim.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-29012-1245093853-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko2n9wACgkQ7b8eESbyJLhp9ACg6Fw/TCGQS2wA0qZYHGrYAUHA
E/UAn02FvIPUnzV3WjJDOUYESBj7akgy
=uBxw
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-29012-1245093853-0001-2--
