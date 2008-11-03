Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbYKCTA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbYKCTA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYKCTAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:00:12 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46167 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbYKCTAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:00:11 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: akpm@linux-foundation.org, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alan@redhat.com
Subject: [PATCH] linux/serial.h: touchup for userspace
Date: Mon,  3 Nov 2008 14:00:09 -0500
Message-Id: <1225738809-13253-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linux/serial.h header has __u32 in some structs it exports to userspace,
so make sure we pull in linux/types.h all the time.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
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

