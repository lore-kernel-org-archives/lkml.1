Return-Path: <linux-kernel-owner+w=401wt.eu-S1763399AbXLMQ5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763399AbXLMQ5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbXLMQ5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:57:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbXLMQ5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:57:34 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 04/19] removed unused variable
Date: Thu, 13 Dec 2007 11:57:52 -0200
Message-Id: <11975543173017-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1197554307167-git-send-email-gcosta@redhat.com>
References: <11975113122984-git-send-email-gcosta@redhat.com> <1197554287294-git-send-email-gcosta@redhat.com> <11975542952896-git-send-email-gcosta@redhat.com> <11975543001070-git-send-email-gcosta@redhat.com> <1197554307167-git-send-email-gcosta@redhat.com>
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
1.5.0.6

