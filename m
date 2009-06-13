Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbZFMA4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbZFMA4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbZFMAzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:55:47 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58667 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbZFMAzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:55:45 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] fbdev: Blackfin has __raw I/O accessors, so use them in fb.h
Date: Fri, 12 Jun 2009 20:55:32 -0400
Message-Id: <1244854536-2367-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244854536-2367-1-git-send-email-vapier@gentoo.org>
References: <1244854536-2367-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/fb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/fb.h b/include/linux/fb.h
index 330c4b1..3292a11 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -893,7 +893,7 @@ struct fb_info {
 #define fb_writeq sbus_writeq
 #define fb_memset sbus_memset_io
 
-#elif defined(__i386__) || defined(__alpha__) || defined(__x86_64__) || defined(__hppa__) || defined(__sh__) || defined(__powerpc__) || defined(__avr32__)
+#elif defined(__i386__) || defined(__alpha__) || defined(__x86_64__) || defined(__hppa__) || defined(__sh__) || defined(__powerpc__) || defined(__avr32__) || defined(__bfin__)
 
 #define fb_readb __raw_readb
 #define fb_readw __raw_readw
-- 
1.6.3.1

