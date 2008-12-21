Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYLUOXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYLUOXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 09:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYLUOW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 09:22:58 -0500
Received: from server.drzeus.cx ([85.8.24.28]:47585 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752106AbYLUOW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 09:22:57 -0500
Date: Sun, 21 Dec 2008 15:22:49 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mmc_block: print better data error message after
 timeout
Message-ID: <20081221152249.2085fe53@mjolnir.drzeus.cx>
In-Reply-To: <4937DCAF.3010806@nokia.com>
References: <48F7411F.3020109@nokia.com>
	<20081026121155.69692474@mjolnir.drzeus.cx>
	<49083B1C.6060803@nokia.com>
	<20081130194845.4abd0cb8@mjolnir.drzeus.cx>
	<4937DCAF.3010806@nokia.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-26118-1229869375-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-26118-1229869375-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 04 Dec 2008 15:35:43 +0200
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> Pierre Ossman wrote:
> > On Wed, 29 Oct 2008 12:29:48 +0200
> > Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:
> >=20
> >> Waiting for the card to become ready after an error is also not includ=
ed,
> >> as it is not in the standards and is a separate issue anyway.
> >=20
> > What do you mean?
>=20
> You had suggested
>=20
> 	while (card not ready)
> 		status |=3D send_status();
>=20
> and I didn't do it, because of the reasons given above.
>=20

What confused me was that you sait "it is not in the standards", but
perhaps you were just referring to the read case? In the write case the
specs are clear that errors will be done during execution, which can be
delayed for writes.

> From: Adrian Hunter <ext-adrian.hunter@nokia.com>
> Date: Thu, 16 Oct 2008 12:55:25 +0300
> Subject: [PATCH] mmc_block: print better error messages
>=20
> Add command response and card status to error
> messages.
>=20
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> ---

Queued. Thanks for all the work. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-26118-1229869375-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklOUT4ACgkQ7b8eESbyJLgI1ACfbl8em+5FiATe2mxDYn3Ayj+j
ItgAoMo/FA8d9OrW4msITkS1Ri0gezRC
=3H1W
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-26118-1229869375-0001-2--
