Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab0CKRdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:33:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0CKRdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:33:03 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/3] GFS2: do not select QUOTA
Date: Thu, 11 Mar 2010 17:21:59 +0000
Message-Id: <1268328121-10797-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1268328121-10797-1-git-send-email-swhiteho@redhat.com>
References: <1268328121-10797-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

gfs2 only needs the quotactl code, not the generic quota implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index 4dcddf8..a47b431 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -8,7 +8,6 @@ config GFS2_FS
 	select FS_POSIX_ACL
 	select CRC32
 	select SLOW_WORK
-	select QUOTA
 	select QUOTACTL
 	help
 	  A cluster filesystem.
-- 
1.6.2.5

