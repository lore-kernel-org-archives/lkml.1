Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZKDPZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZKDPZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbZKDPZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:25:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:57277 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbZKDPZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:25:23 -0500
Date: Wed, 4 Nov 2009 15:24:34 GMT
From: tip-bot for Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com,
       balbir@in.ibm.com, bharata@linux.vnet.ibm.com, serue@us.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, balbir@in.ibm.com,
       bharata@linux.vnet.ibm.com, serue@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091103214544.GI5495@linux.vnet.ibm.com>
References: <20091103214544.GI5495@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add USER_SCHED to feature removal list
Message-ID: <tip-45a5c8bad827ebb9c9798becc15bce2e804d49e0@git.kernel.org>
Git-Commit-ID: 45a5c8bad827ebb9c9798becc15bce2e804d49e0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45a5c8bad827ebb9c9798becc15bce2e804d49e0
Gitweb:     http://git.kernel.org/tip/45a5c8bad827ebb9c9798becc15bce2e804d49e0
Author:     Dhaval Giani <dhaval@linux.vnet.ibm.com>
AuthorDate: Wed, 4 Nov 2009 03:15:44 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 12:40:26 +0100

sched: Add USER_SCHED to feature removal list

Peter Zijlstra suggested that we remove USER_SCHED at:

   http://lkml.org/lkml/2009/3/21/67

Removing USER_SCHED removes a lot of code from the scheduler
and simplifies the code.

We already have the ability to do user based classification
which is tightened using PAM in userspace.

Schedule USER_SCHED for removal in 2.6.34

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
LKML-Reference: <20091103214544.GI5495@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/feature-removal-schedule.txt |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index bc693ff..f613df8 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,6 +6,21 @@ be removed from this file.
 
 ---------------------------
 
+What:	USER_SCHED
+When:	2.6.34
+
+Why:	USER_SCHED was implemented as a proof of concept for group scheduling.
+	The effect of USER_SCHED can already be achieved from userspace with
+	the help of libcgroup. The removal of USER_SCHED will also simplify
+	the scheduler code with the removal of one major ifdef. There are also
+	issues USER_SCHED has with USER_NS. A decision was taken not to fix
+	those and instead remove USER_SCHED. Also new group scheduling
+	features will not be implemented for USER_SCHED.
+
+Who:	Dhaval Giani <dhaval@linux.vnet.ibm.com>
+
+---------------------------
+
 What:	PRISM54
 When:	2.6.34
 
