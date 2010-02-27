Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030469Ab0B0Q43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:56:29 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030438Ab0B0Q4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:56:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kMFh70zoTbKaDM9oyCNQWGo+lqJuWUfNSczfIe9rAi84MjhBKGTUTLMJwufkjT4Gcz
         OAzqYicIAixbE0JUxGRzGc323QxU8+DH3kqF6bu6F071yjuZ+xklYBCekE6FAqh1R/Ud
         Jf5ffEqfq0irqfA5331wxHb1tmU3SqFMKtNUc=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 43/66] arch/um/include/shared/sysrq.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:24 +0100
Message-Id: <1267289508-31031-44-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/include/shared/sysrq.h:5: ERROR: "foo* bar" should be "foo *bar"

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/include/shared/sysrq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/include/shared/sysrq.h b/arch/um/include/shared/sysrq.h
index c8d332b..19181a9 100644
--- a/arch/um/include/shared/sysrq.h
+++ b/arch/um/include/shared/sysrq.h
@@ -2,6 +2,6 @@
 #define __UM_SYSRQ_H
 
 struct task_struct;
-extern void show_trace(struct task_struct* task, unsigned long *stack);
+extern void show_trace(struct task_struct *task, unsigned long *stack);
 
 #endif
-- 
1.7.0.90.g251a4

