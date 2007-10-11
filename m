Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbXJKN0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbXJKN0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXJKN0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:26:13 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:54716 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbXJKN0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:26:12 -0400
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: chrisw@sous-sol.org
Subject: [TOMOYO #4 01/13] Allow use of namespace_sem from LSM module.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710112225.HGI87594.FVLFOFMJtHSOQO@I-love.SAKURA.ne.jp>
In-Reply-To: <200710112225.HGI87594.FVLFOFMJtHSOQO@I-love.SAKURA.ne.jp>
Message-Id: <200710112226.HDC60209.FQOFLMFSJtOHVO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 11 Oct 2007 22:26:10 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux uses pathnames for auditing and controlling file access.
Therefore, namespace_sem is needed.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/fs/namespace.c	2007-10-11 15:52:19.000000000 +0900
+++ linux-2.6/fs/namespace.c	2007-10-11 15:53:12.000000000 +0900
@@ -38,7 +38,7 @@ static int event;
 static struct list_head *mount_hashtable __read_mostly;
 static int hash_mask __read_mostly, hash_bits __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
-static struct rw_semaphore namespace_sem;
+struct rw_semaphore namespace_sem;
 
 /* /sys/fs */
 decl_subsys(fs, NULL, NULL);

