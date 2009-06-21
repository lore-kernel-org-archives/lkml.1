Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbZFUTWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbZFUTWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 15:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZFUTWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 15:22:46 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:59276 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbZFUTWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 15:22:45 -0400
Date: Sun, 21 Jun 2009 21:22:40 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] More MMC stuff for 2.6.31
Message-ID: <20090621212240.42539cfc@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-13775-1245612167-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-13775-1245612167-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

Primarily this update contains two new drivers; one for VIA's new controller
found in some of their chipsets, and one for Samsung's modern SoC chips.

There are also a few minor fixes and workarounds in this update.

 Documentation/powerpc/dts-bindings/fsl/esdhc.txt |    2 +
 MAINTAINERS                                      |   22 +
 drivers/mmc/host/Kconfig                         |   36 +
 drivers/mmc/host/Makefile                        |    2 +
 drivers/mmc/host/s3cmci.c                        |    2 +-
 drivers/mmc/host/sdhci-of.c                      |    3 +
 drivers/mmc/host/sdhci-pci.c                     |   20 +
 drivers/mmc/host/sdhci-s3c.c                     |  428 +++++++
 drivers/mmc/host/sdhci.c                         |   52 +-
 drivers/mmc/host/sdhci.h                         |    6 +
 drivers/mmc/host/via-sdmmc.c                     | 1362 ++++++++++++++++++=
++++
 11 files changed, 1929 insertions(+), 6 deletions(-)
 create mode 100644 drivers/mmc/host/sdhci-s3c.c
 create mode 100644 drivers/mmc/host/via-sdmmc.c

Anton Vorontsov (1):
      sdhci: Add support for hosts that are only capable of 1-bit transfers

Ben Dooks (4):
      sdhci-s3c: Samsung S3C based SDHCI controller glue
      sdhci: Add better ADMA error reporting
      sdhci: Add SDHCI_QUIRK_NO_MULTIBLOCK quirk
      s3cmci: fix dma configuration call

Harald Welte (2):
      mmc: Add new via-sdmmc host controller driver
      sdhci: Specific quirk vor VIA SDHCI controller in VX855ES

Nicolas Ferre (1):
      MAINTAINERS: add myself as atmel-mci maintainer (sd/mmc interface)

Pierre Ossman (1):
      sdhci: remove needless double parenthesis


--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-13775-1245612167-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko+iIYACgkQ7b8eESbyJLjAMwCgk3eKttOSglh8gshNL0Z0wD5w
WrQAnRKn7Sd3ayQuCg17hVhp/t8OBywx
=rVIH
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-13775-1245612167-0001-2--
