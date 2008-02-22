Return-Path: <linux-kernel-owner+w=401wt.eu-S936253AbYBVAuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936253AbYBVAuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbYBVAu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:50:29 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:55137 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1754408AbYBVAu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:50:28 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Fri, 22 Feb 2008 11:49:56 +1100
Message-ID: <20080222-114832-init-kconfig-2@tull.net>
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Serge Hallyn <serue@us.ibm.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: [PATCH 2.6.25-rc2 2/9] Kconfig: Improve init/Kconfig help descriptions - TASKSTATS
References: <20080219140609.GA26619@tull.net>
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the help descriptions for clarity, accuracy and consistency.

Kernel config options affected:

  - TASKSTATS
  - TASK_DELAY_ACCT
  - TASK_XACCT
  - TASK_IO_ACCOUNTING

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---
Try #3.

--- a/init/Kconfig	2008-02-20 09:34:48.000000000 +1100
+++ b/init/Kconfig	2008-02-20 09:35:28.000000000 +1100
@@ -177,42 +177,52 @@ config TASKSTATS
 	depends on NET
 	default n
 	help
-	  Export selected statistics for tasks/processes through the
-	  generic netlink interface. Unlike BSD process accounting, the
-	  statistics are available during the lifetime of tasks/processes as
-	  responses to commands. Like BSD accounting, they are sent to user
-	  space on task exit.
+	  Taskstats is a netlink-based interface for sending per-task
+	  and per-process statistics from the kernel to userspace.
 
-	  Say N if unsure.
+	  Unlike BSD process accounting, the statistics are available
+	  during the lifetime of tasks/processes as responses to
+	  commands. Like BSD accounting, they are sent to user space on
+	  task exit.
+
+	  Netlink is a type of network socket used to transfer data
+	  between the kernel and user space. For more information on
+	  Netlink see <http://qos.ittc.ku.edu/netlink/html/index.html>
+
+	  See <file:Documentation/accounting/taskstats.txt> for more
+	  information on taskstats.
+
+	  If unsure, say N.
 
 config TASK_DELAY_ACCT
 	bool "Enable per-task delay accounting (EXPERIMENTAL)"
 	depends on TASKSTATS
 	help
-	  Collect information on time spent by a task waiting for system
-	  resources like cpu, synchronous block I/O completion and swapping
-	  in pages. Such statistics can help in setting a task's priorities
-	  relative to other tasks for cpu, io, rss limits etc.
+	  Also collect information on time spent by a task waiting for
+	  system resources like CPU, synchronous block I/O completion and
+	  swapping in pages. Such statistics can help in setting a task's
+	  priorities relative to other tasks for CPU, I/O, RSS limits etc.
 
-	  Say N if unsure.
+	  If unsure, say N.
 
 config TASK_XACCT
 	bool "Enable extended accounting over taskstats (EXPERIMENTAL)"
 	depends on TASKSTATS
 	help
-	  Collect extended task accounting data and send the data
-	  to userland for processing over the taskstats interface.
+	  Also collect extended task accounting data and send
+	  the data to userland for processing over the taskstats
+	  interface.
 
-	  Say N if unsure.
+	  If unsure, say N.
 
 config TASK_IO_ACCOUNTING
 	bool "Enable per-task storage I/O accounting (EXPERIMENTAL)"
 	depends on TASK_XACCT
 	help
-	  Collect information on the number of bytes of storage I/O which this
-	  task has caused.
+	  Also collect information on the number of bytes of storage
+	  I/O which this task has caused.
 
-	  Say N if unsure.
+	  If unsure, say N.
 
 config AUDIT
 	bool "Auditing support"
