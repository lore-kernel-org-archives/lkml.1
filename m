Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYBQISc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYBQISc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbYBQIRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:17:37 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59587 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445AbYBQIRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:17:17 -0500
Date: Sun, 17 Feb 2008 10:16:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/timerfd.c should #include <linux/syscalls.h>
Message-ID: <20080217081651.GD3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions (in this case for sys_timerfd_*()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
dee855e7d9a90ab98e0ebbc9cb5d81ba1eff9c96 diff --git a/fs/timerfd.c b/fs/timerfd.c
index 10c80b5..5400524 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -20,6 +20,7 @@
 #include <linux/hrtimer.h>
 #include <linux/anon_inodes.h>
 #include <linux/timerfd.h>
+#include <linux/syscalls.h>
 
 struct timerfd_ctx {
 	struct hrtimer tmr;
