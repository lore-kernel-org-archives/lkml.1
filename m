Return-Path: <linux-kernel-owner+w=401wt.eu-S1762021AbXFQTO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021AbXFQTO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760489AbXFQTKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:10:23 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36895 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761237AbXFQTKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:10:14 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 01/16] [PATCH] unionfs section mismatch
Date: Sun, 17 Jun 2007 15:09:08 -0400
Message-Id: <1182107363284-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section marker in header file:

WARNING: fs/unionfs/unionfs.o(.init.text+0x56): Section mismatch: reference to .exit.text:stop_sioq (between 'init_module' and 'init_sioq')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/sioq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/sioq.h b/fs/unionfs/sioq.h
index 55b781e..6d0d01f 100644
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -76,7 +76,7 @@ struct sioq_args {
 
 /* Extern definitions for SIOQ functions */
 extern int __init init_sioq(void);
-extern __exit void stop_sioq(void);
+extern void stop_sioq(void);
 extern void run_sioq(work_func_t func, struct sioq_args *args);
 
 /* Extern definitions for our privilege escalation helpers */
-- 
1.5.2.rc1.165.gaf9b

