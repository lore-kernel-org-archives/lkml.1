Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbZEYLu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbZEYLu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZEYLuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:50:19 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:55717 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbZEYLuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:50:18 -0400
Date: Mon, 25 May 2009 13:50:12 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "David Brownell" <david-b@pacbell.net>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Message-ID: <20090525135012.13be624c@mjolnir.ossman.eu>
In-Reply-To: <200905251218.18262.wolfgang.mues@auerswald.de>
References: <200905250243.46984.david-b@pacbell.net>
	<200905251218.18262.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-6307-1243252218-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-6307-1243252218-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 25 May 2009 12:18:18 +0200
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

>=20
> So if this code gets integrated, we can do:
>=20
> if (command is erase)
> 	accept erase response codes
> else
> 	treat erase response codes as transmission errors
>=20
> Should be no problem...
>=20

This furthers the layering violation though. I don't remember why
mmc_spi is looking at responses to begin with. It should be up to the
caller to interpret them.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-6307-1243252218-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoahfgACgkQ7b8eESbyJLiLEACfTJj0xsK4WSG/oekDN7vYjIIg
VX0AoKUi+awl8xSjE91YCbDDYuPT9LyQ
=5O9O
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-6307-1243252218-0001-2--
