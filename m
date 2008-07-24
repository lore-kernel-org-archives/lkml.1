Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbYGYAAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbYGYAAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 20:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYGXX77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:59:59 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23538 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYGXX77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:59:59 -0400
Date: Thu, 24 Jul 2008 16:58:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: peterz@infradead.org, mingo <mingo@redhat.com>,
       akpm <akpm@linux-foundation.org>, gregkh <greg@kroah.com>
Subject: [PATCH] locking: fix mutex @key parameter kernel-doc notation
Message-Id: <20080724165842.fbae8993.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix @key parameter to mutex_init() and one of its callers.

Warning(linux-2.6.26-git11//drivers/base/class.c:210): No description found for parameter 'key'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/class.c |    1 +
 kernel/mutex.c       |    1 +
 2 files changed, 2 insertions(+)

--- linux-2.6.26-git11.orig/drivers/base/class.c
+++ linux-2.6.26-git11/drivers/base/class.c
@@ -198,6 +198,7 @@ static void class_create_release(struct 
  * class_create - create a struct class structure
  * @owner: pointer to the module that is to "own" this struct class
  * @name: pointer to a string for the name of this class.
+ * @key: the lock_class_key for this class; used by mutex lock debugging
  *
  * This is used to create a struct class pointer that can then be used
  * in calls to device_create().
--- linux-2.6.26-git11.orig/kernel/mutex.c
+++ linux-2.6.26-git11/kernel/mutex.c
@@ -34,6 +34,7 @@
 /***
  * mutex_init - initialize the mutex
  * @lock: the mutex to be initialized
+ * @key: the lock_class_key for the class; used by mutex lock debugging
  *
  * Initialize the mutex to unlocked state.
  *
