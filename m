Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZEURKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZEURKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 13:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZEURKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 13:10:00 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:36459 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZEURJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 13:09:59 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH] UART regs: add OMAP wakeup-enable register
Date: Thu, 21 May 2009 10:09:58 -0700
Message-Id: <1242925798-29672-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the wakeup enable register to the list of OMAP-specific UART
registers.  This is to support forthcoming OMAP PM enhancements which
use the wakeup feature of the OMAP's 8250-based UART.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
The MAINTAINERS file lists the 8250 driver as orphaned, and posts to
linux-serial go unanswered.  How should this go upstream?

 include/linux/serial_reg.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
index 96c0d93..850db2e 100644
--- a/include/linux/serial_reg.h
+++ b/include/linux/serial_reg.h
@@ -323,6 +323,7 @@
 #define UART_OMAP_MVER		0x14	/* Module version register */
 #define UART_OMAP_SYSC		0x15	/* System configuration register */
 #define UART_OMAP_SYSS		0x16	/* System status register */
+#define UART_OMAP_WER		0x17	/* Wake-up enable register */
 
 #endif /* _LINUX_SERIAL_REG_H */
 
-- 
1.6.2.2

