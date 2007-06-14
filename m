Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbXFNJpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbXFNJpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXFNJox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:44:53 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:41638 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXFNJow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:44:52 -0400
Message-ID: <4670EEF2.9010406@nttdata.co.jp>
Date: Thu, 14 Jun 2007 16:32:02 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [TOMOYO 1/9] Allow use of namespace_sem from LSM module.
References: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
In-Reply-To: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2007 07:32:02.0356 (UTC) FILETIME=[199E1740:01C7AE56]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux uses pathnames for auditing and controlling file access.
Therefore, namespace_sem is needed.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

---------------
 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -ubBpErN linux-2.6.21.5/fs/namespace.c linux-2.6.21.5-tomoyo/fs/namespace.c
--- linux-2.6.21.5/fs/namespace.c	2007-06-12 03:37:06.000000000 +0900
+++ linux-2.6.21.5-tomoyo/fs/namespace.c	2007-06-14 15:02:38.000000000 +0900
@@ -37,7 +37,7 @@ static int event;
 static struct list_head *mount_hashtable __read_mostly;
 static int hash_mask __read_mostly, hash_bits __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
-static struct rw_semaphore namespace_sem;
+struct rw_semaphore namespace_sem;
 
 /* /sys/fs */
 decl_subsys(fs, NULL, NULL);
---------------

