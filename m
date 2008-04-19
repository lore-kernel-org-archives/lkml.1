Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbYDSVv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbYDSVv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 17:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYDSVvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 17:51:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbYDSVvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 17:51:48 -0400
Date: Sat, 19 Apr 2008 14:51:38 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: zaitcev@redhat.com
Subject: Fix spelling in mmzone.h
Message-Id: <20080419145138.c03ea000.zaitcev@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I almost feel bad about patching spelling, but we have two so near...
Found while grepping for MAX_NR_ZONES.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8d8d197..741779e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -390,11 +390,11 @@ static inline int zone_is_oom_locked(const struct zone *zone)
 #ifdef CONFIG_NUMA
 
 /*
- * The NUMA zonelists are doubled becausse we need zonelists that restrict the
+ * The NUMA zonelists are doubled because we need zonelists that restrict the
  * allocations to a single node for GFP_THISNODE.
  *
  * [0 .. MAX_NR_ZONES -1] 		: Zonelists with fallback
- * [MAZ_NR_ZONES ... MAZ_ZONELISTS -1]  : No fallback (GFP_THISNODE)
+ * [MAX_NR_ZONES ... MAX_ZONELISTS -1]  : No fallback (GFP_THISNODE)
  */
 #define MAX_ZONELISTS (2 * MAX_NR_ZONES)
 
