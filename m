Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030569Ab0B0Q6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:58:00 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030535Ab0B0Q55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:57:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=b1LV9c5Bv2M7868ilr0zMqaMBhy2YqUjLkdGSgBwVsY2h1j/09niXI2prZAEwgqgAF
         r7105pXgrr4AhWbH7jOZzp6JmxmP21vA3P6gjv7XdiAUJaJAhr6Ij+2JotxHoDzQ32FF
         e5CNKY02vYFGTLl7iH8m3q8nV2A9DYxxEOXBc=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 60/66] arch/um/sys-i386/shared/sysdep/vm-flags.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:41 +0100
Message-Id: <1267289508-31031-61-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/sys-i386/shared/sysdep/vm-flags.h:11: ERROR: space prohibited before that close parenthesis ')'

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/sys-i386/shared/sysdep/vm-flags.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/sys-i386/shared/sysdep/vm-flags.h b/arch/um/sys-i386/shared/sysdep/vm-flags.h
index e0d24c5..881afd7 100644
--- a/arch/um/sys-i386/shared/sysdep/vm-flags.h
+++ b/arch/um/sys-i386/shared/sysdep/vm-flags.h
@@ -8,7 +8,7 @@
 
 #define VM_DATA_DEFAULT_FLAGS \
 	(VM_READ | VM_WRITE | \
-	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
+	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
 		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #endif
-- 
1.7.0.90.g251a4

