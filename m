Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab0BYLHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:07:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:52084 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab0BYLHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:07:20 -0500
Date: Thu, 25 Feb 2010 11:06:35 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1266887105-1528-6-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-6-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] sched, cgroups: Fix module export
Message-ID: <tip-c50cc75271759373bd89a036eec4d4269b291616@git.kernel.org>
Git-Commit-ID: c50cc75271759373bd89a036eec4d4269b291616
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 11:06:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c50cc75271759373bd89a036eec4d4269b291616
Gitweb:     http://git.kernel.org/tip/c50cc75271759373bd89a036eec4d4269b291616
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 25 Feb 2010 12:02:13 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 12:02:13 +0100

sched, cgroups: Fix module export

I have exported it in d11c563 - but cgroups.c did not have module.h included ...

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1266887105-1528-6-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/cgroup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b1a0f5a..4fd90e1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/cgroup.h>
+#include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
