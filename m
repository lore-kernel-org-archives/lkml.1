Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYDWK3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYDWK3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYDWK30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:29:26 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:31231 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYDWK30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:29:26 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-2.tower-164.messagelabs.com!1208946558!11545220!2
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: linux-kernel@vger.kernel.org
CC: trivial@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Dave Hansen <haveblue@us.ibm.com>
Subject: [PATCH] remove unused label out_fput
Date: Wed, 23 Apr 2008 12:22:08 +0200
Message-ID: <1208946128-25861-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Apr 2008 10:22:09.0556 (UTC) FILETIME=[E34AB540:01C8A52B]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15866.006
X-TM-AS-Result: No--5.880000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

out_fput was introduced in 18f335aff86913de3c76f88d32c8135c1da62ce6 without
any user.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <haveblue@us.ibm.com>
---
 fs/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index f7062da..3edcc1d 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -307,7 +307,7 @@ sys_fsetxattr(int fd, char __user *name, void __user *value,
 		error = setxattr(dentry, name, value, size, flags);
 		mnt_drop_write(f->f_path.mnt);
 	}
-out_fput:
+
 	fput(f);
 	return error;
 }
-- 
1.5.5.1

