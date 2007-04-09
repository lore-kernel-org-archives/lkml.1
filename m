Return-Path: <linux-kernel-owner+w=401wt.eu-S965854AbXDIVYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965854AbXDIVYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965912AbXDIVYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:24:31 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:27441 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965915AbXDIVYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:24:04 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 17/18] ARM: OMAP: restore CONFIG_GENERIC_TIME
Date: Mon,  9 Apr 2007 17:22:22 -0400
Message-Id: <1176153807215-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176153804679-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com> <11761537522665-git-send-email-tony@atomide.com> <11761537563620-git-send-email-tony@atomide.com> <11761537613625-git-send-email-tony@atomide.com> <11761537672719-git-send-email-tony@atomide.com> <1176153771729-git-send-email-tony@atomide.com> <11761537743905-git-send-email-tony@atomide.com> <1176153781321-git-send-email-tony@atomide.com> <1176153783637-git-send-email-tony@atomide.com> <11761537863183-git-send-email-tony@atomide.com> <117615378995-git-send-email-tony@atomide.com> <11761537921036-git-send-email-tony@atomide.com> <11761537971468-git-send-email-tony@atomide.com> <11761538013111-git-send-email-tony@atomide.com> <1176153804679-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

Somehow this got lost in a merge ...

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -363,6 +363,7 @@ config ARCH_LH7A40X
 config ARCH_OMAP
 	bool "TI OMAP"
 	select GENERIC_GPIO
+	select GENERIC_TIME
 	help
 	  Support for TI's OMAP platform (OMAP1 and OMAP2).
 
-- 
1.4.4.2

