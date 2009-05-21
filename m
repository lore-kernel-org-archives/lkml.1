Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbZEUAb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbZEUAb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbZEUA2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:28:44 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37173 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbZEUA2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:28:18 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 12/20] sysfs: Nicely indent sysfs_symlink_inode_operations
Date: Wed, 20 May 2009 17:28:06 -0700
Message-Id: <1242865694-2100-12-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-11-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
 <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-2-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-5-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-6-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-7-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-8-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-9-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-10-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-11-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Lining up the functions in sysfs_symlink_inode_operations
follows the pattern in the rest of sysfs and makes things
slightly more readable.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/symlink.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index ac13e61..0367ed1 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -198,9 +198,9 @@ static void sysfs_put_link(struct dentry *dentry, struct nameidata *nd, void *co
 }
 
 const struct inode_operations sysfs_symlink_inode_operations = {
-	.readlink = generic_readlink,
-	.follow_link = sysfs_follow_link,
-	.put_link = sysfs_put_link,
+	.readlink	= generic_readlink,
+	.follow_link	= sysfs_follow_link,
+	.put_link	= sysfs_put_link,
 };
 
 
-- 
1.6.1.2.350.g88cc

