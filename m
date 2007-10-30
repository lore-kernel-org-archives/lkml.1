Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbXJ3JfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbXJ3JfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbXJ3JeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:34:07 -0400
Received: from nic2.axis.se ([193.13.178.10]:39923 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757735AbXJ3JeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:34:06 -0400
Date: Tue, 30 Oct 2007 10:33:53 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org
Subject: [PATCH 11/16] CRIS architecture: Correct compile errors
Message-ID: <20071030093353.GN11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add include file with prototype for mtdram_init_device from
drivers/mtd/devices/mtdram.c.
Used by axisflashmap.c to boot from ram.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 mtdram.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- /dev/null	2007-10-06 06:38:38.348072750 +0200
+++ linux-2.6.23/include/linux/mtd/mtdram.h	2002-11-13 15:57:45.000000000 +0100
@@ -0,0 +1,10 @@
+#ifndef __MTD_MTDRAM_H__
+#define __MTD_MTDRAM_H__
+
+#ifdef __KERNEL__
+#include <linux/mtd/mtd.h>
+int mtdram_init_device(struct mtd_info *mtd, void *mapped_address, 
+                       unsigned long size, char *name);
+
+#endif /* __KERNEL__ */
+#endif /* __MTD_MTDRAM_H__ */

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
