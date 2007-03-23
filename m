Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbXCWQgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbXCWQgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXCWQgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:36:18 -0400
Received: from tapsys.com ([72.36.178.242]:37729 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbXCWQgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:36:17 -0400
Message-ID: <460401FB.2010600@madrabbit.org>
Date: Fri, 23 Mar 2007 09:36:11 -0700
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <len.brown@intel.com>
Subject: [PATCH] [TRIVIAL]  remove duplicate include
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas's patch for including <asm/apic.h> for x86 UP builds came into
Linus's tree from two different directions, both of which were merged.
This reverts the latter, yanking out the duplicate #include and comment.

Signed-off-by: Ray Lee <ray-lk@madrabbit.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <len.brown@intel.com>

---

Len, would you like to take this?

 drivers/acpi/processor_idle.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 562124e..0abf740 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -51,14 +51,6 @@
 #include <asm/apic.h>
 #endif

-/*
- * Include the apic definitions for x86 to have the APIC timer related defines
- * available also for UP (on SMP it gets magically included via linux/smp.h).
- */
-#ifdef CONFIG_X86
-#include <asm/apic.h>
-#endif
-
 #include <asm/io.h>
 #include <asm/uaccess.h>


