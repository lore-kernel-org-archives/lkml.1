Return-Path: <linux-kernel-owner+w=401wt.eu-S1765554AbYCEBTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765554AbYCEBTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934417AbYCEBRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:17:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:52775 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934394AbYCEBRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:17:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gECcGOTtSAaqPrJ+JIuRd5akXtKVw79ZK2+0YfSWZeIA5SwNzki9qUPK5KL2pW/XB3UkIU4MEh2J+LfV//fSLlpjo42/ZHKzvQXx3L5ZM32CsBThAF02WLzj6qprOwyosuU5SNsArTRG5pL8x6SN6FjDcbP1QrMoxDQd5hMN5uY=
Subject: [PATCH 5/9] jfs: replace __inline with inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 17:17:18 -0800
Message-Id: <1204679838.5698.71.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/jfs/jfs_dmap.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jfs/jfs_dmap.h b/fs/jfs/jfs_dmap.h
index 11e6d47..1a6eb41 100644
--- a/fs/jfs/jfs_dmap.h
+++ b/fs/jfs/jfs_dmap.h
@@ -61,7 +61,7 @@
  * determine the maximum free string for four (lower level) nodes
  * of the tree.
  */
-static __inline signed char TREEMAX(signed char *cp)
+static inline signed char TREEMAX(signed char *cp)
 {
 	signed char tmp1, tmp2;
 
-- 
1.5.4.3.500.g83a2c


