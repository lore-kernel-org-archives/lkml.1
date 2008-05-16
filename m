Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbYEPVCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbYEPVCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760855AbYEPVBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:01:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52581 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760755AbYEPVBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:01:51 -0400
Date: Fri, 16 May 2008 22:01:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] fix hppfs Makefile breakage
Message-ID: <20080516210149.GX13907@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Fallout from commit 46d7b522ebf486edbd096965d534cc6465e9e309
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jeff Dike <jdike@addtoit.com>
---
diff --git a/fs/hppfs/Makefile b/fs/hppfs/Makefile
index 8a1f503..3a982bd 100644
--- a/fs/hppfs/Makefile
+++ b/fs/hppfs/Makefile
@@ -3,7 +3,4 @@
 # Licensed under the GPL
 #
 
-hppfs-objs := hppfs.o
-
-obj-y =
-obj-$(CONFIG_HPPFS) += $(hppfs-objs)
+obj-$(CONFIG_HPPFS) += hppfs.o
