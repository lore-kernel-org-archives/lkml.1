Return-Path: <linux-kernel-owner+w=401wt.eu-S1750968AbXBTAIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968AbXBTAIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbXBTAIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:08:18 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36128 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965580AbXBTAHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:52 -0500
Date: Tue, 20 Feb 2007 01:07:51 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] drivers/mmc/Kconfig source drivers/mmc/card/Kconfig
Message-ID: <20070220000751.GE13958@stusta.de>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 09:51:46PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm1:
>...
>  git-mmc.patch
>...
>  git trees
>...

 
The MMC_BLOCK option was accidentally lost.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/drivers/mmc/Kconfig.old	2007-02-19 01:33:27.000000000 +0100
+++ linux-2.6.20-mm2/drivers/mmc/Kconfig	2007-02-19 01:33:45.000000000 +0100
@@ -19,6 +19,7 @@
 	  This is an option for use by developers; most people should
 	  say N here.  This enables MMC core and driver debugging.
 
+source "drivers/mmc/card/Kconfig"
 source "drivers/mmc/host/Kconfig"
 
 endmenu

