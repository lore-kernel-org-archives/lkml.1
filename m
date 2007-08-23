Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbXHWJUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbXHWJUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbXHWJTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:19:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50945 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbXHWJTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:19:55 -0400
Date: Thu, 23 Aug 2007 10:19:53 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Renumber AUDIT_TTY_[GS]ET
Message-ID: <20070823091953.GK21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miloslav Trmac <mitr@redhat.com>

Renumber AUDIT_TTY_[GS]ET to avoid a conflict with netlink message types
already used in the wild.

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
Please, apply.  That really ought to go in before .final ;-/
 audit.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 4bbd860..d6579df 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -63,8 +63,8 @@
 #define AUDIT_ADD_RULE		1011	/* Add syscall filtering rule */
 #define AUDIT_DEL_RULE		1012	/* Delete syscall filtering rule */
 #define AUDIT_LIST_RULES	1013	/* List syscall filtering rules */
-#define AUDIT_TTY_GET		1014	/* Get TTY auditing status */
-#define AUDIT_TTY_SET		1015	/* Set TTY auditing status */
+#define AUDIT_TTY_GET		1016	/* Get TTY auditing status */
+#define AUDIT_TTY_SET		1017	/* Set TTY auditing status */
 
 #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
 #define AUDIT_USER_AVC		1107	/* We filter this differently */
