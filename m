Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZAGKPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZAGKPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 05:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZAGKOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 05:14:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48224 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZAGKOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 05:14:39 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/3] GFS2: LSF and LBD are now one and the same
Date: Wed,  7 Jan 2009 09:16:23 +0000
Message-Id: <1231319784-18695-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1231319784-18695-2-git-send-email-swhiteho@redhat.com>
References: <1231319784-18695-1-git-send-email-swhiteho@redhat.com>
 <1231319784-18695-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a result of this recent patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b3a6ffe16b5cc48abe7db8d04882dc45280eb693
We only need to depend on LBD.

Reported-by: Fabio M. Di Nitto <fdinitto@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index ab2f57e..e563a64 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -1,6 +1,6 @@
 config GFS2_FS
 	tristate "GFS2 file system support"
-	depends on EXPERIMENTAL && (64BIT || (LSF && LBD))
+	depends on EXPERIMENTAL && (64BIT || LBD)
 	select FS_POSIX_ACL
 	select CRC32
 	help
-- 
1.6.0.3

