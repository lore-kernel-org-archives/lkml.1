Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbXJ0Skz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbXJ0Skz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbXJ0Sks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:40:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48455 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXJ0Sks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:40:48 -0400
Date: Sat, 27 Oct 2007 19:40:46 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] scatterlist fallout: mmc
Message-ID: <20071027184046.GP8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 #include <scatterlist/scatterlist.h>
is an odd thing to do...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/mmc/host/au1xmmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index b2104d4..c3926eb 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -40,7 +40,7 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
-#include <scatterlist/scatterlist.h>
+#include <linux/scatterlist.h>
 
 #include <linux/mmc/host.h>
 #include <asm/io.h>
-- 
1.5.3.GIT

