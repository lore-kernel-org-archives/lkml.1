Return-Path: <linux-kernel-owner+w=401wt.eu-S935678AbYBVWLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935678AbYBVWLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935311AbYBVWJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:09:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935255AbYBVWJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:09:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=SVrg+d7wdn5kkUl6x0n36wv5GwNz9vt7o+k2m7zGdCPyC7S5oMDo2MzfEm/OAdE/FMOYgxSz61jTAfrGrIl1NEB2Dd4Hg1fB9gSgRFrNQh4BH/0teme3joI7+DzQlDD4DzoOonuYWJd2BGjGTXQcZK31EwfrPvWzTV6JZpyXjxc=
Date: Fri, 22 Feb 2008 23:09:50 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/20] x86: Coding Style fixes to arch/x86/oprofile/init.c
Message-ID: <20080222230950.212de97b@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/oprofile/init.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/oprofile/init.c b/arch/x86/oprofile/init.c
index 5341d48..cdfe4c5 100644
--- a/arch/x86/oprofile/init.c
+++ b/arch/x86/oprofile/init.c
@@ -10,18 +10,19 @@
 #include <linux/oprofile.h>
 #include <linux/init.h>
 #include <linux/errno.h>
- 
-/* We support CPUs that have performance counters like the Pentium Pro
+
+/*
+ * We support CPUs that have performance counters like the Pentium Pro
  * with the NMI mode driver.
  */
- 
-extern int op_nmi_init(struct oprofile_operations * ops);
-extern int op_nmi_timer_init(struct oprofile_operations * ops);
+
+extern int op_nmi_init(struct oprofile_operations *ops);
+extern int op_nmi_timer_init(struct oprofile_operations *ops);
 extern void op_nmi_exit(void);
 extern void x86_backtrace(struct pt_regs * const regs, unsigned int depth);
 
 
-int __init oprofile_arch_init(struct oprofile_operations * ops)
+int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	int ret;
 
-- 
1.5.4.GIT

