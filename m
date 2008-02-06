Return-Path: <linux-kernel-owner+w=401wt.eu-S1763472AbYBFBHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763472AbYBFBHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 20:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbYBFBHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 20:07:18 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56854 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757714AbYBFBHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 20:07:17 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: dwmw2@infradead.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] mtd maps: document MTD_PHYSMAP module name in kconfig
Date: Tue, 5 Feb 2008 20:03:48 -0500
User-Agent: KMail/1.9.7
Cc: linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802052003.49527.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Help out users by telling them the module name in the Kconfig help when using
the MTD_PHYSMAP option.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index a592fc0..2f15330 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -21,6 +21,9 @@ config MTD_PHYSMAP
 	  particular board as well as the bus width, either statically
 	  with config options or at run-time.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called physmap.
+
 config MTD_PHYSMAP_START
 	hex "Physical start address of flash mapping"
 	depends on MTD_PHYSMAP
