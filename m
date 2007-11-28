Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbXK1KBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbXK1KBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbXK1KBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:01:22 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:37813 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542AbXK1KBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:01:21 -0500
Date: Wed, 28 Nov 2007 11:01:11 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>
Subject: Re: m68k build failure
Message-ID: <20071128110111.0c11fbfc@poseidon.drzeus.cx>
In-Reply-To: <Pine.LNX.4.64.0711281024351.29243@anakin>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
	<20071128094856.056c0a3f@poseidon.drzeus.cx>
	<Pine.LNX.4.64.0711281020350.29243@anakin>
	<Pine.LNX.4.64.0711281024351.29243@anakin>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-27994-1196244079-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-27994-1196244079-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Nov 2007 10:27:18 +0100 (CET)
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

>=20
> So the problem is in scripts/mod/file2alias.c, which gives a different
> sizeof(struct sdio_device_id) on the cross-compile host:
>   - sizeof(struct sdio_device_id) =3D 12 on ia32
>   - sizeof(struct sdio_device_id) =3D 10 on m68k
>=20
> While file2alias.c has code to handle 32 vs. 64 bit correctly when
> cross-compiling, it doesn't handle alignment differences between host
> and target.
>=20

Delightful. So what are the options here? Start packing the device table st=
ructs is the obvious quick fix. Declaring cross-compilation unsupported isn=
't really viable, and I guess determining padding differences is far from e=
asy.

Rgds
Pierre

--=_hera.drzeus.cx-27994-1196244079-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHTTxn7b8eESbyJLgRAoNsAKDM5d2H84EjaaJ7lfVPWO9azApryACgpxiQ
356AdEHOLH4xWt7QpaqbkAE=
=7LgA
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-27994-1196244079-0001-2--
