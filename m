Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZFAAr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZFAAr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 20:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZFAArt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 20:47:49 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:57772 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZFAArs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 20:47:48 -0400
Subject: Re: MPC8343 - serial8250: too much work
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Alemao <xcarandiru@gmail.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <d970ff420905291307p62e9c6eck772e7ee3757ee44a@mail.gmail.com>
References: <d970ff420905291307p62e9c6eck772e7ee3757ee44a@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UpL8Ug4s3osT0+c/31iG"
Date: Mon, 01 Jun 2009 10:47:48 +1000
Message-Id: <1243817268.4375.28.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UpL8Ug4s3osT0+c/31iG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-29 at 17:07 -0300, Alemao wrote:
> Im facing some problems with serial, linux-2.6.23, getting flooded
> with this message in logs:
>=20
> ---
> serial8250: too much work for irq16
> ---
>=20
> Something I notice, in my .dts I have the following lines:
>=20
> serial0: serial@4500,  interrupts   =3D  <9  0x8>
> serial1: serial@4600,  interrupts   =3D  <10 0x8>
> spi:       spi@7000,     interrupts   =3D  <16 0x8>
>=20
>=20
> But when kernel starts:
>=20
> ---
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> serial8250.0: ttyS0 at MMIO 0xe0004500 (irq =3D 16) is a 16550A
> ---
>=20
> Why IRQ 16? Shouldn't it be IRQ 9?

No. Interrupt numbers are remapped on powerpc. If you were running a
mainline kernel you'd see a message something like:

irq: irq 9 on host ?? mapped to virtual irq 16

cheers


--=-UpL8Ug4s3osT0+c/31iG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkojJTQACgkQdSjSd0sB4dJ7bACfXBPpPRyorpEiJv+UEn1zbdvZ
qYkAn30h1cAVrksQ+uVUAq19GvA1c/f9
=tMIl
-----END PGP SIGNATURE-----

--=-UpL8Ug4s3osT0+c/31iG--

