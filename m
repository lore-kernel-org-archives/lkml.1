Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbYGZXag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbYGZXag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 19:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYGZXa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 19:30:29 -0400
Received: from server.drzeus.cx ([85.8.24.28]:41639 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752182AbYGZXa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 19:30:29 -0400
Date: Sun, 27 Jul 2008 01:30:23 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates for 2.6.27
Message-ID: <20080727013023.7cf2089a@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-3631-1217115028-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-3631-1217115028-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This should be the last set of MMC patches for the .27 merge window.

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive the following updates:

 drivers/mmc/core/Makefile         |    1 +
 drivers/mmc/core/bus.c            |    8 ++
 drivers/mmc/core/core.h           |    7 +
 drivers/mmc/core/debugfs.c        |  225 +++++++++++++++++++++++++++++++++=
++++
 drivers/mmc/core/host.c           |    8 ++
 drivers/mmc/host/atmel-mci-regs.h |    2 +
 drivers/mmc/host/atmel-mci.c      |  189 +++++++++++++++++++++++++++++++
 drivers/mmc/host/imxmmc.c         |   50 +++------
 drivers/mmc/host/mmc_spi.c        |    3 +-
 include/linux/mmc/card.h          |    2 +
 include/linux/mmc/host.h          |    2 +
 11 files changed, 461 insertions(+), 36 deletions(-)
 create mode 100644 drivers/mmc/core/debugfs.c

Haavard Skinnemoen (3):
      mmc: Export internal host state through debugfs
      mmc: Add per-card debugfs support
      atmel-mci: debugfs support

Jan Nikitenko (1):
      mmc_spi: put signals to low power off fix

Paulius Zaleckas (3):
      imxmmc: remove DEBUG definition
      imxmmc: fix platform resources
      imxmmc: fix crash when no platform data is provided

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-3631-1217115028-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiLs5IACgkQ7b8eESbyJLg1ewCg7BaloXWSNtGk6XyQX7ln0ile
uakAoOAv73D/ou1neQuWVD9eYsVwRzBq
=IFPf
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-3631-1217115028-0001-2--
