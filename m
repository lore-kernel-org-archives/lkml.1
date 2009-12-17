Return-Path: <linux-kernel-owner+w=401wt.eu-S965504AbZLQTn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965504AbZLQTn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965490AbZLQTn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:43:57 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:18811 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965489AbZLQTn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:43:57 -0500
Date: Thu, 17 Dec 2009 11:43:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] printk: fix new kernel-doc warnings
Message-Id: <20091217114303.64bd22dc.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B2A89D2.0117:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in printk.c:

Warning(kernel/printk.c:1422): No description found for parameter 'dumper'
Warning(kernel/printk.c:1422): Excess function parameter 'dump' description in 'kmsg_dump_register'
Warning(kernel/printk.c:1451): No description found for parameter 'dumper'
Warning(kernel/printk.c:1451): Excess function parameter 'dump' description in 'kmsg_dump_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.32-git14.orig/kernel/printk.c
+++ linux-2.6.32-git14/kernel/printk.c
@@ -1412,7 +1412,7 @@ static LIST_HEAD(dump_list);
 
 /**
  * kmsg_dump_register - register a kernel log dumper.
- * @dump: pointer to the kmsg_dumper structure
+ * @dumper: pointer to the kmsg_dumper structure
  *
  * Adds a kernel log dumper to the system. The dump callback in the
  * structure will be called when the kernel oopses or panics and must be
@@ -1442,7 +1442,7 @@ EXPORT_SYMBOL_GPL(kmsg_dump_register);
 
 /**
  * kmsg_dump_unregister - unregister a kmsg dumper.
- * @dump: pointer to the kmsg_dumper structure
+ * @dumper: pointer to the kmsg_dumper structure
  *
  * Removes a dump device from the system. Returns zero on success and
  * %-EINVAL otherwise.
