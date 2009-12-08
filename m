Return-Path: <linux-kernel-owner+w=401wt.eu-S966226AbZLHVRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966226AbZLHVRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966263AbZLHVQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:16:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49590 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966304AbZLHVQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:39 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [29/31] HWPOISON: Undefine short-hand macros after use to avoid namespace conflict
Message-Id: <20091208211645.95423B151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/memory-failure.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux/mm/memory-failure.c
===================================================================
--- linux.orig/mm/memory-failure.c
+++ linux/mm/memory-failure.c
@@ -747,6 +747,19 @@ static struct page_state {
 	{ 0,		0,		"unknown page state",	me_unknown },
 };
 
+#undef dirty
+#undef sc
+#undef unevict
+#undef mlock
+#undef writeback
+#undef lru
+#undef swapbacked
+#undef head
+#undef tail
+#undef compound
+#undef slab
+#undef reserved
+
 static void action_result(unsigned long pfn, char *msg, int result)
 {
 	struct page *page = pfn_to_page(pfn);
