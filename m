Return-Path: <linux-kernel-owner+w=401wt.eu-S934733AbZLPIL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934733AbZLPIL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761759AbZLPILl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:11:41 -0500
Received: from mail.perches.com ([173.55.12.10]:1208 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761739AbZLPIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:16 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] kernel.h: Remove ATTRIB_NORET, use __attribute__((noreturn))
Date: Wed, 16 Dec 2009 00:09:09 -0800
Message-Id: <fb44a736a16e346f944a896e6bf0b38227991ba6.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No real need to indirect this

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3b796b9..5c97b73 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -132,9 +132,9 @@ extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
 NORET_TYPE void do_exit(long code)
-	ATTRIB_NORET;
+	__attribute__ ((noreturn));
 NORET_TYPE void complete_and_exit(struct completion *comp, long code)
-	ATTRIB_NORET;
+	__attribute__ ((noreturn));
 
 /*
  * stdlib - String to type conversions
-- 
1.6.6.rc0.57.gad7a

