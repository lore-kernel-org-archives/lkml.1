Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030527Ab0B0Q5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:57:55 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030535Ab0B0Q5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:57:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=XSaXbe/4x2quqHWMkcB7fmn95DAU4yLnI9ftITuF3PImmgeUpJC14Zl2AfHzBKh7uT
         6EtycnRnQgG40UtF1me6Td+EzSmlK2BKFeup2Pvh4luky18fCWbf5T8duoaTReRdUbgE
         EEhteDESSQx5KGh+VK0Mq6KOtOR+Edqi0gFLs=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 59/66] arch/cris/include/arch-v10/arch/thread_info.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:40 +0100
Message-Id: <1267289508-31031-60-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/cris/include/arch-v10/arch/thread_info.h:8: ERROR: code indent should use tabs where possible
arch/cris/include/arch-v10/arch/thread_info.h:8: ERROR: spaces required around that ':' (ctx:VxV)
arch/cris/include/arch-v10/arch/thread_info.h:9: ERROR: code indent should use tabs where possible

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/cris/include/arch-v10/arch/thread_info.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/include/arch-v10/arch/thread_info.h b/arch/cris/include/arch-v10/arch/thread_info.h
index 218f415..218ceb8 100644
--- a/arch/cris/include/arch-v10/arch/thread_info.h
+++ b/arch/cris/include/arch-v10/arch/thread_info.h
@@ -5,8 +5,8 @@
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-        __asm__("and.d $sp,%0; ":"=r" (ti) : "0" (~8191UL));
-        return ti;
+	__asm__("and.d $sp,%0; " : "=r" (ti) : "0" (~8191UL));
+	return ti;
 }
 
 #endif
-- 
1.7.0.90.g251a4

