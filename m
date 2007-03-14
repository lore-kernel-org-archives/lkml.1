Return-Path: <linux-kernel-owner+w=401wt.eu-S1030748AbXCNJQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030748AbXCNJQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030757AbXCNJQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:16:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60752 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030748AbXCNJQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:16:25 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 9/13] include of asm/pgtable.h in nfsfh is bogus
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPaq-0003Cr-O6@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:16:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


not needed and actually breaks build on frv, while we are at it

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/nfsd/nfsfh.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index c2660cb..8d995bc 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -17,7 +17,6 @@
 #include <linux/stat.h>
 #include <linux/dcache.h>
 #include <linux/mount.h>
-#include <asm/pgtable.h>
 
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
-- 
1.5.0-rc2.GIT


