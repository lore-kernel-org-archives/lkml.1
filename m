Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbYHSXXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbYHSXXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYHSXWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:22:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51573 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbYHSXWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:22:38 -0400
Message-Id: <20080819232234.563323820@us.ibm.com>
References: <20080819232232.432973784@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Aug 2008 16:22:36 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH 4/6] Container Freezer: Cleanup comment.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make this comment clearer.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Andrew was wondering if the comment was in the right place. I think it is but
suspect it could stand to be clarified.

 kernel/cgroup_freezer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.27-rc1-mm1/kernel/cgroup_freezer.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/kernel/cgroup_freezer.c
+++ linux-2.6.27-rc1-mm1/kernel/cgroup_freezer.c
@@ -61,8 +61,8 @@ int cgroup_frozen(struct task_struct *ta
 }
 
 /*
- * Buffer size for freezer state is limited by cgroups write_string()
- * interface. See cgroups code for the current size.
+ * cgroups_write_string() limits the size of freezer state strings to
+ * CGROUP_LOCAL_BUFFER_SIZE
  */
 static const char *freezer_state_strs[] = {
 	"THAWED",

-- 
