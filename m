Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030344Ab0B0QyF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:54:05 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968581Ab0B0Qxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:53:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cuODGhnqCXpCC1BfMXI67JVTlKPhxhXeW4QLNPVamSt3wQVd/0/gbETEvzPh96LnR9
         r2TVcIIl6Xpqxq/voMB3sCraCHqQBktknsQZ3dCdO1BBpJMp4W7oQJXGbxjyGbZE9APx
         PNMLgUloI/W3NJVtpjwExKMeVnE473EZ5d6mQ=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 20/66] arch/cris/include/asm/current.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:01 +0100
Message-Id: <1267289508-31031-21-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/cris/include/asm/current.h:8: ERROR: "foo * bar" should be "foo *bar"
arch/cris/include/asm/current.h:10: ERROR: code indent should use tabs where possible
arch/cris/include/asm/current.h:12: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/cris/include/asm/current.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/cris/include/asm/current.h b/arch/cris/include/asm/current.h
index 5f5c0ef..e846834 100644
--- a/arch/cris/include/asm/current.h
+++ b/arch/cris/include/asm/current.h
@@ -5,11 +5,11 @@
 
 struct task_struct;
 
-static inline struct task_struct * get_current(void)
+static inline struct task_struct *get_current(void)
 {
-        return current_thread_info()->task;
+	return current_thread_info()->task;
 }
- 
+
 #define current get_current()
 
 #endif /* !(_CRIS_CURRENT_H) */
-- 
1.7.0.90.g251a4

