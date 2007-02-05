Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbXBEOkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbXBEOkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbXBEOkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:40:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbXBEOko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:40:44 -0500
Subject: [DLM/GFS2] indent help text [52/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:48:46 +0000
Message-Id: <1170686926.11001.375.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 10e3fe526f52312da2d4c7cb7ab5e6cc56017a4c Mon Sep 17 00:00:00 2001
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 30 Jan 2007 14:30:08 -0800
Subject: [PATCH] [DLM/GFS2] indent help text

Indent help text as expected.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
index 7e264b7..6fa7b0d 100644
--- a/fs/dlm/Kconfig
+++ b/fs/dlm/Kconfig
@@ -7,17 +7,17 @@ config DLM
 	select CONFIGFS_FS
 	select IP_SCTP if DLM_SCTP
 	help
-	A general purpose distributed lock manager for kernel or userspace
-	applications.
+	  A general purpose distributed lock manager for kernel or userspace
+	  applications.
 
 choice
 	prompt "Select DLM communications protocol"
 	depends on DLM
 	default DLM_TCP
 	help
-	The DLM Can use TCP or SCTP for it's network communications.
-	SCTP supports multi-homed operations whereas TCP doesn't.
-	However, SCTP seems to have stability problems at the moment.
+	  The DLM Can use TCP or SCTP for it's network communications.
+	  SCTP supports multi-homed operations whereas TCP doesn't.
+	  However, SCTP seems to have stability problems at the moment.
 
 config DLM_TCP
 	bool "TCP/IP"
@@ -31,8 +31,8 @@ config DLM_DEBUG
 	bool "DLM debugging"
 	depends on DLM
 	help
-	Under the debugfs mount point, the name of each lockspace will
-	appear as a file in the "dlm" directory.  The output is the
-	list of resource and locks the local node knows about.
+	  Under the debugfs mount point, the name of each lockspace will
+	  appear as a file in the "dlm" directory.  The output is the
+	  list of resource and locks the local node knows about.
 
 endmenu
diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index cbd5f33..de8e64c 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -4,33 +4,33 @@ config GFS2_FS
 	select FS_POSIX_ACL
 	select CRC32
 	help
-	A cluster filesystem.
+	  A cluster filesystem.
 
-	Allows a cluster of computers to simultaneously use a block device
-	that is shared between them (with FC, iSCSI, NBD, etc...).  GFS reads
-	and writes to the block device like a local filesystem, but also uses
-	a lock module to allow the computers coordinate their I/O so
-	filesystem consistency is maintained.  One of the nifty features of
-	GFS is perfect consistency -- changes made to the filesystem on one
-	machine show up immediately on all other machines in the cluster.
+	  Allows a cluster of computers to simultaneously use a block device
+	  that is shared between them (with FC, iSCSI, NBD, etc...).  GFS reads
+	  and writes to the block device like a local filesystem, but also uses
+	  a lock module to allow the computers coordinate their I/O so
+	  filesystem consistency is maintained.  One of the nifty features of
+	  GFS is perfect consistency -- changes made to the filesystem on one
+	  machine show up immediately on all other machines in the cluster.
 
-	To use the GFS2 filesystem, you will need to enable one or more of
-	the below locking modules. Documentation and utilities for GFS2 can
-	be found here: http://sources.redhat.com/cluster
+	  To use the GFS2 filesystem, you will need to enable one or more of
+	  the below locking modules. Documentation and utilities for GFS2 can
+	  be found here: http://sources.redhat.com/cluster
 
 config GFS2_FS_LOCKING_NOLOCK
 	tristate "GFS2 \"nolock\" locking module"
 	depends on GFS2_FS
 	help
-	Single node locking module for GFS2.
+	  Single node locking module for GFS2.
 
-	Use this module if you want to use GFS2 on a single node without
-	its clustering features. You can still take advantage of the
-	large file support, and upgrade to running a full cluster later on
-	if required.
+	  Use this module if you want to use GFS2 on a single node without
+	  its clustering features. You can still take advantage of the
+	  large file support, and upgrade to running a full cluster later on
+	  if required.
 
-	If you will only be using GFS2 in cluster mode, you do not need this
-	module.
+	  If you will only be using GFS2 in cluster mode, you do not need this
+	  module.
 
 config GFS2_FS_LOCKING_DLM
 	tristate "GFS2 DLM locking module"
@@ -39,9 +39,8 @@ config GFS2_FS_LOCKING_DLM
 	select CONFIGFS_FS
 	select DLM
 	help
-	Multiple node locking module for GFS2
-
-	Most users of GFS2 will require this module. It provides the locking
-	interface between GFS2 and the DLM, which is required to use GFS2
-	in a cluster environment.
+	  Multiple node locking module for GFS2
 
+	  Most users of GFS2 will require this module. It provides the locking
+	  interface between GFS2 and the DLM, which is required to use GFS2
+	  in a cluster environment.
-- 
1.4.4.2



