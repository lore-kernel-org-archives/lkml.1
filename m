Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbZBCABT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbZBCABT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbZBCABJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:01:09 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:50271 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZBCABI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:01:08 -0500
Date: Mon, 2 Feb 2009 16:00:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: mingo <mingo@redhat.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] sched: add missing kernel-doc in sched.h
Message-Id: <20090202160029.dfea8898.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49878926.01C7:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add kernel-doc notation for @lock:

include/linux/sched.h:457: No description found for parameter 'lock'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/sched.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.29-rc3-git3.orig/include/linux/sched.h
+++ linux-2.6.29-rc3-git3/include/linux/sched.h
@@ -443,6 +443,7 @@ struct pacct_struct {
  * @utime:		time spent in user mode, in &cputime_t units
  * @stime:		time spent in kernel mode, in &cputime_t units
  * @sum_exec_runtime:	total time spent on the CPU, in nanoseconds
+ * @lock:		lock for fields in this struct
  *
  * This structure groups together three kinds of CPU time that are
  * tracked for threads and thread groups.  Most things considering
