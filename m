Return-Path: <linux-kernel-owner+w=401wt.eu-S1762752AbXJQUoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752AbXJQUoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758850AbXJQUo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:44:26 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:38426 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518AbXJQUo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:44:26 -0400
Date: Wed, 17 Oct 2007 22:44:22 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dan Williams <dcbw@redhat.com>
Subject: [GIT PULL] MMC updates
Message-ID: <20071017224422.78c082ec@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

The set includes one rare memory leak and some cleanup. It also includes a new frontend for the libertas driver. It is going via my tree because of interdependencies between my tree and the libertas/netdev tree.

 drivers/mmc/core/mmc.c                  |    3 +-
 drivers/mmc/host/at91_mci.c             |    4 +-
 drivers/net/wireless/Kconfig            |    6 +
 drivers/net/wireless/libertas/Makefile  |    2 +
 drivers/net/wireless/libertas/defs.h    |    2 +
 drivers/net/wireless/libertas/if_sdio.c | 1072 +++++++++++++++++++++++++++++++
 drivers/net/wireless/libertas/if_sdio.h |   45 ++
 include/linux/mmc/sdio_ids.h            |    6 +
 8 files changed, 1136 insertions(+), 4 deletions(-)

Andrew Victor (1):
      mmc: at91_mci: cleanup: use MCI_ERRORS

Florin Malita (1):
      mmc: possible leak in mmc_read_ext_csd

Pierre Ossman (1):
      net: libertas sdio driver

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
