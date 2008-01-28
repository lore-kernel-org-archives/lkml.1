Return-Path: <linux-kernel-owner+w=401wt.eu-S1763123AbYA1WRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763123AbYA1WRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760138AbYA1WLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:11:22 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48019 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760106AbYA1WLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:11:20 -0500
Date: Tue, 29 Jan 2008 00:11:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make printk_recursion_bug_msg[] static
Message-ID: <20080128221146.GB8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk_recursion_bug_msg[] can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
77c15a78b65e014c00b533e4c5eeee98a71853fc 
diff --git a/kernel/printk.c b/kernel/printk.c
index 3b7c968..f8e4229 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -623,7 +623,7 @@ asmlinkage int printk(const char *fmt, ...)
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int printk_cpu = UINT_MAX;
 
-const char printk_recursion_bug_msg [] =
+static const char printk_recursion_bug_msg[] =
 			KERN_CRIT "BUG: recent printk recursion!\n";
 static int printk_recursion_bug;
 

