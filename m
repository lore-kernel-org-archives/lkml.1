Return-Path: <linux-kernel-owner+w=401wt.eu-S938725AbXG3GaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938725AbXG3GaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 02:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938375AbXG3G3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 02:29:47 -0400
Received: from rex.snapgear.com ([203.143.235.140]:44880 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937253AbXG3G3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 02:29:42 -0400
Date: Mon, 30 Jul 2007 16:28:57 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707300628.l6U6SvFP020352@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] remove unused config symbol from FEC driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unused CONFIG symbol and its conditional code from FEC driver.
Pointed out by Robert P. J. Day <rpjday@mindspring.com>.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/drivers/net/fec.c linux/drivers/net/fec.c
--- linux-2.6.23-rc1-git2/drivers/net/fec.c	2007-07-26 10:46:14.000000000 +1000
+++ linux/drivers/net/fec.c	2007-07-26 23:09:23.000000000 +1000
 #define	FEC_FLASHMAC	0xf0006006
 #elif defined(CONFIG_GILBARCONAP) || defined(CONFIG_SCALES)
 #define	FEC_FLASHMAC	0xf0006000
-#elif defined (CONFIG_MTD_KeyTechnology)
-#define	FEC_FLASHMAC	0xffe04000
 #elif defined(CONFIG_CANCam)
 #define	FEC_FLASHMAC	0xf0020000
 #elif defined (CONFIG_M5272C3)
