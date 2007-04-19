Return-Path: <linux-kernel-owner+w=401wt.eu-S2993146AbXDSHNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993146AbXDSHNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993139AbXDSHIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:08:16 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46311 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161305AbXDSHAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:00:19 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] smbfs: Remove unnecessary allow_signal
Date: Thu, 19 Apr 2007 00:55:58 -0600
Message-Id: <11769658153847-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/smbfs/smbiod.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/smbfs/smbiod.c b/fs/smbfs/smbiod.c
index 3e61b44..67176af 100644
--- a/fs/smbfs/smbiod.c
+++ b/fs/smbfs/smbiod.c
@@ -298,8 +298,6 @@ out:
  */
 static int smbiod(void *unused)
 {
-	allow_signal(SIGKILL);
-
 	VERBOSE("SMB Kernel thread starting (%d) ...\n", current->pid);
 
 	for (;;) {
-- 
1.5.0.g53756

