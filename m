Return-Path: <linux-kernel-owner+w=401wt.eu-S1762861AbZFMLIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861AbZFMLIo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 07:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbZFMLIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 07:08:37 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:45096 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZFMLIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 07:08:36 -0400
Date: Sat, 13 Jun 2009 13:08:29 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: fail gracefully if host or card do not support
 the switch command
Message-ID: <20090613130829.49216355@mjolnir.ossman.eu>
In-Reply-To: <200906111713.27504.wolfgang.mues@auerswald.de>
References: <200906111713.27504.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-24991-1244891313-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-24991-1244891313-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Jun 2009 16:13:27 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> The switch command (typically speed switching from 25 to 50 MHz clock)
> can be rejected by _both_ the host controller/driver and by the card.
> Elder revisions of the SD card do not support speed switching.
> Fail gracefully if the reject is comming from the card.
>=20
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20

Have you ever seen this in practice? For SD there are several checks
before the switch command is actually issued. Sounds like there is
something else wrong here. Have you turned off your EMP thingy? ;)

PS. Please use the @ossman.eu address.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-24991-1244891313-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoziLEACgkQ7b8eESbyJLhhyACgoM5tDXlCS6icnTlr2hb+ewdN
mvsAn0ydr2GYfZN0qvV0pz4M7L4CqQmn
=eOyy
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-24991-1244891313-0001-2--
