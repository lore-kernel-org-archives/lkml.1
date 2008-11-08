Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbYKHWUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbYKHWUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 17:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYKHWUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 17:20:38 -0500
Received: from server.drzeus.cx ([85.8.24.28]:36158 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750971AbYKHWUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 17:20:37 -0500
Date: Sat, 8 Nov 2008 23:20:24 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC fixes for 2.6.28-rc4
Message-ID: <20081108232024.5126cddd@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-7670-1226182834-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-7670-1226182834-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive the following updates:

 drivers/mmc/core/bus.c        |    3 +--
 drivers/mmc/core/core.c       |    6 +++++-
 drivers/mmc/core/host.c       |    5 ++---
 drivers/mmc/core/sdio_bus.c   |    3 +--
 drivers/mmc/host/mmc_spi.c    |    2 +-
 drivers/mmc/host/sdhci.c      |    2 +-
 drivers/mmc/host/tifm_sd.c    |   16 ++++++++--------
 include/linux/mmc/card.h      |    2 +-
 include/linux/mmc/host.h      |    2 +-
 include/linux/mmc/sdio_func.h |    2 +-
 10 files changed, 22 insertions(+), 21 deletions(-)

Kay Sievers (1):
      mmc: struct device - replace bus_id with dev_name(), dev_set_name()

Pierre Ossman (1):
      mmc: increase SD write timeout for crappy cards

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-7670-1226182834-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkWELEACgkQ7b8eESbyJLgCQwCgmJ1Zu7eURke0xH/sLgc2U/0u
VYgAoIOi2c3TrW0yDVicaez6Bi62atog
=uF8c
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-7670-1226182834-0001-2--
