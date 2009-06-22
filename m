Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZFVQpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZFVQpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbZFVQon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:44:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37504 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756899AbZFVQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:44:42 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/15] serial@ add OMAP wakeup-enable register
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:42:42 +0100
Message-ID: <20090622174241.25341.71854.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
References: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@deeprootsystems.com>

Add the wakeup enable register to the list of OMAP-specific UART
registers.  This is to support forthcoming OMAP PM enhancements which
use the wakeup feature of the OMAP's 8250-based UART.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
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
 

