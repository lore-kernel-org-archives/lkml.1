Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbYKZQCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbYKZQCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYKZQCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:02:00 -0500
Received: from ppp121-45-197-80.lns10.adl2.internode.on.net ([121.45.197.80]:47152
	"EHLO homer.shelbyville.oz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751676AbYKZQCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:02:00 -0500
Date: Thu, 27 Nov 2008 02:31:57 +1030
From: Ron <ron@debian.org>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] add missing printk loglevel
Message-ID: <20081126160157.GC28153@homer.shelbyville.oz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ron@debian.org
X-SA-Exim-Scanned: No (on homer.shelbyville.oz); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/init/main.c b/init/main.c
index 7e117a2..858d97c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -613,7 +613,8 @@ asmlinkage void __init start_kernel(void)
 	sched_clock_init();
 	profile_init();
 	if (!irqs_disabled())
-		printk("start_kernel(): bug: interrupts were enabled early\n");
+		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
+				 "enabled early\n");
 	early_boot_irqs_on();
 	local_irq_enable();
 

 Signed-off-by: Ron Lee <ron@debian.org>


