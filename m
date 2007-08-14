Return-Path: <linux-kernel-owner+w=401wt.eu-S939227AbXHNCFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939227AbXHNCFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 22:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXHNCFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 22:05:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56866 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758226AbXHNCFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 22:05:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: LKML <linux-kernel@vger.kernel.org>
Subject: ignoring unimplemented functions that are old and crusty on shiny new ports
Date: Mon, 13 Aug 2007 22:05:20 -0400
User-Agent: KMail/1.9.7
Cc: vapier.adi@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132205.20454.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

would it be possible to get the class of "old and crusty" functions
permanently ignored ?  i'm thinking of course of "uselib" and "sysfs" ...
Blackfin does not implement either of these and i think that's a good thing

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index 0dcc01c..7f1a830 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -104,6 +104,10 @@ cat << EOF
 #define __IGNORE_sync_file_range
 #endif
 
+/* Old optional stuff no one actually uses */
+#define __IGNORE_sysfs
+#define __IGNORE_uselib
+
 /* Unmerged syscalls for AFS, STREAMS, etc. */
 #define __IGNORE_afs_syscall
 #define __IGNORE_getpmsg
