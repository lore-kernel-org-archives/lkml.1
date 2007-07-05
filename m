Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbXGEJgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbXGEJgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbXGEJgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:36:47 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:60285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576AbXGEJgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:36:47 -0400
Subject: [PATCH] slub: don't export static kmem_cache_open
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 11:37:40 +0200
Message-Id: <1183628260.3818.31.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kmem_cache_open is static so shouldn't be exported.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 mm/slub.c |    1 -
 1 file changed, 1 deletion(-)

--- wireless-dev.orig/mm/slub.c	2007-07-05 11:35:51.555640003 +0200
+++ wireless-dev/mm/slub.c	2007-07-05 11:36:03.895640003 +0200
@@ -2016,7 +2016,6 @@ error:
 			s->offset, flags);
 	return 0;
 }
-EXPORT_SYMBOL(kmem_cache_open);
 
 /*
  * Check if a given pointer is valid


