Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbYBAJyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbYBAJyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbYBAJxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:20 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:29292 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbYBAJxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:18 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011053.107168490@suse.de>
In-Reply-To: <200802011053.107168490@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/12] GBPAGES: Add PUD_PAGE_SIZE
Message-Id: <20080201095316.383E81B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:53:16 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:46:58.0764 (UTC) FILETIME=[6349E8C0:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/page_64.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/include/asm-x86/page_64.h
===================================================================
--- linux.orig/include/asm-x86/page_64.h
+++ linux/include/asm-x86/page_64.h
@@ -23,6 +23,9 @@
 #define MCE_STACK 5
 #define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
 
+#define PUD_PAGE_SIZE (_AC(1, UL) << PUD_SHIFT)
+#define PUD_PAGE_MASK (~(PUD_PAGE_SIZE-1))
+
 #define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
 
 #define __PHYSICAL_START	CONFIG_PHYSICAL_START
