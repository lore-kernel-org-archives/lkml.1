Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbYCQJkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbYCQJkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbYCQJht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:37:49 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:42606 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755336AbYCQJhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:37:32 -0400
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Paul Jackson <pj@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix indentation
Date: Mon, 17 Mar 2008 11:36:33 +0200
Message-Id: <1205746593-24820-11-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205746593-24820-10-git-send-email-caglar@pardus.org.tr>
References: <>
 <1205746593-24820-1-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-2-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-3-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-4-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-5-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-6-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-7-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-8-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-9-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-10-git-send-email-caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zlc_setup(): handle jiffies wraparound (10ed273f5016c582413dfbc468dd084957d847e1) changes tab with spaces

CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: Paul Jackson <pj@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 402a504..363c948 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1284,7 +1284,7 @@ static nodemask_t *zlc_setup(struct zonelist *zonelist, int alloc_flags)
 	if (!zlc)
 		return NULL;
 
-       if (time_after(jiffies, zlc->last_full_zap + HZ)) {
+	if (time_after(jiffies, zlc->last_full_zap + HZ)) {
 		bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
 		zlc->last_full_zap = jiffies;
 	}
-- 
1.5.4.3

