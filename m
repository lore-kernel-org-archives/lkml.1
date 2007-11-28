Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbXK1ItR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbXK1ItR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 03:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbXK1ItI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 03:49:08 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:59538 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbXK1ItH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 03:49:07 -0500
Date: Wed, 28 Nov 2007 09:48:56 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org
Subject: Re: m68k build failure
Message-ID: <20071128094856.056c0a3f@poseidon.drzeus.cx>
In-Reply-To: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-27223-1196239743-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-27223-1196239743-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Nov 2007 22:07:23 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

>=20
> Current Linus tree give me this, with m68k allmodconfig:
>=20
> FATAL: drivers/bluetooth/btsdio: sizeof(struct sdio_device_id)=3D12 is no=
t a modulo of the size of section __mod_sdio_device_table=3D30.
> Fix definition of struct sdio_device_id in mod_devicetable.h
>=20
> which I haven't seen before.  Any ideas?
>=20

No the slightest. 12 seems like the correct, padded size. A size of 10 is j=
ust weird as the unpadded size is 9 bytes. Could you dump the __mod_sdio_de=
vice_table section so we can determine if it is cropped or just oddly padde=
d.

Rgds
Pierre

--=_hera.drzeus.cx-27223-1196239743-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHTSt57b8eESbyJLgRArQNAKDRzHm0nyYuyDW/EnLNr8I01WEKJACg+Lov
dN7rFZy/a0lB4vFUQThroaI=
=+PB9
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-27223-1196239743-0001-2--
