Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbYDUWup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbYDUWup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 18:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYDUWuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 18:50:37 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52354 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbYDUWug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:50:36 -0400
Date: Tue, 22 Apr 2008 01:50:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make debug_pagealloc_proc_init() static
Message-ID: <20080421225005.GE2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global debug_pagealloc_proc_init() 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
1b967b3304fc459c0c17f756a3cd172325603791 diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index f7823a1..c29ebd0 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -993,7 +993,7 @@ static const struct file_operations dpa_fops = {
 	.release	= single_release,
 };
 
-int __init debug_pagealloc_proc_init(void)
+static int __init debug_pagealloc_proc_init(void)
 {
 	struct dentry *de;
 

