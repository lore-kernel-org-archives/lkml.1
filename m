Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbYLYAHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbYLYAHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 19:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYLYAH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 19:07:27 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:46048 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYLYAH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 19:07:27 -0500
Date: Wed, 24 Dec 2008 16:06:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sysrq: fix ftrace help msg & doc.
Message-Id: <20081224160657.fc391d4b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4952CEA5.00B4:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

We have a conventional method of explicitly stating the
sysrq action key in a sysrq help message, so change
dump-ftrace-buffer to use that method and add it to
Documentation/sysrq.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>
---
 Documentation/sysrq.txt |    2 ++
 drivers/char/sysrq.c    |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- mmotm-2008-1224-0120.orig/drivers/char/sysrq.c
+++ mmotm-2008-1224-0120/drivers/char/sysrq.c
@@ -283,7 +283,7 @@ static void sysrq_ftrace_dump(int key, s
 }
 static struct sysrq_key_op sysrq_ftrace_dump_op = {
 	.handler	= sysrq_ftrace_dump,
-	.help_msg	= "dumpZ-ftrace-buffer",
+	.help_msg	= "dump-ftrace-buffer(Z)",
 	.action_msg	= "Dump ftrace buffer",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
--- mmotm-2008-1224-0120.orig/Documentation/sysrq.txt
+++ mmotm-2008-1224-0120/Documentation/sysrq.txt
@@ -114,6 +114,8 @@ On all -  write a character to /proc/sys
 
 'x'	- Used by xmon interface on ppc/powerpc platforms.
 
+'z'	- Dump the ftrace buffer
+
 '0'-'9' - Sets the console log level, controlling which kernel messages
           will be printed to your console. ('0', for example would make
           it so that only emergency messages like PANICs or OOPSes would
