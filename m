Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZBHVHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZBHVHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbZBHVGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:06:55 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:51512 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbZBHVGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:06:54 -0500
Date: Sun, 8 Feb 2009 22:06:47 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 09/11] sdhci: Add set_clock callback
Message-ID: <20090208220647.33022d92@mjolnir.drzeus.cx>
In-Reply-To: <20090206180659.GI11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
	<20090206180659.GI11548@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-4745-1234127211-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-4745-1234127211-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Feb 2009 21:06:59 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> FSL eSDHC hosts have incompatible register map to manage the SDCLK.
> This patch adds set_clock callback so that drivers could overwrite
> set_clock behaviour.
>=20
> Similar patch[1] was posted by Ben Dooks, though in Ben's version the
> callback is named change_clock, plus the patch has some unrelated bits
> that makes the patch difficult to reuse.
>=20
> [1] http://lkml.org/lkml/2008/12/2/160
>=20
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---

A set_clock() callback is reasonable as there might be a clock source
that needs to be set up, but completely overriding the normal routine
(i.e. the "return") should be quirked IMO.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-4745-1234127211-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmPSWoACgkQ7b8eESbyJLgXRgCgvtck8mukBbgKNWOIOKo4Ot07
gy0AoLjU6SR0saqGyhnMXmABQjtryjRB
=deMA
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-4745-1234127211-0001-2--
