Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbYJLJUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbYJLJUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYJLJU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:20:26 -0400
Received: from server.drzeus.cx ([85.8.24.28]:54741 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751437AbYJLJUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:20:25 -0400
Date: Sun, 12 Oct 2008 11:20:15 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [GIT PULL] MMC updates for 2.6.28-rc1
Message-ID: <20081012112015.094aa0bd@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-12512-1223803225-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-12512-1223803225-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive the following updates:

 arch/avr32/boards/atngw100/setup.c      |    7 +-
 arch/avr32/boards/atstk1000/atstk1002.c |   18 +-
 arch/avr32/boards/atstk1000/atstk1003.c |   12 +-
 arch/avr32/boards/atstk1000/atstk1004.c |   12 +-
 arch/avr32/include/asm/atmel-mci.h      |   32 +-
 arch/avr32/mach-at32ap/at32ap700x.c     |   90 ++-
 drivers/mmc/Kconfig                     |    9 +-
 drivers/mmc/card/Kconfig                |    3 +-
 drivers/mmc/card/block.c                |   46 +-
 drivers/mmc/card/queue.c                |   23 +-
 drivers/mmc/core/mmc_ops.c              |    8 +-
 drivers/mmc/core/sdio.c                 |   52 ++-
 drivers/mmc/core/sdio_irq.c             |   16 +-
 drivers/mmc/host/Kconfig                |   30 +-
 drivers/mmc/host/atmel-mci-regs.h       |    6 +-
 drivers/mmc/host/atmel-mci.c            | 1352 ++++++++++++++++++++++-----=
----
 drivers/mmc/host/mmc_spi.c              |   32 +-
 drivers/mmc/host/sdhci-pci.c            |    3 +-
 drivers/mmc/host/sdhci.c                |   46 +-
 drivers/mmc/host/sdhci.h                |    2 +
 include/linux/mmc/host.h                |    2 +-
 21 files changed, 1294 insertions(+), 507 deletions(-)

Haavard Skinnemoen (8):
      atmel-mci: Initialize BLKR before sending data transfer command
      atmel-mci: Implement tasklet as a state machine
      atmel-mci: Don't stop the clock between transfers
      atmel-mci: Platform code for supporting multiple mmc slots
      atmel-mci: support multiple mmc slots
      atmel-mci: Add experimental DMA support
      atmel-mci: Don't overwrite error bits when NOTBUSY is set
      atmel-mci: Add missing flush_dcache_page() in PIO transfer code

Matthew Fleming (2):
      MMC: CSD and CID timeout values
      MMC: Use timeout values from CSR

Pierre Ossman (13):
      sdhci: let the controller wait for busy state to end
      sdhci: reduce card detection delay
      sdio: make sleep on error interruptable
      sdio: give sdio irq thread a host specific name
      mmc_block: inform block layer about sector count restriction
      mmc_block: indicate strict ordering
      mmc_block: filter out PC requests
      sdhci: force high speed capability on some controllers
      mmc_block: hard code 512 byte block size
      sdio: high-speed support
      mmc: remove redundant "depends on"
      mmc: explicitly mention SDIO support in Kconfig
      Merge branch 'master' of git://git.kernel.org/.../hskinnemoen/atmel-m=
ci-2.6.28

Steven Noonan (1):
      sdhci: 'scratch' may be used uninitialized

Thomas Petazzoni (1):
      Fix comment in include/linux/mmc/host.h


--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-12512-1223803225-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjxwVYACgkQ7b8eESbyJLhv5QCfeKkRbxTNJz+csFa4iA3LsFLc
Cm4AoMmCFSRwJVn0NcZMcH+9qrSmog6M
=c+B4
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-12512-1223803225-0001-2--
