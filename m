Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbXGOUCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbXGOUCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbXGOUAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:00:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39931 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbXGOUAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:00:42 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] pass -msize-long to sparse on s390
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1IAAGn-00055T-Vn@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 21:00:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


s390 is the only 32bit with unsigned long for size_t (usual for those
is unsigned int).  Tell sparse...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/s390/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 68441e0..143ed8e 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -19,7 +19,7 @@ CFLAGS		+= -m31
 AFLAGS		+= -m31
 UTS_MACHINE	:= s390
 STACK_SIZE	:= 8192
-CHECKFLAGS	+= -D__s390__
+CHECKFLAGS	+= -D__s390__ -msize-long
 else
 LDFLAGS		:= -m elf64_s390
 MODFLAGS	+= -fpic -D__PIC__
-- 
1.5.3.GIT


