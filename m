Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXGZNQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXGZNQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 09:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758587AbXGZNPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 09:15:52 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:46019 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758034AbXGZNPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 09:15:52 -0400
Date: Thu, 26 Jul 2007 15:15:42 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Message-ID: <20070726151542.08d77489@poseidon.drzeus.cx>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/card/queue.c    |    2 +-
 drivers/mmc/core/bus.c      |   23 +++++++
 drivers/mmc/core/core.c     |  144 ++++++++++++++++++++++++++++++-------------
 drivers/mmc/core/core.h     |   22 -------
 drivers/mmc/core/host.c     |    7 ++-
 drivers/mmc/core/mmc.c      |   26 +++++---
 drivers/mmc/core/mmc_ops.c  |    2 +-
 drivers/mmc/core/mmc_ops.h  |    2 +-
 drivers/mmc/core/sd.c       |   36 ++++++-----
 drivers/mmc/core/sd_ops.c   |   62 +++++++++---------
 drivers/mmc/core/sd_ops.h   |    3 +-
 drivers/mmc/host/at91_mci.c |    2 +-
 drivers/mmc/host/au1xmmc.c  |    2 +-
 drivers/mmc/host/imxmmc.c   |    2 +-
 drivers/mmc/host/mmci.c     |    2 +-
 drivers/mmc/host/mmci.h     |    2 +-
 drivers/mmc/host/omap.c     |    2 +-
 drivers/mmc/host/pxamci.c   |    2 +-
 drivers/mmc/host/sdhci.c    |   63 +++++++++++--------
 drivers/mmc/host/sdhci.h    |    2 +-
 drivers/mmc/host/wbsd.c     |   15 +----
 drivers/mmc/host/wbsd.h     |    2 +-
 include/linux/mmc/core.h    |    2 +-
 include/linux/pci_ids.h     |    2 +
 24 files changed, 253 insertions(+), 176 deletions(-)

Adrian Bunk (1):
      drivers/mmc/core/: make 3 functions static

Leandro Dorileo (1):
      sdhci: add support to ENE-CB714

Pierre Ossman (9):
      mmc: check error bits before command completion
      mmc: update header file paths
      mmc: update kerneldoc
      mmc: add a might_sleep() to mmc_claim_host()
      mmc: Don't hold lock when releasing an added card
      mmc: be more verbose about card insertions/removal
      mmc: proper debugging output in core
      mmc: remove redundant debug information from sdhci and wbsd
      mmc: add missing printk levels

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
