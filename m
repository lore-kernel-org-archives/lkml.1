Return-Path: <linux-kernel-owner+w=401wt.eu-S1761073AbYAVDLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073AbYAVDLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758609AbYAVDGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:06:06 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32801 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757198AbYAVDGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:06:04 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 14/49] ext4: export iov_shorten from kernel for ext4's use
Date: Mon, 21 Jan 2008 22:01:53 -0500
Message-Id: <1200970948-17903-15-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-14-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Export iov_shorten() from kernel so that ext4 can
truncate too-large writes to bitmapped files.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/read_write.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index ea1f94c..dfaee3f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -450,6 +450,7 @@ unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to)
 	}
 	return seg;
 }
+EXPORT_SYMBOL(iov_shorten);
 
 ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
 		unsigned long nr_segs, size_t len, loff_t *ppos, iov_fn_t fn)
-- 
1.5.4.rc3.31.g1271-dirty

