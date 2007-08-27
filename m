Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbXH0Iwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbXH0Iwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 04:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXH0Iwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 04:52:32 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:47353 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbXH0Iwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 04:52:32 -0400
Date: Mon, 27 Aug 2007 10:52:24 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: giggz <giggzounet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM : On a laptop Aopen 1556 or 1557 my integrated
 card-reader doesn't work.
Message-ID: <20070827105224.172fc5b0@poseidon.drzeus.cx>
In-Reply-To: <20070827005710.b77ab643.akpm@linux-foundation.org>
References: <46C068FB.1040200@gmail.com>
	<20070827005710.b77ab643.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-30385-1188204738-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-30385-1188204738-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Aug 2007 00:57:10 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

>=20
> I don't even know which subsystem is supposed to handle that device.=20
> Perhaps someone can tell us.  It's a Secure Digital card slot?  I
> think the MMC subsystem can handle some types SD cards, but not all?
>=20
> Perhaps Pierre can clue us in?
>=20

The MMC layer can handle all MMC and SD cards, but it does not support
all known controllers as most vendors refuse to release any specs.

Unfortunately, that is the case here. Ricoh has several controller
interfaces, and currently we only support one of them (the public
standard sdhci interface).

So until Ricoh changes their policy or someone reverse engineers their
interface, then I'm afraid you're out of luck.

Rgds
Pierre

--=_hera.drzeus.cx-30385-1188204738-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG0pDI7b8eESbyJLgRAgoYAJ4zxKLkkYeW3szIELnUQzmhcLHg/wCgtwxS
/A/lePcZtJHWBuPLy+/YZLI=
=CoQO
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-30385-1188204738-0001-2--
