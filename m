Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYKYA5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYKYA5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbYKYAzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:21 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57368 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbYKYAzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:15 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 06/20] [MTD] Make init_fortunet function static
Date: Tue, 25 Nov 2008 02:54:57 +0200
Message-Id: <1227574511-23879-7-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol init_fortunet is needlessly defined global in
drivers/mtd/maps/fortunet.c. Make it static and clean up
the kernel global namespace.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/fortunet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/fortunet.c b/drivers/mtd/maps/fortunet.c
index a8e3fde..1e43124 100644
--- a/drivers/mtd/maps/fortunet.c
+++ b/drivers/mtd/maps/fortunet.c
@@ -181,7 +181,7 @@ __setup("MTD_Partition=", MTD_New_Partition);
 /* Backwards-spelling-compatibility */
 __setup("MTD_Partion=", MTD_New_Partition);
 
-int __init init_fortunet(void)
+static int __init init_fortunet(void)
 {
 	int	ix,iy;
 	for(iy=ix=0;ix<MAX_NUM_REGIONS;ix++)
-- 
1.5.3

