Return-Path: <linux-kernel-owner+w=401wt.eu-S965522AbXDCQ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965522AbXDCQ6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965513AbXDCQ6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:58:39 -0400
Received: from tapsys.com ([72.36.178.242]:47105 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965418AbXDCQ6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:58:38 -0400
Message-ID: <461287A6.9080409@madrabbit.org>
Date: Tue, 03 Apr 2007 09:58:14 -0700
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: [PATCH] [TRIVIAL]  remove duplicate include
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas's patch for including <asm/apic.h> for x86 UP builds came into
Linus's tree from two different directions, both of which were merged.
This reverts the latter, yanking out the duplicate #include and comment.

Signed-off-by: Ray Lee <ray-lk@madrabbit.org>
Cc: Len Brown <lenb@kernel.org>

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



