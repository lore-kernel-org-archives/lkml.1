Return-Path: <linux-kernel-owner+w=401wt.eu-S1761029AbZEMTqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029AbZEMTqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZEMTp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:45:57 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:56239 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbZEMTp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:45:56 -0400
Date: Wed, 13 May 2009 21:45:51 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer
Message-ID: <20090513214551.739757fd@mjolnir.ossman.eu>
In-Reply-To: <200905061145.30698.wolfgang.mues@auerswald.de>
References: <200904081155.53173.wolfgang.mues@auerswald.de>
	<200904141627.26276.wolfgang.mues@auerswald.de>
	<20090428215730.24fa60c5@mjolnir.ossman.eu>
	<200905061145.30698.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-9094-1242243954-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-9094-1242243954-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 6 May 2009 11:45:30 +0200
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

>=20
> I checked the drivers sourcecode and found that most drivers are using EI=
NVAL=20
> for non-recoverable parameter errors.
>=20
> The only driver which uses EINVAL for errors which might result from=20
> transmission failures is mmc_spi.
>=20
> So I think it would be OK to use another error code in mmc_spi for these=
=20
> cases:
>=20
>  * EILSEQ       Basic format problem with the received or sent data
>  *              (e.g. CRC check failed, incorrect opcode in response
>  *              or bad end bit)
>=20
> Would you accept a patch to report another error code in mmc_spi?
>=20

EILSEQ seems correct for SPI bit errors, so I'd gladly accept such a
patch, yes. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-9094-1242243954-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoLI3MACgkQ7b8eESbyJLgjYwCeIFPBtSrVfXNmQb9+8bASpYJg
44AAoMhTgGr3mQePt4EUinHISRi/7lC8
=L1/q
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-9094-1242243954-0001-2--
