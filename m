Return-Path: <linux-kernel-owner+w=401wt.eu-S2992729AbXBISNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992729AbXBISNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 13:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992730AbXBISNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 13:13:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54132 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992729AbXBISNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 13:13:42 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] fix misannotation of linkinfo_dn
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Message-Id: <E1HFaFi-0004Nh-3I@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 18:13:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/dn.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dn.h b/include/linux/dn.h
index 10b6a6f..02bba04 100644
--- a/include/linux/dn.h
+++ b/include/linux/dn.h
@@ -113,7 +113,7 @@ struct accessdata_dn
  * DECnet logical link information structure
  */
 struct linkinfo_dn {
-        __le16  idn_segsize;    /* Segment size for link */
+        __u16  idn_segsize;    /* Segment size for link */
         __u8   idn_linkstate;  /* Logical link state    */
 };
 
-- 
1.5.0-rc2.GIT

