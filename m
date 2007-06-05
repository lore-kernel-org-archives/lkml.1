Return-Path: <linux-kernel-owner+w=401wt.eu-S933751AbXFEVwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbXFEVwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933384AbXFEVvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:51:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54685 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933729AbXFEVvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:51:02 -0400
Date: Tue, 5 Jun 2007 23:51:06 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] fs/proc/base.c: make a struct static
Message-ID: <20070605215106.GL5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct proc_pid_sched_operations 
static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc3-mm1/fs/proc/base.c.old	2007-06-05 22:01:08.000000000 +0200
+++ linux-2.6.22-rc3-mm1/fs/proc/base.c	2007-06-05 22:41:57.000000000 +0200
@@ -952,7 +952,7 @@
 	return ret;
 }
 
-const struct file_operations proc_pid_sched_operations = {
+static const struct file_operations proc_pid_sched_operations = {
 	.open		= sched_open,
 	.read		= seq_read,
 	.write		= sched_write,
