Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbXLIRIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbXLIRIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 12:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXLIRIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 12:08:24 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:46167 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXLIRIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 12:08:22 -0500
Date: Sun, 9 Dec 2007 18:08:18 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-arch@vger.kernel.org
Subject: Re: Correct types for mod_devicetable.h (was: Re: m68k build
 failure)
Message-ID: <20071209180818.55bf1443@poseidon.drzeus.cx>
In-Reply-To: <Pine.LNX.4.64.0712021219430.29349@anakin>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
	<20071128094856.056c0a3f@poseidon.drzeus.cx>
	<20071128010056.85703a34.akpm@linux-foundation.org>
	<20071128092856.GV8181@ftp.linux.org.uk>
	<20071128132916.125e72ec@poseidon.drzeus.cx>
	<Pine.LNX.4.64.0711281332350.29243@anakin>
	<20071201215602.7a4710d9@poseidon.drzeus.cx>
	<Pine.LNX.4.64.0712021219430.29349@anakin>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-21530-1197220101-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-21530-1197220101-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 2 Dec 2007 12:22:31 +0100 (CET)
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

>=20
> I gave it a try:
>   - Remove existing alignment attributes from some device_id types
>   - Introduce kernel_* types with proper size and alignment for
>     cross-compilation (sample <asm/kerneltypes.h> for m68k included)
>   - Introduce BITS_PER_KERNEL_LONG, to make it clearer it applies to the =
target
>=20
> Apart from a cross-compile session for m68k, it's untested.
>=20

This still requires a bit of maintenance to set up a kerneltypes.h for ever=
y arch. It also means we have to be very careful that gcc's internal alignm=
ent settings matched the ones in our header.

Rgds
Pierre

--=_hera.drzeus.cx-21530-1197220101-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHXCED7b8eESbyJLgRAgESAJ0R9nblCyDiATSLluhXtkQbaEDfpwCgxTwN
mqkWi0Qs7h/8cg1As85dxFI=
=TB+W
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-21530-1197220101-0001-2--
