Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbXLAU4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbXLAU4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 15:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXLAU4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 15:56:09 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:60087 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbXLAU4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 15:56:08 -0500
Date: Sat, 1 Dec 2007 21:56:02 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org
Subject: Re: m68k build failure
Message-ID: <20071201215602.7a4710d9@poseidon.drzeus.cx>
In-Reply-To: <Pine.LNX.4.64.0711281332350.29243@anakin>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
	<20071128094856.056c0a3f@poseidon.drzeus.cx>
	<20071128010056.85703a34.akpm@linux-foundation.org>
	<20071128092856.GV8181@ftp.linux.org.uk>
	<20071128132916.125e72ec@poseidon.drzeus.cx>
	<Pine.LNX.4.64.0711281332350.29243@anakin>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-3406-1196542565-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-3406-1196542565-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Nov 2007 13:34:02 +0100 (CET)
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Wed, 28 Nov 2007, Pierre Ossman wrote:
> >=20
> > Is there no directive we can stick in there that forces a reasonable al=
ignment (e.g. alignment =3D=3D sizeof(type)) independently of arch?
>=20
> We could use something like is used for compat_*.
> E.g. compare compat_s64 in <asm/compat.h> for x86 and powerpc.
>=20

Yeah, that could work. Have a header with stuff like this:

typedef u16 __attribute__((aligned(2))) aligned_u16;
typedef u32 __attribute__((aligned(4))) aligned_u32;

and let all structures in mod_devicetable.h use those types.

Now does anyone have the time to code and test this?

Rgds
Pierre

--=_hera.drzeus.cx-3406-1196542565-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHUcpj7b8eESbyJLgRAnGvAKCnuubJwNkPE9ebSezJWK0v5Sy3qQCeOlGX
g0OKbJWc7Jp+EacJq+leJpI=
=xE/e
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-3406-1196542565-0001-2--
