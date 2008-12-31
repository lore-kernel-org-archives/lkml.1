Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbYLaTBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbYLaTBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbYLaTBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:01:37 -0500
Received: from server.drzeus.cx ([85.8.24.28]:49749 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756087AbYLaTBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:01:36 -0500
Date: Wed, 31 Dec 2008 20:01:25 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC merge for 2.6.29
Message-ID: <20081231200125.3d07d5e4@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-10526-1230750091-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-10526-1230750091-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive the following updates:

 drivers/mmc/card/block.c      |  122 ++++++++++++++++++++++++++-------
 drivers/mmc/core/core.c       |   77 +++++++++++++++++++++
 drivers/mmc/core/mmc.c        |   18 ++++-
 drivers/mmc/host/Makefile     |    3 +
 drivers/mmc/host/at91_mci.c   |    4 +-
 drivers/mmc/host/mmc_spi.c    |    4 +-
 drivers/mmc/host/of_mmc_spi.c |  149 +++++++++++++++++++++++++++++++++++++=
++++
 drivers/mmc/host/pxamci.c     |    2 +-
 drivers/mmc/host/ricoh_mmc.c  |   17 +++--
 drivers/mmc/host/sdhci-pci.c  |    2 +-
 drivers/mmc/host/sdhci.c      |   17 +++--
 drivers/mmc/host/sdhci.h      |    2 +-
 drivers/mmc/host/sdricoh_cs.c |    4 +-
 drivers/mmc/host/tmio_mmc.c   |    3 +-
 include/linux/mmc/core.h      |    2 +
 include/linux/mmc/host.h      |    2 +
 include/linux/spi/mmc_spi.h   |   15 ++++-
 17 files changed, 392 insertions(+), 51 deletions(-)
 create mode 100644 drivers/mmc/host/of_mmc_spi.c

Adrian Hunter (2):
      mmc_block: print better error messages
      mmc_block: ensure all sectors that do not have errors are read

Anton Vorontsov (2):
      mmc: Add mmc_vddrange_to_ocrmask() helper function
      mmc_spi: Add support for OpenFirmware bindings

Arjan van de Ven (1):
      pci: use pci_ioremap_bar() in drivers/mmc

David Brownell (1):
      mmc: warn about voltage mismatches

Harvey Harrison (1):
      mmc: trivial annotation of 'blocks'

Jarkko Lavinen (1):
      mmc: Add 8-bit bus width support

Julia Lawall (1):
      drivers/mmc: Move a dereference below a NULL test

Nicolas Ferre (1):
      mmc: at91_mci: reorder timer setup and mmc_add_host() call

Pierre Ossman (2):
      sdhci: handle built-in sdhci with modular leds class
      Merge branch 'master' of ../mmc

Roel Kluin (1):
      mmc: balanc pci_iomap with pci_iounmap

Sascha Sommer (1):
      sdricoh_cs: Add support for Bay Controller devices

Vernon Sauder (1):
      pxamci: fix dma_unmap_sg length

philipl@overt.org (1):
      ricoh_mmc: Handle newer models of Ricoh controllers

=C3=89ric Piel (1):
      sdhci: activate led support also when module


Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-10526-1230750091-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklbwYoACgkQ7b8eESbyJLgOygCfYOwywzElbZIvWiib+Dq5LTp0
Pc8An1lBqTwjJUduu5/uwLfg6WYUiRcr
=A7q9
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-10526-1230750091-0001-2--
