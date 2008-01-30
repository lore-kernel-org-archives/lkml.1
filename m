Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbYA3Tp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbYA3Tp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYA3TpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:45:19 -0500
Received: from stinky.trash.net ([213.144.137.162]:59680 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYA3TpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:45:18 -0500
Message-ID: <47A0D3AA.1010504@trash.net>
Date: Wed, 30 Jan 2008 20:44:42 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RCU]: preemptible RCU: sparse annotations
Content-Type: multipart/mixed;
 boundary="------------070809080007070905080300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070809080007070905080300
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Annotate rcu_read_lock/rcu_read_unlock for sparse.



--------------070809080007070905080300
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[RCU]: preemptible RCU: sparse annotations

Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index ece8eb3..60c2a03 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -46,8 +46,8 @@
 #define rcu_bh_qsctr_inc(cpu)
 #define call_rcu_bh(head, rcu) call_rcu(head, rcu)
 
-extern void __rcu_read_lock(void);
-extern void __rcu_read_unlock(void);
+extern void __rcu_read_lock(void)	__acquires(RCU);
+extern void __rcu_read_unlock(void)	__releases(RCU);
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
 

--------------070809080007070905080300--
