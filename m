Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZETKJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZETKJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZETKI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:08:59 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:34511 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbZETKI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:08:58 -0400
Date: Wed, 20 May 2009 12:08:51 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: David Brownell <david-b@pacbell.net>
Cc: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Message-ID: <20090520120851.49783a8e@mjolnir.ossman.eu>
In-Reply-To: <200905200220.46569.david-b@pacbell.net>
References: <200905192149.07778.david-b@pacbell.net>
	<200905201035.23964.wolfgang.mues@auerswald.de>
	<200905200220.46569.david-b@pacbell.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-753-1242814137-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-753-1242814137-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2009 02:20:46 -0700
David Brownell <david-b@pacbell.net> wrote:

> On Wednesday 20 May 2009, Wolfgang M=C3=BCes wrote:
> > R1_SPI_COM_CRC is a transmission error - no doubt. Mapping to EILSEQ is=
 OK.
> >=20
> > R1_SPI_ERASE_SEQ and R1_SPI_ERASE_RESET are responses to a sector erase=
=20
> > command. block.c is not sending such commands, so block.c can safely as=
sume=20
> > that each such response is a transmission error.
>=20
> Hmm, would hope that's not a long-term plan.  Remember that the
> firmware in the card can leverage "that's erased" knowledge for
> things like wear leveling.  SSDs and other storage devices would
> likewise benefit from such knowledge.  I'm quite certain there's
> been discussion about adding support for that in the block layer.
>=20

It's already in AFAIK. I even had code for hooking it up to mmc_block.
But it didn't produce any measurable results so I never merged it.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-753-1242814137-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoT1rcACgkQ7b8eESbyJLgKuQCfbVIHs1EsvKzfqZTURADEwZ4o
AD4AnjUiedHDX2McJIFUYgPsu2Td/9Ru
=vAL6
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-753-1242814137-0001-2--
