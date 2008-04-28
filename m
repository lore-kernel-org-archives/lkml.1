Return-Path: <linux-kernel-owner+w=401wt.eu-S965311AbYD1PrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965311AbYD1PrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964999AbYD1PkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:40:17 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35048 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964997AbYD1PkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:40:15 -0400
Date: Mon, 28 Apr 2008 18:39:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, chrisw@sous-sol.org
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] drivers/xen/balloon.c: make a function static
Message-ID: <20080428153941.GR2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global balloon_set_new_target() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
58bea00a0c55ed7e3252bc5f13e8c755f4bc9fe4 diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index ab25ba6..d109639 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -368,7 +368,7 @@ static void balloon_process(struct work_struct *work)
 }
 
 /* Resets the Xen limit, sets new target, and kicks off processing. */
-void balloon_set_new_target(unsigned long target)
+static void balloon_set_new_target(unsigned long target)
 {
 	/* No need for lock. Not read-modify-write updates. */
 	balloon_stats.hard_limit   = ~0UL;

