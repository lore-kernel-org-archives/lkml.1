Return-Path: <linux-kernel-owner+w=401wt.eu-S1763770AbYBVWWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763770AbYBVWWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935131AbYBVWMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:12:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935710AbYBVWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:12:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Z1qyqkM/Yfe//LC9zHca7Raf9+CZtsLKWlHt0j1c9JQQ/F2uUOVkoi+aiffkBllMTVDa8MmG7VXogvPggqwyQsbWXpAxcTk/xBBH1jCo4h+GNeuxy2sf/jcMDn9IRcGEw9PBppdM5Lo3gpa5ciiwgDRkBVjyLgVwtEbQZmPlQhw=
Date: Fri, 22 Feb 2008 23:11:34 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: tglx <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       hpa <hpa@zytor.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/20] x86: Coding Style fixes to
 arch/x86/oprofile/nmi_timer_int.c
Message-ID: <20080222231134.101816d6@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error and warning free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/oprofile/nmi_timer_int.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/oprofile/nmi_timer_int.c b/arch/x86/oprofile/nmi_timer_int.c
index 1418e36..e3ecb71 100644
--- a/arch/x86/oprofile/nmi_timer_int.c
+++ b/arch/x86/oprofile/nmi_timer_int.c
@@ -17,14 +17,14 @@
 #include <asm/nmi.h>
 #include <asm/apic.h>
 #include <asm/ptrace.h>
- 
+
 static int profile_timer_exceptions_notify(struct notifier_block *self,
 					   unsigned long val, void *data)
 {
 	struct die_args *args = (struct die_args *)data;
 	int ret = NOTIFY_DONE;
 
-	switch(val) {
+	switch (val) {
 	case DIE_NMI:
 		oprofile_add_sample(args->regs, 0);
 		ret = NOTIFY_STOP;
@@ -56,7 +56,7 @@ static void timer_stop(void)
 }
 
 
-int __init op_nmi_timer_init(struct oprofile_operations * ops)
+int __init op_nmi_timer_init(struct oprofile_operations *ops)
 {
 	if ((nmi_watchdog != NMI_IO_APIC) || (atomic_read(&nmi_active) <= 0))
 		return -ENODEV;
-- 
1.5.4.GIT

