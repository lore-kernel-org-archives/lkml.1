Return-Path: <linux-kernel-owner+w=401wt.eu-S1763472AbXG2PFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763472AbXG2PFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764458AbXG2O6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:58:33 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47815 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764440AbXG2O6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:58:32 -0400
Date: Sun, 29 Jul 2007 16:58:09 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Pitre <npitre@mvista.com>, Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make struct sdio_dev_attrs[] static
Message-ID: <20070729145809.GV16817@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
>  git-mmc.patch
>...
>  git trees
>...

sdio_dev_attrs[] can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/mmc/core/sdio_bus.c.old	2007-07-26 16:09:20.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/mmc/core/sdio_bus.c	2007-07-26 16:09:30.000000000 +0200
@@ -45,7 +45,7 @@
 			func->class, func->vendor, func->device);
 }
 
-struct device_attribute sdio_dev_attrs[] = {
+static struct device_attribute sdio_dev_attrs[] = {
 	__ATTR_RO(class),
 	__ATTR_RO(vendor),
 	__ATTR_RO(device),

