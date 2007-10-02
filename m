Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbXJBNf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbXJBNf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbXJBNfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:35:46 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:46198 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbXJBNfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:35:45 -0400
Message-ID: <4701F336.1060209@nttdata.co.jp>
Date: Tue, 02 Oct 2007 16:28:54 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.6) Gecko/20070728 Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
CC: chrisw@sous-sol.org
Subject: [TOMOYO 01/15](repost) Allow use of namespace_sem from LSM module.
References: <4701F285.5000206@nttdata.co.jp>
In-Reply-To: <4701F285.5000206@nttdata.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2007 07:28:55.0978 (UTC) FILETIME=[E3F790A0:01C804C5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux uses pathnames for auditing and controlling file access.
Therefore, namespace_sem is needed.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/namespace.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/fs/namespace.c	2007-10-02 11:11:53.000000000 +0900
+++ linux-2.6/fs/namespace.c	2007-10-02 11:26:21.000000000 +0900
@@ -38,7 +38,7 @@ static int event;
 static struct list_head *mount_hashtable __read_mostly;
 static int hash_mask __read_mostly, hash_bits __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
-static struct rw_semaphore namespace_sem;
+struct rw_semaphore namespace_sem;
 
 /* /sys/fs */
 decl_subsys(fs, NULL, NULL);

