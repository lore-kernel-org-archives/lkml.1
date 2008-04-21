Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYDUVfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYDUVfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757197AbYDUVcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:32:39 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49755 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757061AbYDUVch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:32:37 -0400
Date: Tue, 22 Apr 2008 00:32:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport journal_update_superblock
Message-ID: <20080421213206.GM2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused EXPORT_SYMBOL(journal_update_superblock).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 14 Apr 2008
- 31 Mar 2008
- 27 Feb 2008

66cbc7390d66cdeb83a3f81d7ec1ea71d6f6e2c8 foobar
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 3943a89..5c2ebb7 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -68,7 +68,6 @@ EXPORT_SYMBOL(journal_set_features);
 EXPORT_SYMBOL(journal_create);
 EXPORT_SYMBOL(journal_load);
 EXPORT_SYMBOL(journal_destroy);
-EXPORT_SYMBOL(journal_update_superblock);
 EXPORT_SYMBOL(journal_abort);
 EXPORT_SYMBOL(journal_errno);
 EXPORT_SYMBOL(journal_ack_err);

