Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYIJLVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYIJLVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYIJLVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:21:34 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:27847 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbYIJLVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:21:33 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>, <linux-ext4@vger.kernel.org>
Subject: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
Date: Wed, 10 Sep 2008 14:22:03 +0300
Message-Id: <1221045726-5674-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.5.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/fs.h defines FS_IOC* needed by linux/ext2_fs.h

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-ext4@vger.kernel.org>
---
 include/linux/ext2_fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 2efe7b8..f23ba68 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -18,6 +18,7 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
+#include <linux/fs.h>
 
 /*
  * The second extended filesystem constants/structures
-- 
1.5.6.5.GIT

