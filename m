Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbXLAUud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbXLAUud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 15:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXLAUuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 15:50:16 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:38163 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbXLAUuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 15:50:14 -0500
Date: Sat, 1 Dec 2007 21:50:10 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Vitaly Luban <vitaly@luban.org>
Cc: linux-kernel@vger.kernel.org, Vitaly Luban <vitaly@luban.org>
Subject: Re: [PATCH] Tokyo Electron SDIO controller (Ellen) support
Message-ID: <20071201215010.2fa3b334@poseidon.drzeus.cx>
In-Reply-To: <47511ADA.20506@luban.org>
References: <47511ADA.20506@luban.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-3368-1196542213-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-3368-1196542213-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 01 Dec 2007 00:27:06 -0800
Vitaly Luban <vitaly@luban.org> wrote:

> Kernel "pci_ids.h" file has data for that card missing.
>=20
> Also, Ellen needs some control bits flipped before it functions properly=
=20
> as SDIO controller by the spec.
> Should apply clenly to Linus and Drzeus trees. Please apply.
>=20
> Signed-off-by:  Vitaly Luban <vitaly@luban.org>
>=20
>=20

The illiteracy rates for hardware engineers must be through the roof. Nobod=
y seems capable of reading specifications anymore...

As for the patch, it's a big NAK at this point. Vendors who can't be bother=
ed to follow the standard will have to wait for Ben's separation patches be=
fore they can be supported. Then they can have some voodoo front-end to han=
dle their mistakes instead of turning sdhci.c into a collection of hacks an=
d workarounds.

Rgds
Pierre

--=_hera.drzeus.cx-3368-1196542213-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHUckD7b8eESbyJLgRAlyIAJ9ZF9mTjuRzi/Z0gawTaFDgh2Fd7QCgheWv
uuloGo2Fraz+RsqokmtKLwE=
=Hwk8
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-3368-1196542213-0001-2--
