Return-Path: <linux-kernel-owner+w=401wt.eu-S1752531AbXBDUMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbXBDUMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXBDUMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:12:08 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:58502 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbXBDUMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:12:06 -0500
Message-ID: <45C63E09.5060601@drzeus.cx>
Date: Sun, 04 Feb 2007 21:11:53 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
X-Mime-Autoconverted: from 8bit to 7bit by courier 0.53
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yay! First post!

Linus, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 MAINTAINERS                  |    2 +-
 drivers/misc/tifm_7xx1.c     |  402 ++++++++++++++++++----------------
 drivers/misc/tifm_core.c     |   65 +++++--
 drivers/mmc/at91_mci.c       |    3 +
 drivers/mmc/au1xmmc.c        |   13 +-
 drivers/mmc/imxmmc.c         |    4 +-
 drivers/mmc/mmc.c            |  182 ++++++++++++----
 drivers/mmc/mmc_block.c      |   15 +-
 drivers/mmc/mmc_queue.c      |    2 +-
 drivers/mmc/mmc_sysfs.c      |    2 +-
 drivers/mmc/mmci.c           |   15 +-
 drivers/mmc/omap.c           |    6 +-
 drivers/mmc/pxamci.c         |   10 +
 drivers/mmc/sdhci.c          |   91 +++++----
 drivers/mmc/sdhci.h          |    2 -
 drivers/mmc/tifm_sd.c        |  487 +++++++++++++++++++---------------
 drivers/mmc/wbsd.c           |  102 ++++++---
 drivers/mmc/wbsd.h           |    1 -
 include/linux/mmc/card.h     |    3 +
 include/linux/mmc/host.h     |   10 +-
 include/linux/mmc/mmc.h      |    1 +
 include/linux/mmc/protocol.h |   13 +-
 include/linux/pci_ids.h      |    4 +
 include/linux/tifm.h         |   35 ++--
 24 files changed, 891 insertions(+), 579 deletions(-)

Alex Dubov (15):
      tifm_sd: alter order of the states in the command handler
      tifm_sd: use kmap_atomic instead of kmap for PIO data buffer
      tifm_sd: Switch software timeout handler from work_struct to timer
      tifm_sd: fix hardware timeout setup
      tifm_sd: restructure initialization, removal and command handling
      tifm_sd: prettify
      Remove unused return value from signal_irq callback
      Add dummy_signal_irq function to save check in ISR
      tifm_7xx1: simplify eject function
      tifm_7xx1: Merge media insert and media remove functions
      tifm_7xx1: switch from workqueue to kthread
      tifm_7xx1: recognize device 0xac8f as supported
      tifm_7xx1: prettify
      tifm_core: add suspend/resume infrastructure for tifm devices
      tifm_sd: add suspend and resume functionality

Darren Salt (1):
      mmc: Power quirk for ENE controllers

Manuel Lauss (2):
      mmc: au1xmmc: implement proper ro switch detection
      mmc: au1xmmc: return errors for unknown response types

Philip Langdale (1):
      mmc: Add support for SDHC cards

Pierre Ossman (13):
      mmc: replace host->card_busy
      mmc: let host be parent of cards
      mmc: Allow host drivers to specify a max block size
      mmc: Allow host drivers to specify max block count
      mmc: Handle wbsd's stupid command list
      mmc: Graceful fallback for fancy features
      mmc: change wbsd mailing list
      mmc: Proper unclaim in mmc_block
      mmc: handle pci_enable_device() return value in sdhci
      mmc: wbsd: replace kmap with page_address
      mmc: sdhci: replace kmap with page_address
      mmc: sdhci: fix voltage ocr
      mmc: tifm: replace kmap with page_address

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
