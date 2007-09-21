Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbXIUUsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbXIUUsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763101AbXIUUoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:44:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:50024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763012AbXIUUoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:54 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: len.brown@intel.com, luming.yu@gmail.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [11/45] x86_64: Remove rogue default m in drivers/video/Kconfig
Message-Id: <20070921204452.985B614F09@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


default m is near always wrong, like here. For some reason ACPI
likes to reintroduce these and I like to immediately squash them again 
before they pollute too many .configs.

Cc: len.brown@intel.com
Cc: luming.yu@gmail.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/video/Kconfig |    1 -
 1 file changed, 1 deletion(-)

Index: linux/drivers/video/Kconfig
===================================================================
--- linux.orig/drivers/video/Kconfig
+++ linux/drivers/video/Kconfig
@@ -14,7 +14,6 @@ config VGASTATE
 
 config VIDEO_OUTPUT_CONTROL
 	tristate "Lowlevel video output switch controls"
-	default m
 	help
 	  This framework adds support for low-level control of the video 
 	  output switch.
