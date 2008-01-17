Return-Path: <linux-kernel-owner+w=401wt.eu-S1761441AbYAQWtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441AbYAQWtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759862AbYAQWh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:37:26 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:36566 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618AbYAQWhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:37:05 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 28/30] configfs: Remove EXPERIMENTAL
Date: Thu, 17 Jan 2008 14:35:54 -0800
Message-Id: <1200609356-17788-29-git-send-email-mark.fasheh@oracle.com>
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

From: Joel Becker <joel.becker@oracle.com>

configfs has been alive and kicking for a while now.  It underpins some
non-EXPERIMENTAL subsystems, such as OCFS2's cluster stack.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 605ee07..eb353f5 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1022,8 +1022,8 @@ config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
 config CONFIGFS_FS
-	tristate "Userspace-driven configuration filesystem (EXPERIMENTAL)"
-	depends on SYSFS && EXPERIMENTAL
+	tristate "Userspace-driven configuration filesystem"
+	depends on SYSFS
 	help
 	  configfs is a ram-based filesystem that provides the converse
 	  of sysfs's functionality. Where sysfs is a filesystem-based
-- 
1.5.3.6

