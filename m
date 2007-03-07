Return-Path: <linux-kernel-owner+w=401wt.eu-S965527AbXCGOYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965527AbXCGOYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965534AbXCGOYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:24:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965527AbXCGOYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:24:19 -0500
Subject: [GFS2] add newline to printk message [2/12]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: Richard Fearn <richardfearn@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:27:16 +0000
Message-Id: <1173277636.11001.756.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From d5a6751b32c79680da90eaa76919ffe6e5b8a94f Mon Sep 17 00:00:00 2001
From: Richard Fearn <richardfearn@gmail.com>
Date: Sat, 17 Feb 2007 17:29:15 +0000
Subject: [PATCH] [GFS2] add newline to printk message

Patch for the 2.6.20 stable tree that adds a missing newline to one of
the printk messages in fs/gfs2/ops_fstype.c.

Signed-off-by: Richard Fearn <richardfearn@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index ee80b8a..ee54cb6 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -840,7 +840,7 @@ static struct super_block* get_gfs2_sb(const char *dev_name)
 	}
 
 	printk(KERN_WARNING "GFS2: Unrecognized block device or "
-	       "mount point %s", dev_name);
+	       "mount point %s\n", dev_name);
 
 free_nd:
 	path_release(&nd);
-- 
1.4.4.2



