Return-Path: <linux-kernel-owner+w=401wt.eu-S1030254AbXDIV0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254AbXDIV0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXDIVXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:23:50 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:26809 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965921AbXDIVXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:23:21 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 9/18] ARM: OMAP: Fix gpmc header
Date: Mon,  9 Apr 2007 17:22:14 -0400
Message-Id: <1176153781321-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761537743905-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com> <11761537522665-git-send-email-tony@atomide.com> <11761537563620-git-send-email-tony@atomide.com> <11761537613625-git-send-email-tony@atomide.com> <11761537672719-git-send-email-tony@atomide.com> <1176153771729-git-send-email-tony@atomide.com> <11761537743905-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix gpmc header

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 include/asm-arm/arch-omap/gpmc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: linux-2.6/include/asm-arm/arch-omap/gpmc.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/gpmc.h	2007-04-09 14:22:43.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/gpmc.h	2007-04-09 14:46:49.000000000 -0400
@@ -87,7 +87,7 @@ extern int gpmc_cs_calc_divider(int cs, 
 extern int gpmc_cs_set_timings(int cs, const struct gpmc_timings *t);
 extern int gpmc_cs_request(int cs, unsigned long size, unsigned long *base);
 extern void gpmc_cs_free(int cs);
-extern void gpmc_cs_set_reserved(int cs, int reserved);
+extern int gpmc_cs_set_reserved(int cs, int reserved);
 extern int gpmc_cs_reserved(int cs);
 
 #endif
