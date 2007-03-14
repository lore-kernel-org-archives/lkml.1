Return-Path: <linux-kernel-owner+w=401wt.eu-S1030822AbXCNJXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030822AbXCNJXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030811AbXCNJW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:22:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60503 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030799AbXCNJTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:19:40 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 11/17] cifs endianness annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPe0-0003XE-1f@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:19:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/cifs/cifspdu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 0efdf35..3af7624 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -220,7 +220,7 @@
  */
 #define CIFS_NO_HANDLE        0xFFFF
 
-#define NO_CHANGE_64          0xFFFFFFFFFFFFFFFFULL
+#define NO_CHANGE_64          cpu_to_le64(0xFFFFFFFFFFFFFFFFULL)
 #define NO_CHANGE_32          0xFFFFFFFFUL
 
 /* IPC$ in ASCII */
-- 
1.5.0-rc2.GIT


