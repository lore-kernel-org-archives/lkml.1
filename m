Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbXLIRKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbXLIRKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 12:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbXLIRKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 12:10:44 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:58431 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbXLIRKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 12:10:43 -0500
Date: Sun, 9 Dec 2007 18:10:40 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Adrian Bunk <bunk@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
Subject: Re: Correct types for mod_devicetable.h (was: Re: m68k build
 failure)
Message-ID: <20071209181040.52a50cef@poseidon.drzeus.cx>
In-Reply-To: <20071208215811.GD20441@stusta.de>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
	<20071201215602.7a4710d9@poseidon.drzeus.cx>
	<Pine.LNX.4.64.0712021219430.29349@anakin>
	<200712032102.20353.rusty@rustcorp.com.au>
	<20071208215811.GD20441@stusta.de>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-21561-1197220241-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-21561-1197220241-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 8 Dec 2007 22:58:11 +0100
Adrian Bunk <bunk@kernel.org> wrote:

> On Mon, Dec 03, 2007 at 09:02:19PM +1100, Rusty Russell wrote:
> > So, just insert two bits of padding in sdio_device_id and insert a comm=
ent=20
> > saying "/* Explicit padding: works even if we're cross-compiling */".
>=20
> We had one such problem in 2.6.23 and now we had a similar one in 2.6.24.
>=20
> Getting the alignment issues automatically right would really be an=20
> improvement...
>=20

Agreed. I won't veto a quick and dirty fix, but I would prefer if this coul=
d be solved properly.

Rgds
Pierre

--=_hera.drzeus.cx-21561-1197220241-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHXCGQ7b8eESbyJLgRAm3rAJ0eg0n5VDf624d9hWtM1TiZcQG2AQCghDOX
oRWyYfns9RdUXS41uHukhEA=
=d4CM
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-21561-1197220241-0001-2--
