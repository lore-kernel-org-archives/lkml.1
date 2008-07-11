Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbYGKU0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbYGKU0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYGKU0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:26:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYGKU0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:26:41 -0400
Date: Fri, 11 Jul 2008 16:19:59 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Remove init_mm export as planned for 2.6.26
Message-ID: <20080711201959.GA1007@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 46ece3f..5e89689 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -270,18 +270,6 @@ Who:	Michael Buesch <mb@bu3sch.de>
 
 ---------------------------
 
-What:	init_mm export
-When:	2.6.26
-Why:	Not used in-tree. The current out-of-tree users used it to
-	work around problems in the CPA code which should be resolved
-	by now. One usecase was described to provide verification code
-	of the CPA operation. That's a good idea in general, but such
-	code / infrastructure should be in the kernel and not in some
-	out-of-tree driver.
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
-----------------------------
-
 What:	usedac i386 kernel parameter
 When:	2.6.27
 Why:	replaced by allowdac and no dac combination
diff --git a/arch/x86/kernel/init_task.c b/arch/x86/kernel/init_task.c
index a4f93b4..d399180 100644
--- a/arch/x86/kernel/init_task.c
+++ b/arch/x86/kernel/init_task.c
@@ -14,7 +14,6 @@ static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_UNUSED_SYMBOL(init_mm); /* will be removed in 2.6.26 */
 
 /*
  * Initial thread structure.

-- 
http://www.codemonkey.org.uk
