Return-Path: <linux-kernel-owner+w=401wt.eu-S1765050AbYEUAtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765050AbYEUAtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764531AbYEUAsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:48:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41614 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764192AbYEUAsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:48:33 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 3/6][uml] fix hppfs Makefile breakage
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1JycVM-00065v-KC@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:48:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Fallout from commit 46d7b522ebf486edbd096965d534cc6465e9e309
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Jeff Dike <jdike@addtoit.com>
---
 fs/hppfs/Makefile |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/hppfs/Makefile b/fs/hppfs/Makefile
index 8a1f503..3a982bd 100644
--- a/fs/hppfs/Makefile
+++ b/fs/hppfs/Makefile
@@ -3,7 +3,4 @@
 # Licensed under the GPL
 #
 
-hppfs-objs := hppfs.o
-
-obj-y =
-obj-$(CONFIG_HPPFS) += $(hppfs-objs)
+obj-$(CONFIG_HPPFS) += hppfs.o
-- 
1.5.3.GIT

