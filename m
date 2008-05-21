Return-Path: <linux-kernel-owner+w=401wt.eu-S935425AbYEUNaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935425AbYEUNaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129AbYEUN37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:29:59 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:4196 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764739AbYEUN36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:29:58 -0400
Date: Wed, 21 May 2008 17:29:53 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [SPI/MMC] mmc_spi.h should include linux/interrupts.h
Message-ID: <20080521132953.GA524@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since mmc_spi.h uses irqreturn_t type, it should include appropriate
header, otherwise build will break if users didn't include it (some of
them do not use interrupts).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
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
