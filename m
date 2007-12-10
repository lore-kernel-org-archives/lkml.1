Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbXLJCv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbXLJCv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbXLJCn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:43:56 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49822 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbXLJCnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:43:33 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 32/42] Unionfs file system magic number
Date: Sun,  9 Dec 2007 21:42:05 -0500
Message-Id: <1197254556824-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 include/linux/magic.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/magic.h b/include/linux/magic.h
index 1fa0c2c..67043ed 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -35,6 +35,8 @@
 #define REISER2FS_SUPER_MAGIC_STRING	"ReIsEr2Fs"
 #define REISER2FS_JR_SUPER_MAGIC_STRING	"ReIsEr3Fs"
 
+#define UNIONFS_SUPER_MAGIC 0xf15f083d
+
 #define SMB_SUPER_MAGIC		0x517B
 #define USBDEVICE_SUPER_MAGIC	0x9fa2
 #define CGROUP_SUPER_MAGIC	0x27e0eb
-- 
1.5.2.2

