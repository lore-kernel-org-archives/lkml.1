Return-Path: <linux-kernel-owner+w=401wt.eu-S1764954AbXKCAV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764954AbXKCAV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762626AbXKCAFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:05:00 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57904 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762618AbXKCAE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:04:59 -0400
Date: Sat, 3 Nov 2007 01:04:35 +0100
From: Adrian Bunk <bunk@kernel.org>
To: trond.myklebust@fys.uio.no
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/nfs/dir.c should #include "internal.h"
Message-ID: <20071103000435.GH4594@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions (in this case nfs_access_cache_shrinker()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d26650fc1c0dbe80a18d94527357af85c5763143 
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 3533453..f697b5c 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -38,6 +38,7 @@
 #include "nfs4_fs.h"
 #include "delegation.h"
 #include "iostat.h"
+#include "internal.h"
 
 /* #define NFS_DEBUG_VERBOSE 1 */
 
