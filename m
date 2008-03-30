Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYC3Wmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYC3Wmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbYC3Wkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:40:51 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57864 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908AbYC3Wku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:40:50 -0400
Date: Mon, 31 Mar 2008 01:40:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make printk_recursion_bug_msg[] static
Message-ID: <20080330224037.GI28445@cs181133002.pp.htv.fi>
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

This patch has been sent on:
- 13 Feb 2008
- 29 Jan 2008

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
 

