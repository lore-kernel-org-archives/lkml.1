Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYBSOMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYBSOMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYBSOMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:12:22 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:46665 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752763AbYBSOMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:12:21 -0500
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 09:12:20 EST
X-Spam-Check-By: mail.local.tull.net
Date: Wed, 20 Feb 2008 01:11:50 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Improve init/Kconfig help descriptions [PATCH 2/9]
Message-ID: <20080219141150.GB26697@tull.net>
References: <20080219140609.GA26619@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219140609.GA26619@tull.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 01:06:09AM +1100, Nick Andrew wrote:
> Here is a series of 9 patches to init/Kconfig intended to improve the
> usefulness and consistency of the help descriptions. The patches are
> against linux-2.6.24.2.
> [...]
> Patch 2
> 	TASKSTATS
> 	TASK_DELAY_ACCT
> 	TASK_XACCT
> 	TASK_IO_ACCOUNTING

Changelog:

Improve usefulness and consistency of kernel configuration help messages.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>

--- a/init/Kconfig	2008-02-20 00:45:07.000000000 +1100
+++ b/init/Kconfig	2008-02-20 00:52:07.000000000 +1100
@@ -169,42 +169,52 @@ config TASKSTATS
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
 
 config USER_NS
 	bool "User Namespaces (EXPERIMENTAL)"
