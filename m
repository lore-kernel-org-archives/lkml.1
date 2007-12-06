Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbXLFTBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbXLFTBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbXLFTBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:01:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbXLFTBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:01:05 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 4/19] removed unused variable
Date: Thu,  6 Dec 2007 14:16:25 -0200
Message-Id: <11969578242463-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11969578193406-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com> <11969578142514-git-send-email-gcosta@redhat.com> <11969578193406-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable is not used anywere, and is then removed

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/desc_64.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
index 1c26dbb..660cc84 100644
--- a/include/asm-x86/desc_64.h
+++ b/include/asm-x86/desc_64.h
@@ -30,11 +30,6 @@ static inline unsigned long __store_tr(void)
 
 #define store_tr(tr) (tr) = __store_tr()
 
-/*
- * This is the ldt that every process will get unless we need
- * something other than this.
- */
-extern struct desc_struct default_ldt[];
 extern struct gate_struct idt_table[];
 extern struct desc_ptr cpu_gdt_descr[];
 
-- 
1.4.4.2

