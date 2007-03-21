Return-Path: <linux-kernel-owner+w=401wt.eu-S933814AbXCUTmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814AbXCUTmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933823AbXCUTmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:42:24 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33558 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814AbXCUTmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:42:23 -0400
Date: Wed, 21 Mar 2007 12:41:03 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       serue@us.ibm.com, haveblue@us.ibm.com,
       Containers <containers@lists.osdl.org>, clg@fr.ibm.com
Subject: [PATCH] Define CLONE_NEWPID flag
Message-ID: <20070321194103.GA29820@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This was discussed on containers and we thought it would be useful
to reserve this flag.
---

From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH] Define CLONE_NEWPID flag

Define CLONE_NEWPID flag that will be used to clone pid namespaces.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
---
 include/linux/sched.h |    1 +
 1 file changed, 1 insertion(+)

Index: lx26-21-rc3-mm2/include/linux/sched.h
===================================================================
--- lx26-21-rc3-mm2.orig/include/linux/sched.h	2007-03-20 20:13:19.000000000 -0700
+++ lx26-21-rc3-mm2/include/linux/sched.h	2007-03-21 11:10:33.000000000 -0700
@@ -26,6 +26,7 @@
 #define CLONE_STOPPED		0x02000000	/* Start in stopped state */
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
+#define CLONE_NEWPID		0x10000000      /* New pid namespace */
 
 /*
  * Scheduling policies
