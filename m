Return-Path: <linux-kernel-owner+w=401wt.eu-S965933AbXDIVZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965933AbXDIVZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965913AbXDIVY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:24:28 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:27461 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965912AbXDIVYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:24:05 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 18/18] ARM: OMAP: Fix GCC-reported compile time bug
Date: Mon,  9 Apr 2007 17:22:23 -0400
Message-Id: <1176153811868-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176153807215-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com> <11761537522665-git-send-email-tony@atomide.com> <11761537563620-git-send-email-tony@atomide.com> <11761537613625-git-send-email-tony@atomide.com> <11761537672719-git-send-email-tony@atomide.com> <1176153771729-git-send-email-tony@atomide.com> <11761537743905-git-send-email-tony@atomide.com> <1176153781321-git-send-email-tony@atomide.com> <1176153783637-git-send-email-tony@atomide.com> <11761537863183-git-send-email-tony@atomide.com> <117615378995-git-send-email-tony@atomide.com> <11761537921036-git-send-email-tony@atomide.com> <11761537971468-git-send-email-tony@atomide.com> <11761538013111-git-send-email-tony@atomide.com> <1176153804679-git-send-email-tony@atomide.com> <1176153807215-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

Fix GCC-reported compile time bug which prevents booting
when the framebuffer code is disabled.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/fb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

--- a/arch/arm/plat-omap/fb.c
+++ b/arch/arm/plat-omap/fb.c
@@ -333,7 +333,10 @@ unsigned long omapfb_reserve_sram(unsign
 				  unsigned long sram_vstart,
 				  unsigned long sram_size,
 				  unsigned long start_avail,
-				  unsigned long size_avail) {}
+				  unsigned long size_avail)
+{
+	return 0;
+}
 
 
 #endif

