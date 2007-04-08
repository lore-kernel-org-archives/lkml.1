Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXDHDiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXDHDiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 23:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXDHDiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 23:38:54 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:53721 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbXDHDix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 23:38:53 -0400
Date: Sat, 7 Apr 2007 23:38:46 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: aeb@cwi.nl
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] partitions: Touch up comments for check.h and ibm.h
In-Reply-To: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
Message-ID: <alpine.DEB.0.83.0704072338060.27057@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Adds top-of-file identifying comments to check.h and ibm.h in 
fs/partitions similar to the other files in the directory. Removes an 
obsolescent comment from check.h leftover from devfs.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

add_gd_partition used to be in check.c for devfs. That identifier no 
longer exists anywhere within the tree.

--- linux-2.6.20.6-orig/fs/partitions/check.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/check.h	2007-04-07 21:26:10.000000000 -0400
@@ -1,10 +1,10 @@
+/*
+ *  fs/partitions/check.h
+ */
+
 #include <linux/pagemap.h>
 #include <linux/blkdev.h>
 
-/*
- * add_gd_partition adds a partitions details to the devices partition
- * description.
- */
 enum { MAX_PART = 256 };
 
 struct parsed_partitions {
--- linux-2.6.20.6-orig/fs/partitions/ibm.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/ibm.h	2007-04-07 22:02:18.000000000 -0400
@@ -1 +1,5 @@
+/*
+ *  fs/partitions/ibm.h
+ */
+
 int ibm_partition(struct parsed_partitions *, struct block_device *);
