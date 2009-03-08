Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZCHOw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZCHOw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 10:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZCHOwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 10:52:50 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:55936 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZCHOwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 10:52:49 -0400
Date: Sun, 8 Mar 2009 15:44:35 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Arnd Bergmann <arnd@arndb.de>, Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 11/11] mmc: Add OpenFirmware bindings for SDHCI driver
Message-ID: <20090308154435.41aa2dde@mjolnir.ossman.eu>
In-Reply-To: <20090305202850.GK28709@oksana.dev.rtsoft.ru>
References: <20090305202737.GA24166@oksana.dev.rtsoft.ru>
	<20090305202850.GK28709@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-22905-1236523479-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-22905-1236523479-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Mar 2009 23:28:50 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> This patch adds a new driver: sdhci-of. The driver is similar to
> the sdhci-pci, it contains common probe code, and controller-specific
> ops and quirks.
>=20
> So far there are only Freescale eSDHC ops and quirks.
>=20
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/mmc/host/Kconfig    |   10 ++
>  drivers/mmc/host/Makefile   |    1 +
>  drivers/mmc/host/sdhci-of.c |  309 +++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 320 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mmc/host/sdhci-of.c
>=20

I'd like a MAINTAINERS entry for this (sub)driver.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-22905-1236523479-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkmz2dcACgkQ7b8eESbyJLgmiACgkrBrEsUvnUPlVAopTf97VJer
udMAoOdfs2neHg/1cKR0Eckqsp5QFbtT
=nIKS
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-22905-1236523479-0001-2--
