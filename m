Return-Path: <linux-kernel-owner+w=401wt.eu-S1751685AbZIWEvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbZIWEvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 00:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZIWEvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 00:51:47 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41010 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZIWEvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 00:51:46 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] asm-generic/gpio.h: pull in linux/kernel.h for might_sleep()
Date: Wed, 23 Sep 2009 00:51:49 -0400
Message-Id: <1253681509-24799-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asm-generic/gpio.h header uses the might_sleep() macro but doesn't
include the header for it, so any source code that might include
linux/gpio.h before linux/kernel.h can easily lead to a build failure.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/gpio.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index d6c379d..634ec64 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_GENERIC_GPIO_H
 #define _ASM_GENERIC_GPIO_H
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 
-- 
1.6.5.rc1

