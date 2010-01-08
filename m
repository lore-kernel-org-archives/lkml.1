Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520Ab0AHObh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0AHObh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 09:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086Ab0AHObg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 09:31:36 -0500
Received: from mail.atmel.fr ([81.80.104.162]:65194 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab0AHObf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 09:31:35 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: jic23@cam.ac.uk, linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] MMC: Atmel host kconfig cleanup for everyone else
Date: Fri,  8 Jan 2010 16:40:44 +0100
Message-Id: <1262965244-18894-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents those without an Atmel chip having a line in kernel configuration
which says "Atmel SD/MMC Driver" without any option.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index ce1d288..c268062 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -193,6 +193,7 @@ config MMC_AU1X
 
 choice
 	prompt "Atmel SD/MMC Driver"
+	depends on AVR32 || ARCH_AT91
 	default MMC_ATMELMCI if AVR32
 	help
 	  Choose which driver to use for the Atmel MCI Silicon
-- 
1.5.6.5

