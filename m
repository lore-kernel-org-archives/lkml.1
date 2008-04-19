Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbYDSHaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbYDSHaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 03:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYDSH35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 03:29:57 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:53172 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbYDSH34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 03:29:56 -0400
Date: Sat, 19 Apr 2008 09:28:47 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Message-ID: <20080419092847.25fc2319@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/core/core.c         |    6 +-
 drivers/mmc/core/core.h         |    4 +
 drivers/mmc/core/host.c         |   39 +-
 drivers/mmc/core/sdio_irq.c     |    4 +-
 drivers/mmc/core/sdio_ops.c     |    1 +
 drivers/mmc/host/omap.c         |  995 ++++++++++++++++++++++++++-------------
 drivers/mmc/host/sdhci.c        |  123 +++--
 drivers/mmc/host/sdhci.h        |    9 +-
 include/asm-arm/arch-omap/mmc.h |    2 +
 9 files changed, 787 insertions(+), 396 deletions(-)

Adrian Bunk (3):
      mmc: make __mmc_release_bus() static
      mmc: proper prototypes for mmc_attach_*()
      mmc: sdio_ops.c should #include "sdio_ops.h"

Carlos Eduardo Aguiar (2):
      MMC: OMAP: Remove some opcodes from host driver
      MMC: OMAP: Using setup_timer instead of init_timer

Francisco Alecrim (1):
      MMC: OMAP: Fix the BYTEBLOCK capability removal

Jarkko Lavinen (6):
      MMC: OMAP: Abort stuck commands
      MMC: OMAP: Use tasklet instead of workqueue for cover switch notification
      MMC: OMAP: Move failing command abortion to workqueue
      MMC: OMAP: Lazy clock shutdown
      MMC: OMAP: Start new commands from work queue instead of irq
      MMC: OMAP: Do not busy wait for end of command for ever

Juha Yrjola (6):
      MMC: OMAP: Introduce new multislot structure and change driver to use it
      MMC: OMAP: Add back cover switch support
      MMC: OMAP: New release dma and abort xfer functions
      MMC: OMAP: Fix timeout calculation for MMC multislot support
      MMC: OMAP: Power functions modified to MMC multislot support
      MMC: OMAP: General cleanup for MMC multislot support

Kyungmin Park (1):
      MMC: OMAP: Check the get_cover_state function pointer if not set

Pierre Ossman (5):
      mmc: set controller name early
      sdhci: remove custom controller name
      sdhci: allow led to be controlled freely
      sdhci: improve no card, no reset quirk
      sdhci: don't check block count for progress

Robert P. J. Day (1):
      mmc: use shorter, equivalent set_current_state()

Tony Lindgren (2):
      MMC: OMAP: Remove extra divisor increase
      MMC: OMAP: Remove cover switch handling to allow adding multislot support



-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
