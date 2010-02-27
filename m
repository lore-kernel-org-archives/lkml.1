Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030354Ab0B0Qyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:54:32 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030259Ab0B0Qy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:54:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=mUMV78nz2ftZsdHUc/ypU9w4YwwbSA5BHhkNVvSIx2zFxpqSRAK8eYz8mMlB46Huea
         BKBzcja9ool9Tn7MNAcqnMkBcsu5zlUJ4WTFfYNsk3FaZNdxJ/xMlZkHYRreoyR4wKSZ
         4Tyi7hj6t7gOjgJ1o/5Nn+nFIMftdaXmE1Nnw=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>
Subject: [PATCH 26/66] fs/befs/btree.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:07 +0100
Message-Id: <1267289508-31031-27-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/befs/btree.h:3: ERROR: trailing whitespace
fs/befs/btree.h:12: ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 fs/befs/btree.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/befs/btree.h b/fs/befs/btree.h
index 92e781e..9c85aea 100644
--- a/fs/befs/btree.h
+++ b/fs/befs/btree.h
@@ -1,6 +1,6 @@
 /*
  * btree.h
- * 
+ *
  */
 
 
@@ -9,5 +9,4 @@ int befs_btree_find(struct super_block *sb, befs_data_stream * ds,
 
 int befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 		    loff_t key_no, size_t bufsize, char *keybuf,
-		    size_t * keysize, befs_off_t * value);
-
+		    size_t *keysize, befs_off_t *value);
-- 
1.7.0.90.g251a4

