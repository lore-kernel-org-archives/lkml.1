Return-Path: <linux-kernel-owner+w=401wt.eu-S1765582AbZFLRli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765582AbZFLRli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765099AbZFLRl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:41:27 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:63331 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761688AbZFLRl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:41:26 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH resend v3] UART regs: add OMAP wakeup-enable register
Date: Fri, 12 Jun 2009 10:41:26 -0700
Message-Id: <1244828486-13666-1-git-send-email-khilman@ti.deeprootsystems.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@deeprootsystems.com>

Add the wakeup enable register to the list of OMAP-specific UART
registers.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
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

