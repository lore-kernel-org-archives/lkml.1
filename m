Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYIFBAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYIFBAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 21:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYIFBAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 21:00:31 -0400
Received: from smtp.nokia.com ([192.100.122.233]:45564 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYIFBAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 21:00:31 -0400
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: tony@atomide.com, ext Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH] Add missing macro argument for devm_release_* family
Date: Sat,  6 Sep 2008 04:00:23 +0300
Message-Id: <1220662823-19106-1-git-send-email-Hiroshi.DOYU@nokia.com>
X-Mailer: git-send-email 1.5.5.1.357.g1af8b
X-OriginalArrivalTime: 06 Sep 2008 01:00:24.0195 (UTC) FILETIME=[F182C530:01C90FBB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ext Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 include/linux/ioport.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 22d2115..c813c63 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -158,9 +158,9 @@ extern struct resource * __devm_request_region(struct device *dev,
 				struct resource *parent, resource_size_t start,
 				resource_size_t n, const char *name);
 
-#define devm_release_region(start,n) \
+#define devm_release_region(dev,start,n) \
 	__devm_release_region(dev, &ioport_resource, (start), (n))
-#define devm_release_mem_region(start,n) \
+#define devm_release_mem_region(dev,start,n) \
 	__devm_release_region(dev, &iomem_resource, (start), (n))
 
 extern void __devm_release_region(struct device *dev, struct resource *parent,
-- 
1.5.5.1.357.g1af8b

