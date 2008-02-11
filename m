Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbYBKSoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbYBKSoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYBKSoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:44:14 -0500
Received: from elvis.franken.de ([193.175.24.41]:40771 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbYBKSoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:44:13 -0500
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org
Subject: [PATCH] SC26XX: Missing PORT define in serial_core.h
Message-Id: <20080211184050.17B80E3B02@solo.franken.de>
Date: Mon, 11 Feb 2008 19:40:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When submitting the driver for inclusion to 2.6.25 I've missed the change to
serial_core.h. This patch fixes this.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

 include/linux/serial_core.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 1a0b6cf..289942f 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -149,6 +149,8 @@
 /* Freescale ColdFire */
 #define PORT_MCF	78
 
+#define PORT_SC26XX	79
+
 
 /* MN10300 on-chip UART numbers */
 #define PORT_MN10300		80
