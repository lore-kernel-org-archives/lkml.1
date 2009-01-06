Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbZAFWOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbZAFWOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZAFWNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:20 -0500
Received: from kroah.org ([198.145.64.141]:51164 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751580AbZAFWNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 02/60] Fix misspellings in pm.h macros
Date: Tue,  6 Jan 2009 14:11:21 -0800
Message-Id: <1231279939-32728-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1167) fixes some misspellings in various recently-added
macros in pm.h.  Fortunately these macros are not yet used anywhere.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/pm.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 5785666..de2e0a8 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -252,7 +252,7 @@ struct dev_pm_ops {
 #define PM_EVENT_SLEEP		(PM_EVENT_SUSPEND | PM_EVENT_HIBERNATE)
 #define PM_EVENT_USER_SUSPEND	(PM_EVENT_USER | PM_EVENT_SUSPEND)
 #define PM_EVENT_USER_RESUME	(PM_EVENT_USER | PM_EVENT_RESUME)
-#define PM_EVENT_REMOTE_WAKEUP	(PM_EVENT_REMOTE | PM_EVENT_RESUME)
+#define PM_EVENT_REMOTE_RESUME	(PM_EVENT_REMOTE | PM_EVENT_RESUME)
 #define PM_EVENT_AUTO_SUSPEND	(PM_EVENT_AUTO | PM_EVENT_SUSPEND)
 #define PM_EVENT_AUTO_RESUME	(PM_EVENT_AUTO | PM_EVENT_RESUME)
 
@@ -265,15 +265,15 @@ struct dev_pm_ops {
 #define PMSG_THAW	((struct pm_message){ .event = PM_EVENT_THAW, })
 #define PMSG_RESTORE	((struct pm_message){ .event = PM_EVENT_RESTORE, })
 #define PMSG_RECOVER	((struct pm_message){ .event = PM_EVENT_RECOVER, })
-#define PMSG_USER_SUSPEND	((struct pm_messge) \
+#define PMSG_USER_SUSPEND	((struct pm_message) \
 					{ .event = PM_EVENT_USER_SUSPEND, })
-#define PMSG_USER_RESUME	((struct pm_messge) \
+#define PMSG_USER_RESUME	((struct pm_message) \
 					{ .event = PM_EVENT_USER_RESUME, })
-#define PMSG_REMOTE_RESUME	((struct pm_messge) \
+#define PMSG_REMOTE_RESUME	((struct pm_message) \
 					{ .event = PM_EVENT_REMOTE_RESUME, })
-#define PMSG_AUTO_SUSPEND	((struct pm_messge) \
+#define PMSG_AUTO_SUSPEND	((struct pm_message) \
 					{ .event = PM_EVENT_AUTO_SUSPEND, })
-#define PMSG_AUTO_RESUME		((struct pm_messge) \
+#define PMSG_AUTO_RESUME	((struct pm_message) \
 					{ .event = PM_EVENT_AUTO_RESUME, })
 
 /**
-- 
1.6.0.4

