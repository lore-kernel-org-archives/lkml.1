Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbXFNWSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbXFNWSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbXFNWQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:16:23 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35400 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757860AbXFNWQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:16:21 -0400
Date: Fri, 15 Jun 2007 00:16:34 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make init/do_mounts.c:root_wait static
Message-ID: <20070614221634.GC3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

root_wait can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/init/do_mounts.c.old	2007-06-14 02:19:22.000000000 +0200
+++ linux-2.6.22-rc4-mm2/init/do_mounts.c	2007-06-14 02:19:47.000000000 +0200
@@ -25,7 +25,7 @@
 int root_mountflags = MS_RDONLY | MS_SILENT;
 char * __initdata root_device_name;
 static char __initdata saved_root_name[64];
-int __initdata root_wait;
+static int __initdata root_wait;
 
 dev_t ROOT_DEV;
 

