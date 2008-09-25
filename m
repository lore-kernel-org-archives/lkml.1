Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYIYOD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYIYOD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYIYODt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:03:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYIYODs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:03:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Use correct task_struct members in cred.h comments
To: jmorris@namei.org
Cc: dhowells@redhat.com, marc.c.dionne@gmail.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 25 Sep 2008 15:03:37 +0100
Message-ID: <20080925140335.12957.38478.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Dionne <marc.c.dionne@gmail.com>

Adjust comments in linux/cred.h - use the correct names for the struct cred
pointers in the task_struct structure.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/cred.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/include/linux/cred.h b/include/linux/cred.h
index 1f8d8d0..26c1ab1 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -101,14 +101,14 @@ struct thread_group_cred {
  * Note that some members of this structure belong to both categories - the
  * LSM security pointer for instance.
  *
- * A task has two security pointers.  task->sec points to the objective context
- * that defines that task's actual details.  The objective part of this context
- * is used whenever that task is acted upon.
+ * A task has two security pointers.  task->real_cred points to the objective
+ * context that defines that task's actual details.  The objective part of this
+ * context is used whenever that task is acted upon.
  *
- * task->act_as points to the subjective context that defines the details of
- * how that task is going to act upon another object.  This may be overridden
+ * task->cred points to the subjective context that defines the details of how
+ * that task is going to act upon another object.  This may be overridden
  * temporarily to point to another security context, but normally points to the
- * same context as task->sec.
+ * same context as task->real_cred.
  */
 struct cred {
 	atomic_t	usage;

