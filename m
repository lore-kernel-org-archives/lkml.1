Return-Path: <linux-kernel-owner+w=401wt.eu-S1763366AbXJNSfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763366AbXJNSfm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763133AbXJNSe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:34:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47915 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759573AbXJNSez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:34:55 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fs/partitions/sun.c endianness annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1Ih8Ic-00041b-6C@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:34:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/partitions/sun.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/partitions/sun.c b/fs/partitions/sun.c
index 794118d..c95e6a6 100644
--- a/fs/partitions/sun.c
+++ b/fs/partitions/sun.c
@@ -95,8 +95,8 @@ int sun_partition(struct parsed_partitions *state, struct block_device *bdev)
 	 * So that old Linux-Sun partitions continue to work,
 	 * alow the VTOC to be used under the additional condition ...
 	 */
-	use_vtoc = use_vtoc || !(label->vtoc.sanity |
-				 label->vtoc.version | label->vtoc.nparts);
+	use_vtoc = use_vtoc || !(label->vtoc.sanity ||
+				 label->vtoc.version || label->vtoc.nparts);
 	spc = be16_to_cpu(label->ntrks) * be16_to_cpu(label->nsect);
 	for (i = 0; i < nparts; i++, p++) {
 		unsigned long st_sector;
-- 
1.5.3.GIT


