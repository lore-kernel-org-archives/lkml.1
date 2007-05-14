Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbXENQz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbXENQz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbXENQzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:55:51 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:46206 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768AbXENQzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:55:50 -0400
Message-ID: <46489474.3070306@drzeus.cx>
Date: Mon, 14 May 2007 18:55:16 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] MMC updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/card/block.c   |   17 ++++-------------
 drivers/mmc/host/au1xmmc.c |   35 ++++++++++++++---------------------
 drivers/mmc/host/pxamci.c  |   18 ++++++------------
 drivers/mmc/host/sdhci.c   |    9 +++++++++
 include/linux/major.h      |    2 ++
 5 files changed, 35 insertions(+), 46 deletions(-)

Nicolas Pitre (1):
      pxamci: fix PXA27x MMC workaround for bad CRC with 136 bit response

Pierre Ossman (2):
      sdhci: handle dma boundary interrupts
      mmc: use assigned major for block device

Yoichi Yuasa (1):
      mmc: au1xmmc command types check from data flags


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
