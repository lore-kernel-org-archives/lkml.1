Return-Path: <linux-kernel-owner+w=401wt.eu-S1762166AbYBRUyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762166AbYBRUyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761465AbYBRUwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:52:41 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:56171 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761265AbYBRUwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:52:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TETXq5ZpKh5LNSwD1Z8o26NGGAiwGw6iPMCDI61iAzF9aANFUrOtoBpFterbXUMASkE5oOsZDHPtV0m0hQzITP21gFDs30gCLJ8DqSdFw55kEN1rwpok5FAlo8D5wSqk+mRE4TsZQfaoixKuu8vgAi/FE42kq1266LWFidPsCMI=
Subject: [PATCH 4/6] reiserfs: fix sparse warnings in lbalance.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 12:52:42 -0800
Message-Id: <1203367962.5757.64.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/reiserfs/lbalance.c:629:2: warning: Using plain integer as NULL pointer
fs/reiserfs/lbalance.c:629:2: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/reiserfs/lbalance.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/lbalance.c b/fs/reiserfs/lbalance.c
index 281f806..2837c06 100644
--- a/fs/reiserfs/lbalance.c
+++ b/fs/reiserfs/lbalance.c
@@ -626,7 +626,7 @@ static void leaf_define_dest_src_infos(int shift_mode, struct tree_balance *tb,
 			       "vs-10250: leaf_define_dest_src_infos: shift type is unknown (%d)",
 			       shift_mode);
 	}
-	RFALSE(src_bi->bi_bh == 0 || dest_bi->bi_bh == 0,
+	RFALSE(src_bi->bi_bh == NULL || dest_bi->bi_bh == NULL,
 	       "vs-10260: mode==%d, source (%p) or dest (%p) buffer is initialized incorrectly",
 	       shift_mode, src_bi->bi_bh, dest_bi->bi_bh);
 }
-- 
1.5.4.1.1278.gc75be


