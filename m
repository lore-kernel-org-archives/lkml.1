Return-Path: <linux-kernel-owner+w=401wt.eu-S934425AbZDHSlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425AbZDHSlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933019AbZDHSj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:39:56 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:34686 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbZDHSjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:39:54 -0400
Date: Wed, 8 Apr 2009 20:39:45 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7 revised] mmc_spi: convert timeout handling to
 jiffies and avoid busy waiting
Message-ID: <20090408203945.3bc06acd@mjolnir.ossman.eu>
In-Reply-To: <200904071626.30917.wolfgang.mues@auerswald.de>
References: <200904071626.30917.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-25978-1239215989-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-25978-1239215989-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Apr 2009 15:26:30 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> o SD/MMC card timeouts can be very high. So avoid busy-waiting,
>   using the scheduler. Calculate all timeouts in jiffies units,
>   because this will give us the correct sign when to involve
>   the scheduler.
>=20
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20

Also queued.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-25978-1239215989-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknc73YACgkQ7b8eESbyJLjnlACg9ydC0FIZIGXNKgXKf18O+DI2
NT8AoNGxButck/M8vha4WDNBb/leZxKw
=pSFW
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-25978-1239215989-0001-2--
