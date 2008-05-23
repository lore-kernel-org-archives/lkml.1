Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbYEWO1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbYEWO1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbYEWOZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:25:53 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:62303 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757274AbYEWOZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:25:52 -0400
Message-Id: <20080523142539.207795942@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 May 2008 07:25:39 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] security: keys: remove unused key_alloc_sem
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This semaphore doesn't appear to be used, so removing it.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 security/keys/internal.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.25/security/keys/internal.h
===================================================================
--- linux-2.6.25.orig/security/keys/internal.h
+++ linux-2.6.25/security/keys/internal.h
@@ -78,7 +78,6 @@ extern unsigned key_quota_maxbytes;
 
 extern struct rb_root key_serial_tree;
 extern spinlock_t key_serial_lock;
-extern struct semaphore key_alloc_sem;
 extern struct mutex key_construction_mutex;
 extern wait_queue_head_t request_key_conswq;
 
-- 

-- 
