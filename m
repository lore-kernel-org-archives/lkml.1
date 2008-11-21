Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYKUH5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYKUH5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYKUH5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:57:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65523 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbYKUH5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:57:36 -0500
Message-ID: <492669EC.6020101@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 15:57:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] lockdep: consistent alignement for lockdep info
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just feel odd that not all lines of lockdep info are aligned.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/lockdep.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 06e1571..46a4041 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3276,10 +3276,10 @@ void __init lockdep_info(void)
 {
 	printk("Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar\n");
 
-	printk("... MAX_LOCKDEP_SUBCLASSES:    %lu\n", MAX_LOCKDEP_SUBCLASSES);
+	printk("... MAX_LOCKDEP_SUBCLASSES:  %lu\n", MAX_LOCKDEP_SUBCLASSES);
 	printk("... MAX_LOCK_DEPTH:          %lu\n", MAX_LOCK_DEPTH);
 	printk("... MAX_LOCKDEP_KEYS:        %lu\n", MAX_LOCKDEP_KEYS);
-	printk("... CLASSHASH_SIZE:           %lu\n", CLASSHASH_SIZE);
+	printk("... CLASSHASH_SIZE:          %lu\n", CLASSHASH_SIZE);
 	printk("... MAX_LOCKDEP_ENTRIES:     %lu\n", MAX_LOCKDEP_ENTRIES);
 	printk("... MAX_LOCKDEP_CHAINS:      %lu\n", MAX_LOCKDEP_CHAINS);
 	printk("... CHAINHASH_SIZE:          %lu\n", CHAINHASH_SIZE);
-- 
1.5.4.rc3
