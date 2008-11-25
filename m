Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYKYA5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYKYA5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbYKYAzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:23 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57376 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbYKYAzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:15 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 12/20] [MTD] Make init_msp_flash function static
Date: Tue, 25 Nov 2008 02:55:03 +0200
Message-Id: <1227574511-23879-13-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function init_msp_flash, which is not used outside of
drivers/mtd/maps/pmcmsp-flash.c, can become static. This
patch adds the needed keyword.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/pmcmsp-flash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/pmcmsp-flash.c b/drivers/mtd/maps/pmcmsp-flash.c
index f43ba28..4768bd5 100644
--- a/drivers/mtd/maps/pmcmsp-flash.c
+++ b/drivers/mtd/maps/pmcmsp-flash.c
@@ -48,7 +48,7 @@ static int fcnt;
 
 #define DEBUG_MARKER printk(KERN_NOTICE "%s[%d]\n", __func__, __LINE__)
 
-int __init init_msp_flash(void)
+static int __init init_msp_flash(void)
 {
 	int i, j;
 	int offset, coff;
-- 
1.5.3

