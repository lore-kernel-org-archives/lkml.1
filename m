Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbYH2MOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYH2MOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 08:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbYH2MON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 08:14:13 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:14996 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbYH2MOM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 08:14:12 -0400
Message-Id: <48B80480.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 13:15:28 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: eliminate dead code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 include/asm-x86/mmu.h |    5 -----
 1 file changed, 5 deletions(-)

--- linux-2.6.27-rc5/include/asm-x86/mmu.h	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.27-rc5-x86_64-mmu-context/include/asm-x86/mmu.h	2008-08-22 15:24:33.000000000 +0200
@@ -7,14 +7,9 @@
 /*
  * The x86 doesn't have a mmu context, but
  * we put the segment information here.
- *
- * cpu_vm_mask is used to optimize ldt flushing.
  */
 typedef struct {
 	void *ldt;
-#ifdef CONFIG_X86_64
-	rwlock_t ldtlock;
-#endif
 	int size;
 	struct mutex lock;
 	void *vdso;



