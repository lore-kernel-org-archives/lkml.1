Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbXLLTNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbXLLTNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXLLTMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:12:52 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:35768 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbXLLTMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:12:52 -0500
Date: Wed, 12 Dec 2007 20:12:47 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Message-ID: <20071212201247.64704150@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/host/sdhci.c |   63 ++++++++++++++++++++++++++++++++++++++++++---
 drivers/mmc/host/sdhci.h |    3 +-
 include/linux/mmc/host.h |    4 ---
 include/linux/pci_ids.h  |    1 +
 4 files changed, 61 insertions(+), 10 deletions(-)

Nicolas Pitre (1):
      mmc: remove unused 'mode' from the mmc_host structure

Pierre Ossman (4):
      sdhci: describe quirks
      sdhci: don't warn about sdhci 2.0 controllers
      sdhci: use PIO when DMA can't satisfy the request
      sdhci: support JMicron JMB38x chips

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
