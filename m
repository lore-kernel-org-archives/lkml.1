Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYAOWXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYAOWXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbYAOWW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:22:57 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:44748 "EHLO
	mail7-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYAOWW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:22:56 -0500
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Subject: [PATCH 4/4] RT: change from raw_spinlock_t to __raw_spinlock_t
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de
Content-Type: text/plain
Date: Tue, 15 Jan 2008 14:21:46 -0800
Message-Id: <1200435706.4092.20.camel@bx740>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2008 22:22:46.0926 (UTC) FILETIME=[27E08AE0:01C857C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@am.sony.com>

Fix compile warning (which becomes compile error due to -Werror),
by changing from raw_spinlock_t to __raw_spinlock_t.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 arch/mips/kernel/gdb-stub.c |    2 	1 +	1 -	0 !
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.24-rc7/arch/mips/kernel/gdb-stub.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/mips/kernel/gdb-stub.c
+++ linux-2.6.24-rc7/arch/mips/kernel/gdb-stub.c
@@ -177,7 +177,7 @@ int kgdb_enabled;
  * spin locks for smp case
  */
 static DEFINE_SPINLOCK(kgdb_lock);
-static raw_spinlock_t kgdb_cpulock[NR_CPUS] = {
+static __raw_spinlock_t kgdb_cpulock[NR_CPUS] = {
 	[0 ... NR_CPUS-1] = __RAW_SPIN_LOCK_UNLOCKED,
 };
 



