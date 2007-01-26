Return-Path: <linux-kernel-owner+w=401wt.eu-S1161186AbXAZTFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161186AbXAZTFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161191AbXAZTFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:05:55 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37149 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161186AbXAZTFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:05:54 -0500
Date: Fri, 26 Jan 2007 20:06:01 +0100
From: Adrian Bunk <bunk@stusta.de>
To: trond.myklebust@fys.uio.no, neilb@cse.unsw.edu.au
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/lockd/clntlock.c: add missing newlines to dprintk's
Message-ID: <20070126190601.GQ17836@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing newlines to dprintk's.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/lockd/clntlock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20-rc4-mm1/fs/lockd/clntlock.c.old	2007-01-26 19:31:43.000000000 +0100
+++ linux-2.6.20-rc4-mm1/fs/lockd/clntlock.c	2007-01-26 19:32:01.000000000 +0100
@@ -176,7 +176,7 @@
 	lock_kernel();
 	lockd_up(0); /* note: this cannot fail as lockd is already running */
 
-	dprintk("lockd: reclaiming locks for host %s", host->h_name);
+	dprintk("lockd: reclaiming locks for host %s\n", host->h_name);
 
 restart:
 	nsmstate = host->h_nsmstate;
@@ -206,7 +206,7 @@
 
 	host->h_reclaiming = 0;
 	up_write(&host->h_rwsem);
-	dprintk("NLM: done reclaiming locks for host %s", host->h_name);
+	dprintk("NLM: done reclaiming locks for host %s\n", host->h_name);
 
 	/* Now, wake up all processes that sleep on a blocked lock */
 	list_for_each_entry(block, &nlm_blocked, b_list) {

