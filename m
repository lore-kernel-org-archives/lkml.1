Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030604Ab0B0Q6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:58:30 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030594Ab0B0Q61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:58:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=c2/XV53NnfK0USzAu96CyURgXgiRNTjA23+zEPnxXpxFnKVMvz1z8O6OoxbaOX34h5
         3qU8PZb6SJxMjEdNIzxL/LVSQBVX+4a6IA06bqhu1gIHSa6lPNQFU1rMZF1+J8vqEz82
         mfCSe8SuC+PEsFWwAv9ljANSodC3QXWLTpGi0=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 65/66] arch/um/sys-ia64/sysdep/skas_ptrace.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:46 +0100
Message-Id: <1267289508-31031-66-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/sys-ia64/sysdep/skas_ptrace.h:10: ERROR: code indent should use tabs where possible
arch/um/sys-ia64/sysdep/skas_ptrace.h:11: ERROR: code indent should use tabs where possible
arch/um/sys-ia64/sysdep/skas_ptrace.h:15: ERROR: code indent should use tabs where possible
arch/um/sys-ia64/sysdep/skas_ptrace.h:16: ERROR: code indent should use tabs where possible
arch/um/sys-ia64/sysdep/skas_ptrace.h:17: ERROR: code indent should use tabs where possible

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/sys-ia64/sysdep/skas_ptrace.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/um/sys-ia64/sysdep/skas_ptrace.h b/arch/um/sys-ia64/sysdep/skas_ptrace.h
index 25a38e7..b49be9e 100644
--- a/arch/um/sys-ia64/sysdep/skas_ptrace.h
+++ b/arch/um/sys-ia64/sysdep/skas_ptrace.h
@@ -7,14 +7,14 @@
 #define __SYSDEP_IA64_SKAS_PTRACE_H
 
 struct ptrace_faultinfo {
-        int is_write;
-        unsigned long addr;
+	int is_write;
+	unsigned long addr;
 };
 
 struct ptrace_ldt {
-        int func;
-        void *ptr;
-        unsigned long bytecount;
+	int func;
+	void *ptr;
+	unsigned long bytecount;
 };
 
 #define PTRACE_LDT 54
-- 
1.7.0.90.g251a4

