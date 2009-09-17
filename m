Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZIQPZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZIQPZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZIQPZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:25:47 -0400
Received: from mail.atmel.fr ([81.80.104.162]:35282 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbZIQPZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:25:45 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       kernel@avr32linux.org
Subject: [PATCH 0/2] mmc: atmel-mci: introduce MCI2 support on at91
Date: Thu, 17 Sep 2009 18:29:25 +0200
Message-Id: <1253204967-30010-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces the support of a new revision of the MCI IP on AT91
SOCs. The use of an alternate DMA engine on those platforms introduces the need
of a generic way of handling dma slave interface.

Note: those patches goes on top of the following patch that is already in
mmotm:
        atmel-mci: Unified Atmel MCI drivers (AVR32 & AT91)

Nicolas Ferre (2):
      atmel-mci: change use of dma slave interface
      mmc: atmel-mci: New MCI2 module support in atmel-mci driver

 arch/avr32/mach-at32ap/at32ap700x.c |    6 +-
 drivers/mmc/host/atmel-mci.c        |  167 ++++++++++++++++++++++++++++-------
 include/linux/atmel-mci.h           |    3 +-
 3 files changed, 143 insertions(+), 33 deletions(-)


