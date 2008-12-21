Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbYLUNWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbYLUNWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 08:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYLUNWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 08:22:36 -0500
Received: from server.drzeus.cx ([85.8.24.28]:49393 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751797AbYLUNWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 08:22:35 -0500
Date: Sun, 21 Dec 2008 14:22:25 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       drzeus-sdhci@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 3/8] SDHCI: Add set_ios hook
Message-ID: <20081221142225.189f21bf@mjolnir.drzeus.cx>
In-Reply-To: <20081202154112.316341865@fluff.org.uk>
References: <20081202154018.906091477@fluff.org.uk>
	<20081202154112.316341865@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-22924-1229865753-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-22924-1229865753-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Dec 2008 15:40:21 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> Add a set_ios hook which is called when the SDHCI driver
> is called to change parameters such as clock or card
> width.
>=20
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
>=20

NAK. As I explained earlier, this is a too broad hook and you haven't
given a proper reason for examining the card structure (which is all
that the set_ios callback does).

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-22924-1229865753-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklOQxgACgkQ7b8eESbyJLjNHgCgtwjkwMxduFYzhBOt3QErdYgk
fMIAn0q9fn1lK+SByPdKPPIlp7ANtTf5
=C199
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-22924-1229865753-0001-2--
