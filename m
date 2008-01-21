Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYAUVx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYAUVx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbYAUVxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:53:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbYAUVxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:53:15 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com
Subject: [PATCH 1/4] Add missing semicolon to SWAPGS macro
Date: Mon, 21 Jan 2008 19:48:50 -0200
Message-Id: <1200952133-31581-2-git-send-email-ehabkost@redhat.com>
X-Mailer: git-send-email 1.5.4.rc3
In-Reply-To: <1200952133-31581-1-git-send-email-ehabkost@redhat.com>
References: <1200952133-31581-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial compile fix.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 include/asm-x86/paravirt.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 52bcd9d..62cecb7 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -1329,7 +1329,7 @@ static inline unsigned long __raw_local_irq_save(void)
 #else
 #define SWAPGS								\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_swapgs), CLBR_NONE,	\
-		  PV_SAVE_REGS						\
+		  PV_SAVE_REGS;						\
 		  call *pv_cpu_ops+PV_CPU_swapgs;			\
 		  PV_RESTORE_REGS					\
 		 )
-- 
1.5.3.4

