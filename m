Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbYFIWXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbYFIWXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbYFIWW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:22:58 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46989 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758519AbYFIWW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:22:57 -0400
Date: Tue, 10 Jun 2008 01:22:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] drivers/video/c2p.c: add MODULE_LICENSE
Message-ID: <20080609222202.GB1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing MODULE_LICENSE("GPL").

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/video/c2p.c |    2 ++
 1 file changed, 2 insertions(+)

a616321aca11206e2013d9199400595e6b5f2054 diff --git a/drivers/video/c2p.c b/drivers/video/c2p.c
index 5c30bbd..03ceb1a 100644
--- a/drivers/video/c2p.c
+++ b/drivers/video/c2p.c
@@ -12,6 +12,7 @@
  *  for more details.
  */
 
+#include <linux/module.h>
 #include <linux/string.h>
 #include "c2p.h"
 
@@ -227,3 +228,4 @@ void c2p(u8 *dst, const u8 *src, u32 dx, u32 dy, u32 width, u32 height,
     }
 }
 
+MODULE_LICENSE("GPL");

