Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502Ab0B0Q5G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:57:06 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030457Ab0B0Q46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:56:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=q93TQuXR+cgQ0Vq/IZ+qtChaS7ll+vfpBoKGY3DR7mKfObFlYB6vnicr5M2QebjjKG
         5tNCczsqAZpnfpQ2XP79wkGq0qcM3LpN6GUF1JvUBZd4UCJOullwnPjzDDEiVflHyQ71
         R7P2ba0Fx4/7ZJOIV2L+n9dAn0ubEL9sUraRg=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 50/66] arch/um/include/shared/irq_kern.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:31 +0100
Message-Id: <1267289508-31031-51-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/include/shared/irq_kern.h:14: ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/um/include/shared/irq_kern.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/include/shared/irq_kern.h b/arch/um/include/shared/irq_kern.h
index b05d22f..f5855e1 100644
--- a/arch/um/include/shared/irq_kern.h
+++ b/arch/um/include/shared/irq_kern.h
@@ -11,8 +11,7 @@
 
 extern int um_request_irq(unsigned int irq, int fd, int type,
 			  irq_handler_t handler,
-			  unsigned long irqflags,  const char * devname,
+			  unsigned long irqflags,  const char *devname,
 			  void *dev_id);
 
 #endif
-
-- 
1.7.0.90.g251a4

