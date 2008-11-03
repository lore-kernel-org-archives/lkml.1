Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYKCTu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYKCTu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbYKCTuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:50:15 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:37054 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbYKCTuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:50:14 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: akpm@linux-foundation.org, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alan@redhat.com
Subject: [PATCH/v2] linux/serial.h: pull in linux/types.h for userspace
Date: Mon,  3 Nov 2008 14:50:12 -0500
Message-Id: <1225741812-13388-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c26c56c0f40e200e61d1390629c806f6adaffbcc added a struct to the
linux/serial.h header for userspace that uses __u32, so we should make sure
we pull in linux/types.h all the time.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
- better changelog this time ...

 include/linux/serial.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/serial.h b/include/linux/serial.h
index 1ea8d92..9136cc5 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -10,8 +10,9 @@
 #ifndef _LINUX_SERIAL_H
 #define _LINUX_SERIAL_H
 
-#ifdef __KERNEL__
 #include <linux/types.h>
+
+#ifdef __KERNEL__
 #include <asm/page.h>
 
 /*
-- 
1.6.0.3

