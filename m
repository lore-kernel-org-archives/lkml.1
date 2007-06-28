Return-Path: <linux-kernel-owner+w=401wt.eu-S1762540AbXF1ORY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762540AbXF1ORY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760664AbXF1ORG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:17:06 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:55325 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760211AbXF1ORF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:17:05 -0400
Date: Thu, 28 Jun 2007 23:17:49 +0900 (JST)
Message-Id: <20070628.231749.51865304.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ralf@linux-mips.org
Subject: [PATCH 2/2] serial_txx9: Cleanup includes
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do not include some header files already indluded by serial_core.h.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 407fca0..7480dc8 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -25,15 +25,11 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/console.h>
-#include <linux/sysrq.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
-#include <linux/tty.h>
-#include <linux/tty_flip.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
-#include <linux/mutex.h>
 
 #include <asm/io.h>
 
