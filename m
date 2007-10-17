Return-Path: <linux-kernel-owner+w=401wt.eu-S935575AbXJQAJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935575AbXJQAJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760260AbXJQAJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:09:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41400 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457AbXJQAJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:09:10 -0400
Date: Wed, 17 Oct 2007 01:09:07 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] missing include in mmc
Message-ID: <20071017000907.GF8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

AFAICS, fallout from repacing include of blkdev.h with include of bio.h.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 71b986b..7ae18ea 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -30,6 +30,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/crc7.h>
 #include <linux/crc-itu-t.h>
+#include <linux/scatterlist.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>		/* for R1_SPI_* bit values */
