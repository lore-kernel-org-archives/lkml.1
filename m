Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYK3TMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYK3TMM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 14:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYK3TL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 14:11:57 -0500
Received: from server.drzeus.cx ([85.8.24.28]:38543 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752557AbYK3TL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 14:11:57 -0500
Date: Sun, 30 Nov 2008 20:11:48 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: MMC: Add 8-bit bus width support
Message-ID: <20081130201148.56771c04@mjolnir.drzeus.cx>
In-Reply-To: <20081117123521.GA15417@angel.research.nokia.com>
References: <20081117123521.GA15417@angel.research.nokia.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-22847-1228072314-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-22847-1228072314-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Nov 2008 14:35:21 +0200
Jarkko Lavinen <jarkko.lavinen@nokia.com> wrote:

> Hi Pierre
>=20
> Here is a patch which adds 8-bit bus width suport to the mmc
> driver common part. =20
>=20
> I've tested it with a test board with 8-bit eMMC device on Omap
> 3420 HSMMC controller. It speeds up DMA transfer from host to the
> card and most of the time is spent in busy polling for the card
> to become ready.
>=20

Patch looks ok. I'll see if I can do some testing here. Not sure my MMC
cards are fast enough to notice any difference though...

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-22847-1228072314-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkky5XkACgkQ7b8eESbyJLi3KgCgwnrhlyDZToUL0NMUDrjv7bYD
KAMAn2HlQn3oIq2TMFNkwH2YF4B0inNI
=t2Ki
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-22847-1228072314-0001-2--
