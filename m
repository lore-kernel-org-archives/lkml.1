Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030616Ab0B0Q6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:58:36 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030594Ab0B0Q6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:58:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=c343J17hkwy2ehZQqEkVebbwHCm5970OFVo34hevKYRNjoz3QDKLp1d7PTfZsbdjED
         Z0y+DYWXrTw4j57bUbMKGvfm9or0ROUtFDKooxiszijluGdrF+x1AhnDmkc1ONdOnhDA
         MUJLcYpWDAcQOj/aL3ECE1ynDULq5NHNfsBRU=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 66/66] arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:47 +0100
Message-Id: <1267289508-31031-67-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h:10: ERROR: code indent should use tabs where possible
arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h:11: ERROR: code indent should use tabs where possible
arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h:15: ERROR: code indent should use tabs where possible
arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h:16: ERROR: code indent should use tabs where possible
arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h:17: ERROR: code indent should use tabs where possible

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h b/arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h
index 95db4be..40fa1cb 100644
--- a/arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h
+++ b/arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h
@@ -7,14 +7,14 @@
 #define __SYSDEP_X86_64_SKAS_PTRACE_H
 
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

