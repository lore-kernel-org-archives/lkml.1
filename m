Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYKYBBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYKYBBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbYKYAzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:32 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57373 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147AbYKYAzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:15 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 07/20] [MTD] Make h720x_mtd_init function static
Date: Tue, 25 Nov 2008 02:54:58 +0200
Message-Id: <1227574511-23879-8-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function h720x_mtd_init is not used outside of the file
drivers/mtd/maps/h720x-flash.c and can therefore become static.
This patch adds the necessary keyword.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/h720x-flash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/h720x-flash.c b/drivers/mtd/maps/h720x-flash.c
index 3b959fa..72c724f 100644
--- a/drivers/mtd/maps/h720x-flash.c
+++ b/drivers/mtd/maps/h720x-flash.c
@@ -65,7 +65,7 @@ static const char *probes[] = { "cmdlinepart", NULL };
 /*
  * Initialize FLASH support
  */
-int __init h720x_mtd_init(void)
+static int __init h720x_mtd_init(void)
 {
 
 	char	*part_type = NULL;
-- 
1.5.3

