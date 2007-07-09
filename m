Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbXGIQnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbXGIQnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759175AbXGIQ2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:28:05 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:53565 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759340AbXGIQ2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:28:03 -0400
Date: Mon, 9 Jul 2007 18:27:57 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       wux@landicorp.com, Linux Kernel list <linux-kernel@vger.kernel.org>,
       Hamish Guthrie <hamish@prodigi.ch>,
       Andrew Victor <andrew@sanpeople.com>, Marc Pignat <marc.pignat@hevs.ch>,
       m.kozlowski@tuxland.pl
Subject: Re: [PATCH] mmc: at91_mci: fix hanging and rework to match
 flowcharts
Message-ID: <20070709182757.5a810ac1@poseidon.drzeus.cx>
In-Reply-To: <469230E8.5000005@rfo.atmel.com>
References: <4688EC94.1090901@rfo.atmel.com>
	<469230E8.5000005@rfo.atmel.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-11580-1183998492-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-11580-1183998492-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 09 Jul 2007 14:58:16 +0200
Nicolas Ferre <nicolas.ferre@rfo.atmel.com> wrote:

> Fixes hanging using multi block operations (seen during CMD25).
> Follows closely the datasheet flowcharts.
>=20
> This piece of code handles better big file writing. I had to take
> care of the notbusy signal during write (at91_mci_handle_cmdrdy
> function) and to rearrange the AT91_MCI_ENDRX and AT91_MCI_RXBUFF
> flag usage.
>=20
> Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
> ---

Thanks, applied.

Rgds
Pierre

--=_hera.drzeus.cx-11580-1183998492-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGkmIN7b8eESbyJLgRAsdQAKDQJOVH5DWawMfy5xmz+Ns6HKq+tQCffNwJ
hY9FIJdwhXzdgNvL++JBQzg=
=TKAj
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-11580-1183998492-0001-2--
