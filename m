Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbXLJTNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbXLJTNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 14:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXLJTNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 14:13:11 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:33975 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbXLJTNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 14:13:09 -0500
Date: Mon, 10 Dec 2007 20:12:59 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Adrian Bunk <bunk@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Al Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-arch@vger.kernel.org
Subject: Re: Correct types for mod_devicetable.h (was: Re: m68k build
 failure)
Message-ID: <20071210201259.1ad466c7@poseidon.drzeus.cx>
In-Reply-To: <20071210181112.GM20441@stusta.de>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
	<20071128094856.056c0a3f@poseidon.drzeus.cx>
	<20071128010056.85703a34.akpm@linux-foundation.org>
	<20071128092856.GV8181@ftp.linux.org.uk>
	<20071128132916.125e72ec@poseidon.drzeus.cx>
	<Pine.LNX.4.64.0711281332350.29243@anakin>
	<20071201215602.7a4710d9@poseidon.drzeus.cx>
	<Pine.LNX.4.64.0712021219430.29349@anakin>
	<20071209180818.55bf1443@poseidon.drzeus.cx>
	<20071210181112.GM20441@stusta.de>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-11357-1197313986-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-11357-1197313986-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Dec 2007 19:11:12 +0100
Adrian Bunk <bunk@kernel.org> wrote:

> On Sun, Dec 09, 2007 at 06:08:18PM +0100, Pierre Ossman wrote:
> >=20
> > This still requires a bit of maintenance to set up a kerneltypes.h for =
every arch.
>=20
> Better doing this work once than fixing similar issues again and again.
>=20

Agreed. But it raises the bar quite a bit to get this ready for upstream.

> > It also means we have to be very careful that gcc's internal alignment =
settings matched the ones in our header.
>=20
> There's nothing "gcc internal" about struct alignment - remember that=20
> any change in struct alignment would change our userspace ABI.
>=20

Oh? I would have guessed that everything going to and from userspace would =
be packed. Should probably consider myself lucky I have do deal with few su=
ch interactions. :)

Rgds
Pierre

--=_hera.drzeus.cx-11357-1197313986-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHXY+77b8eESbyJLgRAkMBAKDEtoCVIR02uv4m2bJ3GUV+z4I7cgCgyqJj
t9yFZf4JdPPUrXMls4+lNKI=
=z34A
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-11357-1197313986-0001-2--
