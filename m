Return-Path: <linux-kernel-owner+w=401wt.eu-S1765645AbXGSNzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765645AbXGSNzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936942AbXGSNsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:45 -0400
Received: from mail.suse.de ([195.135.220.2]:54528 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935021AbXGSNso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:44 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: da-x@monatomic.org, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [14/48] x86_64: lower printk severity
Message-Id: <20070719134843.7635114E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dan Aloni <da-x@monatomic.org>

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/process.c
===================================================================
--- linux.orig/arch/x86_64/kernel/process.c
+++ linux/arch/x86_64/kernel/process.c
@@ -279,7 +279,7 @@ void __cpuinit select_idle_routine(const
 		 */
 		if (!pm_idle) {
 			if (!printed) {
-				printk("using mwait in idle threads.\n");
+				printk(KERN_INFO "using mwait in idle threads.\n");
 				printed = 1;
 			}
 			pm_idle = mwait_idle;
