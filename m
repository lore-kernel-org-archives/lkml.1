Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030331Ab0B0Qx6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:53:58 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030322Ab0B0Qxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:53:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=WgaS+SsHs7Yhpc2iI6vTCBCZVnG5GpstnqLSvulYb0K30Gyljr4SfIqcGzhj6QUCcj
         bN4dUgCKF/i1vtqHBsP10HXijXFrV/HPTTRljUzcPPeAHDoVPjYCPzoVc/LXC2+L1WTT
         wBN4SDEjmBZOMPHmWpclfSeitMIAion5rxWdY=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Subject: [PATCH 19/66] arch/parisc/include/asm/current.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:00 +0100
Message-Id: <1267289508-31031-20-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/parisc/include/asm/current.h:8: ERROR: "foo * bar" should be "foo *bar"
arch/parisc/include/asm/current.h:12: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/parisc/include/asm/current.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/current.h b/arch/parisc/include/asm/current.h
index 0fb9338..4cbf4ad 100644
--- a/arch/parisc/include/asm/current.h
+++ b/arch/parisc/include/asm/current.h
@@ -5,11 +5,11 @@
 
 struct task_struct;
 
-static inline struct task_struct * get_current(void)
+static inline struct task_struct *get_current(void)
 {
 	return current_thread_info()->task;
 }
- 
+
 #define current get_current()
 
 #endif /* !(_PARISC_CURRENT_H) */
-- 
1.7.0.90.g251a4

