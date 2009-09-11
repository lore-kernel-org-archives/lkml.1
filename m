Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZIKWq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZIKWq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbZIKWq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:46:56 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:32144 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZIKWqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:46:55 -0400
Date: Fri, 11 Sep 2009 15:46:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] docs: fix various Documentation/ paths in header files
Message-Id: <20090911154645.3c8cb87e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AAAD357.0009:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix various Documentation/ paths in include/linux/.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/configfs.h   |    4 ++--
 include/linux/debugfs.h    |    2 +-
 include/linux/marker.h     |    2 +-
 include/linux/relay.h      |    2 +-
 include/linux/tracepoint.h |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.31-git1.orig/include/linux/configfs.h
+++ linux-2.6.31-git1/include/linux/configfs.h
@@ -27,8 +27,8 @@
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  *
- * Please read Documentation/filesystems/configfs.txt before using the
- * configfs interface, ESPECIALLY the parts about reference counts and
+ * Please read Documentation/filesystems/configfs/configfs.txt before using
+ * the configfs interface, ESPECIALLY the parts about reference counts and
  * item destructors.
  */
 
--- linux-2.6.31-git1.orig/include/linux/debugfs.h
+++ linux-2.6.31-git1/include/linux/debugfs.h
@@ -9,7 +9,7 @@
  *	2 as published by the Free Software Foundation.
  *
  *  debugfs is for people to use instead of /proc or /sys.
- *  See Documentation/DocBook/kernel-api for more details.
+ *  See Documentation/DocBook/filesystems for more details.
  */
 
 #ifndef _DEBUGFS_H_
--- linux-2.6.31-git1.orig/include/linux/marker.h
+++ linux-2.6.31-git1/include/linux/marker.h
@@ -4,7 +4,7 @@
 /*
  * Code markup for dynamic and static tracing.
  *
- * See Documentation/marker.txt.
+ * See Documentation/markers.txt.
  *
  * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
--- linux-2.6.31-git1.orig/include/linux/relay.h
+++ linux-2.6.31-git1/include/linux/relay.h
@@ -140,7 +140,7 @@ struct rchan_callbacks
 	 * cause relay_open() to create a single global buffer rather
 	 * than the default set of per-cpu buffers.
 	 *
-	 * See Documentation/filesystems/relayfs.txt for more info.
+	 * See Documentation/filesystems/relay.txt for more info.
 	 */
 	struct dentry *(*create_buf_file)(const char *filename,
 					  struct dentry *parent,
--- linux-2.6.31-git1.orig/include/linux/tracepoint.h
+++ linux-2.6.31-git1/include/linux/tracepoint.h
@@ -4,7 +4,7 @@
 /*
  * Kernel Tracepoint API.
  *
- * See Documentation/tracepoint.txt.
+ * See Documentation/trace/tracepoints.txt.
  *
  * (C) Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *




---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
