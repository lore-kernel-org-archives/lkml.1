Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbYC2DLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbYC2DLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760052AbYC2DJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:09:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50089 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760047AbYC2DJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:09:39 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] dma_page_list ->base_address is a userland pointer
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JfRRq-0002r1-KV@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:09:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/dmaengine.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 261e43a..34d4406 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -423,7 +423,7 @@ void dma_async_device_unregister(struct dma_device *device);
 /* --- Helper iov-locking functions --- */
 
 struct dma_page_list {
-	char *base_address;
+	char __user *base_address;
 	int nr_pages;
 	struct page **pages;
 };
-- 
1.5.3.GIT


