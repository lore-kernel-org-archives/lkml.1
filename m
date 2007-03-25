Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbXCYO7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbXCYO7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 10:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbXCYO62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 10:58:28 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34041 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbXCYO6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 10:58:12 -0400
Date: Sun, 25 Mar 2007 16:58:16 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Moore <Eric.Moore@lsi.com>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] make mptspi_target_destroy() static
Message-ID: <20070325145816.GJ16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global mptspi_target_destroy() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Eric Moore <Eric.Moore@lsi.com>

---

This patch was already sent on:
- 20 Feb 2007

--- linux-2.6.20-mm1/drivers/message/fusion/mptspi.c.old	2007-02-18 01:01:26.000000000 +0100
+++ linux-2.6.20-mm1/drivers/message/fusion/mptspi.c	2007-02-18 01:02:04.000000000 +0100
@@ -446,7 +446,7 @@
 	return 0;
 }
 
-void
+static void
 mptspi_target_destroy(struct scsi_target *starget)
 {
 	if (starget->hostdata)

