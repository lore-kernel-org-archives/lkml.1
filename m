Return-Path: <linux-kernel-owner+w=401wt.eu-S935720AbXGZQmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935720AbXGZQmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934745AbXGZQgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:36:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43428 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934734AbXGZQgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:36:31 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ax88796 (address space): cast to unsigned long, not long
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Message-Id: <E1IE6KD-0005Tp-S8@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:36:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/ax88796.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ax88796.c b/drivers/net/ax88796.c
index 1d88236..e43e804 100644
--- a/drivers/net/ax88796.c
+++ b/drivers/net/ax88796.c
@@ -819,7 +819,7 @@ static int ax_probe(struct platform_device *pdev)
 	}
 
 	ei_status.mem = ioremap(res->start, size);
-	dev->base_addr = (long)ei_status.mem;
+	dev->base_addr = (unsigned long)ei_status.mem;
 
 	if (ei_status.mem == NULL) {
 		dev_err(&pdev->dev, "Cannot ioremap area (%08zx,%08zx)\n",
-- 
1.5.3.GIT

