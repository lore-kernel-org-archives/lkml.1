Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbXHWFSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbXHWFSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 01:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXHWFSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 01:18:48 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:56862 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbXHWFSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 01:18:47 -0400
Date: Thu, 23 Aug 2007 07:18:42 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Message-ID: <20070823071842.6c671ab0@poseidon.drzeus.cx>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/core/bus.c   |    4 +--
 drivers/mmc/core/host.c  |    4 +--
 drivers/mmc/host/sdhci.c |   53 ++++++++++++++++++++++++++++-----------------
 drivers/mmc/host/sdhci.h |    1 +
 4 files changed, 36 insertions(+), 26 deletions(-)

David Vrabel (1):
      mmc: ignore bad max block size in sdhci

Mariusz Kozlowski (2):
      drivers/mmc/core/bus.c: kmalloc + memset conversion to kzalloc
      drivers/mmc/core/host.c: kmalloc + memset conversion to kzalloc

Pierre Ossman (3):
      sdhci: be more cautious about block count register
      sdhci: handle data interrupts during command
      sdhci: tell which spurious interrupt we got

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
