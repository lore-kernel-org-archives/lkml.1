Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbXEWCBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbXEWCBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 22:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbXEWCBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 22:01:30 -0400
Received: from rwcrmhc13.comcast.net ([204.127.192.83]:33122 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbXEWCB3 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 22:01:29 -0400
Subject: [PATCH 2.6.21-rt6]
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: LKML <Linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: The Big Corporation
Date: Tue, 22 May 2007 19:01:27 -0700
Message-Id: <1179885687.25500.92.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Restore the declaration of rcu_batches_completed_bh

It is needed to compile with Classic RCU 

signed-off-by: Sven-Thorsten Dietrich <sven@thebigcorporation.com>


Index: linux-2.6.21-rt-patched/include/linux/rcupdate.h
===================================================================
--- linux-2.6.21-rt-patched.orig/include/linux/rcupdate.h
+++ linux-2.6.21-rt-patched/include/linux/rcupdate.h
@@ -227,6 +227,7 @@ extern void rcu_barrier(void);
 extern void rcu_init(void);
 extern void rcu_advance_callbacks(int cpu, int user);
 extern void rcu_check_callbacks(int cpu, int user);
+extern long rcu_batches_completed_bh(void);
 
 #endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPDATE_H */


