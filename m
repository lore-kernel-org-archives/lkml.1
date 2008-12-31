Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbYLaRVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbYLaRVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYLaRVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:21:45 -0500
Received: from server.drzeus.cx ([85.8.24.28]:58623 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752233AbYLaRVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:21:44 -0500
Date: Wed, 31 Dec 2008 18:21:35 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc_block: ensure all sectors that do not have
 errors are read
Message-ID: <20081231182135.57447238@mjolnir.drzeus.cx>
In-Reply-To: <494F7A02.2030302@nokia.com>
References: <48F74121.1020409@nokia.com>
	<20081026123228.26d2a86a@mjolnir.drzeus.cx>
	<4908727F.5080003@nokia.com>
	<20081130200558.21f2561b@mjolnir.drzeus.cx>
	<49390BD7.3040305@nokia.com>
	<20081221152915.352d5c05@mjolnir.drzeus.cx>
	<494F7A02.2030302@nokia.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-8403-1230744101-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-8403-1230744101-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Dec 2008 13:29:06 +0200
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> Pierre Ossman wrote:
> >=20
> > Unfortunately, there is no guarantee that the sg list will be sector
> > aligned.
>=20
> OK.  I am curious though - do you know anywhere in the kernel that actual=
ly
> does submit I/O in buffers that are not aligned to 512?
>=20

Not really, no. Not that I've gone digging.

>=20
> From: Adrian Hunter <ext-adrian.hunter@nokia.com>
> Subject: [PATCH] mmc_block: ensure all sectors that do not have errors ar=
e read
>=20
> If a card encounters an ECC error while reading a sector it will
> timeout.  Instead of reporting the entire I/O request as having
> an error, redo the I/O one sector at a time so that all readable
> sectors are provided to the upper layers.
>=20
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> ---

Queued up. Thanks for sticking through this somewhat long review
process. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-8403-1230744101-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklbqiMACgkQ7b8eESbyJLg9fgCgsSFNVoFO0uhWXzirfKFNcz2A
LdgAoP1XbJmAcrQmC6wP2/tRc0sgyd/k
=ep6a
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-8403-1230744101-0001-2--
