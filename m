Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554Ab0AOWsW (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 17:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483Ab0AOWsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 17:48:21 -0500
Received: from [206.15.93.42] ([206.15.93.42]:25608 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758191Ab0AOWsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 17:48:20 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] init/main.c: remove extern declarations for subsys_initcall functions
Date: Fri, 15 Jan 2010 15:48:19 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001151548.19473.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init/main.c: remove extern declarations for subsys_initcall functions

The functions mca_init, sbus_init, and tc_init are all subsys_initcall
functions and do not need to be declared as extern's.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/init/main.c b/init/main.c
index dac44a9..e768467 100644
--- a/init/main.c
+++ b/init/main.c
@@ -85,8 +85,6 @@ static int kernel_init(void *);
 
 extern void init_IRQ(void);
 extern void fork_init(unsigned long);
-extern void mca_init(void);
-extern void sbus_init(void);
 extern void prio_tree_init(void);
 extern void radix_tree_init(void);
 extern void free_initmem(void);
@@ -94,10 +92,6 @@ extern void free_initmem(void);
 static inline void mark_rodata_ro(void) { }
 #endif
 
-#ifdef CONFIG_TC
-extern void tc_init(void);
-#endif
-
 enum system_states system_state __read_mostly;
 EXPORT_SYMBOL(system_state);
 
