Return-Path: <linux-kernel-owner+w=401wt.eu-S938633AbXG3G3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938633AbXG3G3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 02:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933980AbXG3G3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 02:29:39 -0400
Received: from rex.snapgear.com ([203.143.235.140]:44877 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933942AbXG3G3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 02:29:38 -0400
Date: Mon, 30 Jul 2007 16:28:46 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707300628.l6U6Skbu020346@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] include cacheflush.h in FEC driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include cacheflush.h to get definitions for cache functions used
in this code.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/drivers/net/fec.c linux/drivers/net/fec.c
--- linux-2.6.23-rc1-git2/drivers/net/fec.c	2007-07-26 10:46:14.000000000 +1000
+++ linux/drivers/net/fec.c	2007-07-26 23:09:23.000000000 +1000
@@ -47,6 +47,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
+#include <asm/cacheflush.h>
 
 #if defined(CONFIG_M523x) || defined(CONFIG_M527x) || \
     defined(CONFIG_M5272) || defined(CONFIG_M528x) || \
