Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbXKJLZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbXKJLZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 06:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbXKJLZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 06:25:44 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:45673 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbXKJLZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 06:25:43 -0500
Date: Sat, 10 Nov 2007 12:25:40 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC update
Message-ID: <20071110122540.1ab19625@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/host/sdhci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Rolf Eike Beer (1):
      Add missing "\n" to log message

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6b80bf7..ff59d2e 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1301,7 +1301,7 @@ static int __devinit sdhci_probe_slot(struct pci_dev *pdev, int slot)
 
        if ((chip->quirks & SDHCI_QUIRK_BROKEN_DMA) &&
                (host->flags & SDHCI_USE_DMA)) {
-               DBG("Disabling DMA as it is marked broken");
+               DBG("Disabling DMA as it is marked broken\n");
                host->flags &= ~SDHCI_USE_DMA;
        }
 



-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
