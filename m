Return-Path: <linux-kernel-owner+w=401wt.eu-S1760770AbYAQWlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbYAQWlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759876AbYAQWgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:36:44 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:36244 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098AbYAQWgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:36 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>
Subject: [PATCH 09/30] ocfs2: Documentation update
Date: Thu, 17 Jan 2008 14:35:35 -0800
Message-Id: <1200609356-17788-10-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove 'readpages' from the list in ocfs2.txt. Instead of having two
identical lists, I just removed the list in the OCFS2 section of fs/Kconfig
and added a pointer to Documentation/filesystems/ocfs2.txt.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Documentation/filesystems/ocfs2.txt |    1 -
 fs/Kconfig                          |   10 ++--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index ed55238..e78abdc 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -35,7 +35,6 @@ Features which OCFS2 does not support yet:
 	- Directory change notification (F_NOTIFY)
 	- Distributed Caching (F_SETLEASE/F_GETLEASE/break_lease)
 	- POSIX ACLs
-	- readpages / writepages (not user visible)
 
 Mount options
 =============
diff --git a/fs/Kconfig b/fs/Kconfig
index 487236c..605ee07 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -440,14 +440,8 @@ config OCFS2_FS
 	  Tools web page:      http://oss.oracle.com/projects/ocfs2-tools
 	  OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
 
-	  Note: Features which OCFS2 does not support yet:
-	          - extended attributes
-	          - quotas
-	          - cluster aware flock
-	          - Directory change notification (F_NOTIFY)
-	          - Distributed Caching (F_SETLEASE/F_GETLEASE/break_lease)
-	          - POSIX ACLs
-	          - readpages / writepages (not user visible)
+	  For more information on OCFS2, see the file
+	  <file:Documentation/filesystems/ocfs2.txt>.
 
 config OCFS2_DEBUG_MASKLOG
 	bool "OCFS2 logging support"
-- 
1.5.3.6

