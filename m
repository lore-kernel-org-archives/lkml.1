Return-Path: <linux-kernel-owner+w=401wt.eu-S939552AbXHIMfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939552AbXHIMfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936551AbXHIMeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:34:50 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:53769 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762849AbXHIMet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:34:49 -0400
Date: Thu, 9 Aug 2007 14:34:44 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Fix section mismatch warnings for drivers/mmc/host
Message-ID: <20070809143444.484e7dfb@poseidon.drzeus.cx>
In-Reply-To: <46B2207C.9060406@googlemail.com>
References: <46B2207C.9060406@googlemail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-12303-1186662885-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-12303-1186662885-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 02 Aug 2007 20:20:44 +0200
Gabriel C <nix.or.die@googlemail.com> wrote:

> This patch fixes the following section mismatch warnings
>=20
> ...
>=20
> WARNING: vmlinux.o(.init.text+0x29d40): Section mismatch: reference
> to .exit.text:wbsd_release_resources (between 'wbsd_init' and
> 'wbsd_probe') WARNING: vmlinux.o(.init.text+0x29d49): Section
> mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init'
> and 'wbsd_probe') WARNING: vmlinux.o(.init.text+0x29f28): Section
> mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init'
> and 'wbsd_probe')
>=20
> ...
>=20
> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
> Cc: Pierre Ossman <drzeus@drzeus.cx>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
>=20

Thanks, applied.

Rgds
Pierre

--=_hera.drzeus.cx-12303-1186662885-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGuwnk7b8eESbyJLgRAioMAKDCV3KFvki6ivkS7r4CPCSD/3WTIwCfTqwP
nA0Ge91pJPPes+21tijLIYU=
=4RsM
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-12303-1186662885-0001-2--
