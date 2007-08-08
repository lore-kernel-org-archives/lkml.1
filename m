Return-Path: <linux-kernel-owner+w=401wt.eu-S934643AbXHHPBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934643AbXHHPBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbXHHPBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:01:16 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:60459 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355AbXHHPBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:01:15 -0400
Date: Wed, 8 Aug 2007 17:01:08 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: "??" <wux@landicorp.com>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] mmc: at91_mci: add multiwrite cap
Message-ID: <20070808170108.4db814d1@poseidon.drzeus.cx>
In-Reply-To: <46B9D6EE.4040705@rfo.atmel.com>
References: <46B9926B.3090707@rfo.atmel.com>
	<20070808121147.1433d055@poseidon.drzeus.cx>
	<46B9D6EE.4040705@rfo.atmel.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-25436-1186585270-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-25436-1186585270-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 08 Aug 2007 16:45:02 +0200
Nicolas Ferre <nicolas.ferre@rfo.atmel.com> wrote:

>=20
> Pierre,
>=20
> I am a little confused : the probe function does not seem to get=20
> called... (I tried both module an in-kernel form / inserting sd or
> mmc cards).
>=20
> The modules is correctly inserted : mmc_register_driver() returns 0.
>=20
> Did I miss something ?
>=20

You might need to make sure that mmc_block isn't attaching to the card.

Rgds
Pierre

--=_hera.drzeus.cx-25436-1186585270-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGudq07b8eESbyJLgRAn7EAKD2tu72eL4AI2AKvzral3gus0yyKQCfSLHX
sDqRpNYbTYDgMWe8cgM78WM=
=kInH
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-25436-1186585270-0001-2--
