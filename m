Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbZFXVjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbZFXVjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZFXVjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:39:11 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:36713 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZFXVjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:39:10 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: ext-adrian.hunter@nokia.com, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 1/2] Use 64-bit format when printing a debug message.
Date: Wed, 24 Jun 2009 18:39:09 -0300
Message-Id: <1245879549-10286-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit 69423d99fc182a81f3c5db3eb5c140acc6fc64be has changed some
structure values to 64-bit and has not updated this debug message, since
it's not built by default.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/mtd/cmdlinepart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 5011fa7..1479da6 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -194,7 +194,7 @@ static struct mtd_partition * newpart(char *s,
 	parts[this_part].name = extra_mem;
 	extra_mem += name_len + 1;
 
-	dbg(("partition %d: name <%s>, offset %x, size %x, mask flags %x\n",
+	dbg(("partition %d: name <%s>, offset %llx, size %llx, mask flags %x\n",
 	     this_part,
 	     parts[this_part].name,
 	     parts[this_part].offset,
-- 
1.6.3

