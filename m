Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZCQUEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZCQUEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 16:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZCQUEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 16:04:22 -0400
Received: from mail.suse.de ([195.135.220.2]:44455 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbZCQUEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 16:04:21 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 11/32] ocfs2: Enable indexed directories
Date: Tue, 17 Mar 2009 13:01:01 -0700
Message-Id: <1237320082-12921-12-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the disk format is finalized, we can set this feature bit in the
supported mask.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <Joel.Becker@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index f7a5201..7ab6e9e 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -97,7 +97,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
 					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
 					 | OCFS2_FEATURE_INCOMPAT_XATTR \
-					 | OCFS2_FEATURE_INCOMPAT_META_ECC)
+					 | OCFS2_FEATURE_INCOMPAT_META_ECC \
+					 | OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
 					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
-- 
1.5.6

