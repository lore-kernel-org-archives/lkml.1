Return-Path: <linux-kernel-owner+w=401wt.eu-S1760449AbZKFWa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449AbZKFWa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760441AbZKFWay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:30:54 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:37264 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760439AbZKFWaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:30:52 -0500
Message-ID: <4AF4B1BC.8020604@oracle.com>
Date: Fri, 06 Nov 2009 15:31:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched: fix kernel-doc function parameter name
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AF4A387.00EE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix variable name in sched.c kernel-doc notation.

Warning(kernel/sched.c:2008): No description found for parameter 'p'
Warning(kernel/sched.c:2008): Excess function parameter 'k' description in 'kthread_bind'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32-rc6-git3.orig/kernel/sched.c
+++ linux-2.6.32-rc6-git3/kernel/sched.c
@@ -1994,7 +1994,7 @@ static inline void check_class_changed(s
 
 /**
  * kthread_bind - bind a just-created kthread to a cpu.
- * @k: thread created by kthread_create().
+ * @p: thread created by kthread_create().
  * @cpu: cpu (might not be online, must be possible) for @k to run on.
  *
  * Description: This function is equivalent to set_cpus_allowed(),
