Return-Path: <linux-kernel-owner+w=401wt.eu-S965948AbXBOPBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965948AbXBOPBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 10:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965949AbXBOPBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 10:01:20 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57241 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965948AbXBOPBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 10:01:19 -0500
Date: Thu, 15 Feb 2007 16:01:23 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] MARKERS should depend on, not select MODULES
Message-ID: <20070215150123.GA13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm3:
>...
> +linux-kernel-markers-kconfig-menus.patch
>...
>  Linux Kenrel Markers
>...

Never ever select MODULES.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

BTW: Can we get in-kernel users?

--- linux-2.6.20-mm1/kernel/Kconfig.marker.old	2007-02-15 15:54:10.000000000 +0100
+++ linux-2.6.20-mm1/kernel/Kconfig.marker	2007-02-15 15:54:27.000000000 +0100
@@ -2,8 +2,7 @@
 
 config MARKERS
 	bool "Activate markers"
-	select MODULES
-	default n
+	depends on MODULES
 	help
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.

