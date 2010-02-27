Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030551Ab0B0Q5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:57:52 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030511Ab0B0Q5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:57:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=fMolJaRlHlepHyXPB7o6SW7m0o6/McKhZvCygsDJQdw4ZeWjJCAd87VBRGqgw5yXIA
         EvQhGYkQOI2XfWCxwzrGs8sAKynNcmQkvgfgpz64l5Rte2QEXOXYQnZoeAka5FZ7hpba
         yuvFXz8KwRsAgEANL3xQY49+CjbuZAUJh6bmc=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 58/66] arch/um/os-Linux/sys-x86_64/prctl.c: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:39 +0100
Message-Id: <1267289508-31031-59-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/os-Linux/sys-x86_64/prctl.c:11: ERROR: code indent should use tabs where possible

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/os-Linux/sys-x86_64/prctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/sys-x86_64/prctl.c b/arch/um/os-Linux/sys-x86_64/prctl.c
index 9d34edd..79c278a 100644
--- a/arch/um/os-Linux/sys-x86_64/prctl.c
+++ b/arch/um/os-Linux/sys-x86_64/prctl.c
@@ -8,5 +8,5 @@
 
 int os_arch_prctl(int pid, int code, unsigned long *addr)
 {
-        return ptrace(PTRACE_ARCH_PRCTL, pid, (unsigned long) addr, code);
+	return ptrace(PTRACE_ARCH_PRCTL, pid, (unsigned long) addr, code);
 }
-- 
1.7.0.90.g251a4

