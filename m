Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYLYSMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYLYSMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYLYSFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:05:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbYLYSFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:05:30 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 21/35] ocfs2: Enable metadata checksums.
Date: Thu, 25 Dec 2008 10:04:36 -0800
Message-Id: <1230228290-22803-22-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

Add OCFS2_FEATURE_INCOMPAT_META_ECC to the list of supported features.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/ocfs2_fs.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 698ef3d..c7ae45a 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -94,7 +94,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_INLINE_DATA \
 					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
 					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
-					 | OCFS2_FEATURE_INCOMPAT_XATTR)
+					 | OCFS2_FEATURE_INCOMPAT_XATTR \
+					 | OCFS2_FEATURE_INCOMPAT_META_ECC)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
 					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
-- 
1.5.6

