Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbYFAJtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbYFAJtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 05:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYFAJtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 05:49:42 -0400
Received: from server.drzeus.cx ([85.8.24.28]:53507 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752489AbYFAJtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 05:49:41 -0400
Date: Sun, 1 Jun 2008 11:49:32 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH] mmc_spi: mmc_spi.h should include linux/interrupts.h
Message-ID: <20080601114932.44694524@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <avorontsov@ru.mvista.com>

Since mmc_spi.h uses irqreturn_t type, it should include appropriate
header, otherwise build will break if users didn't include it (some of
them do not use interrupts).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
---
 include/linux/spi/mmc_spi.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/spi/mmc_spi.h b/include/linux/spi/mmc_spi.h
index e9bbe3e..d5ca78b 100644
--- a/include/linux/spi/mmc_spi.h
+++ b/include/linux/spi/mmc_spi.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_SPI_MMC_SPI_H
 #define __LINUX_SPI_MMC_SPI_H
 
+#include <linux/interrupt.h>
+
 struct device;
 struct mmc_host;
 
-- 
1.5.5.1


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
