Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbYLVVwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbYLVVwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbYLVVs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:48:59 -0500
Received: from mail.suse.de ([195.135.220.2]:41567 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851AbYLVVs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:48:59 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 09/56] quota: Remove compatibility function sb_any_quota_enabled()
Date: Mon, 22 Dec 2008 13:47:50 -0800
Message-Id: <1229982517-3455-10-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 include/linux/quotaops.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 3b3346f..e840ca5 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -116,9 +116,6 @@ static inline int sb_any_quota_active(struct super_block *sb)
 	       sb_has_quota_active(sb, GRPQUOTA);
 }
 
-/* For backward compatibility until we remove all users */
-#define sb_any_quota_enabled(sb) sb_any_quota_active(sb)
-
 /*
  * Operations supported for diskquotas.
  */
@@ -267,9 +264,6 @@ static inline int sb_any_quota_active(struct super_block *sb)
 	return 0;
 }
 
-/* For backward compatibility until we remove all users */
-#define sb_any_quota_enabled(sb) sb_any_quota_active(sb)
-
 /*
  * NO-OP when quota not configured.
  */
-- 
1.5.6

