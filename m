Return-Path: <linux-kernel-owner+w=401wt.eu-S934778AbYEUPrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778AbYEUPrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbYEUPr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:47:26 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:16024 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363AbYEUPrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:47:25 -0400
Message-ID: <48344409.9090903@fr.ibm.com>
Date: Wed, 21 May 2008 17:47:21 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH -mm] remove node_ prefix_from ns subsystem
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cedric Le Goater <clg@fr.ibm.com>

This is a slight change in the namespace cgroup subsystem api.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.26-rc2-mm1/kernel/cgroup.c
===================================================================
--- 2.6.26-rc2-mm1.orig/kernel/cgroup.c
+++ 2.6.26-rc2-mm1/kernel/cgroup.c
@@ -2903,7 +2903,7 @@ int cgroup_clone(struct task_struct *tsk
 	cg = tsk->cgroups;
 	parent = task_cgroup(tsk, subsys->subsys_id);
 
-	snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "node_%d", tsk->pid);
+	snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "%d", tsk->pid);
 
 	/* Pin the hierarchy */
 	atomic_inc(&parent->root->sb->s_active);
