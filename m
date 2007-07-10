Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbXGJUoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbXGJUoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758253AbXGJUoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:44:02 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:51375 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125AbXGJUoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:44:01 -0400
Date: Tue, 10 Jul 2007 22:43:57 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Message-ID: <20070710224357.2db4adbc@poseidon.drzeus.cx>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/card/Kconfig    |   18 +++
 drivers/mmc/card/block.c    |    7 +-
 drivers/mmc/card/queue.c    |  191 ++++++++++++++++++++++--
 drivers/mmc/card/queue.h    |    7 +
 drivers/mmc/core/Makefile   |    3 +-
 drivers/mmc/core/bus.c      |  253 +++++++++++++++++++++++++++++++
 drivers/mmc/core/bus.h      |   22 +++
 drivers/mmc/core/core.c     |  147 +++++++------------
 drivers/mmc/core/core.h     |    8 +-
 drivers/mmc/core/host.c     |  156 +++++++++++++++++++
 drivers/mmc/core/host.h     |   18 +++
 drivers/mmc/core/mmc.c      |   65 +++++++-
 drivers/mmc/core/sd.c       |   63 +++++++-
 drivers/mmc/core/sysfs.c    |  347 ++-----------------------------------------
 drivers/mmc/core/sysfs.h    |   19 +--
 drivers/mmc/host/at91_mci.c |  217 +++++++++++++++-------------
 drivers/mmc/host/sdhci.c    |   10 +-
 include/linux/pci_ids.h     |    1 +
 18 files changed, 980 insertions(+), 572 deletions(-)

Milko Krachounov (1):
      sdhci: add ene controller id

Nicolas Ferre (2):
      mmc: at91_mci typo
      mmc: at91_mci: fix hanging and rework to match flowcharts

Pierre Ossman (5):
      mmc: bounce requests for simple hosts
      mmc: refactor bus operations
      mmc: refactor host class handling
      mmc: move layer init and workqueue to core file
      mmc: fix silly copy-and-paste error

Rolf Eike Beer (1):
      sdhci: Fix "Unexpected interrupt" handling

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
