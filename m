Return-Path: <linux-kernel-owner+w=401wt.eu-S1763310AbXJNSmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763310AbXJNSmG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764016AbXJNSlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:41:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33755 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764008AbXJNSlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:41:20 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ipg: endianness annotations
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com, romieu@fr.zoreil.com
Message-Id: <E1Ih8Ot-0004Cl-89@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:41:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/ipg.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipg.h b/drivers/net/ipg.h
index 1952d0d..e418b90 100644
--- a/drivers/net/ipg.h
+++ b/drivers/net/ipg.h
@@ -776,17 +776,17 @@ enum ipg_regs {
  * TFD field is 64 bits wide.
  */
 struct ipg_tx {
-	u64 next_desc;
-	u64 tfc;
-	u64 frag_info;
+	__le64 next_desc;
+	__le64 tfc;
+	__le64 frag_info;
 };
 
 /* Receive Frame Descriptor. Note, each RFD field is 64 bits wide.
  */
 struct ipg_rx {
-	u64 next_desc;
-	u64 rfs;
-	u64 frag_info;
+	__le64 next_desc;
+	__le64 rfs;
+	__le64 frag_info;
 };
 
 struct SJumbo {
-- 
1.5.3.GIT


