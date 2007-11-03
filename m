Return-Path: <linux-kernel-owner+w=401wt.eu-S1764858AbXKCAUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764858AbXKCAUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXKCAEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:04:52 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57901 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762391AbXKCAEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:04:50 -0400
Date: Sat, 3 Nov 2007 01:04:26 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/eventfd.c should #include <linux/syscalls.h>
Message-ID: <20071103000426.GF4594@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions (in this case sys_eventfd()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
5cf38f68bfaefff7992322fb92bdac533561e7ae 
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 2ce19c0..a9f130c 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -15,6 +15,7 @@
 #include <linux/spinlock.h>
 #include <linux/anon_inodes.h>
 #include <linux/eventfd.h>
+#include <linux/syscalls.h>
 
 struct eventfd_ctx {
 	wait_queue_head_t wqh;

