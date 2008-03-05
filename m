Return-Path: <linux-kernel-owner+w=401wt.eu-S934462AbYCEBVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934462AbYCEBVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934485AbYCEBRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:17:52 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:28071 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934471AbYCEBRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:17:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=twOaPZhleAMht4L3d4PnsWQA9512VndAKvrOzm9Wv41IqOLh8neQN/YratZix3GmiuqcsiK0yKrMevpDosKnCDyAr36d6+sj7BWW8pB8+ppv5liggiuhZ+hfpG5C6tvlxf1wudaJ3nnLqjPI2BBPvH8B43rpdgB7kyne28fyXRE=
Subject: [PATCH 7/9] ufs: replace __inline with inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 17:17:19 -0800
Message-Id: <1204679840.5698.73.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ufs/swab.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ufs/swab.h b/fs/ufs/swab.h
index 1683d2b..9e343e7 100644
--- a/fs/ufs/swab.h
+++ b/fs/ufs/swab.h
@@ -40,7 +40,7 @@ cpu_to_fs64(struct super_block *sbp, u64 n)
 		return (__force __fs64)cpu_to_be64(n);
 }
 
-static __inline u32
+static inline u32
 fs64_add(struct super_block *sbp, u32 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
@@ -49,7 +49,7 @@ fs64_add(struct super_block *sbp, u32 *n, int d)
 		return *n = cpu_to_be64(be64_to_cpu(*n)+d);
 }
 
-static __inline u32
+static inline u32
 fs64_sub(struct super_block *sbp, u32 *n, int d)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
@@ -58,7 +58,7 @@ fs64_sub(struct super_block *sbp, u32 *n, int d)
 		return *n = cpu_to_be64(be64_to_cpu(*n)-d);
 }
 
-static __inline u32
+static inline u32
 fs32_to_cpu(struct super_block *sbp, __fs32 n)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-- 
1.5.4.3.500.g83a2c


