Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbXICC2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbXICC2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932293AbXICCZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:17 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57606 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbXICCYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:25 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Andrew Morton <akpm@linux-foundation.org>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 04/32] Unionfs: fixed compilation error
Date: Sun,  2 Sep 2007 22:20:27 -0400
Message-Id: <11887860561323-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 include/linux/mm.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d823db0..aee99b6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -20,6 +20,7 @@ struct anon_vma;
 struct file_ra_state;
 struct user_struct;
 struct writeback_control;
+struct super_block;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
-- 
1.5.2.2.238.g7cbf2f2

