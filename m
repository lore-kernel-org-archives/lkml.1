Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbXFCUy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbXFCUy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbXFCUyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:54:03 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52694 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbXFCUyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:54:01 -0400
Date: Sun, 3 Jun 2007 22:54:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Lennart Poettering <mzxreary@0pointer.de>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: [-mm patch] make drivers/firmware/dmi-id.c:dmi_id_init() static
Message-ID: <20070603205404.GO5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global dmi_id_init() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc3-mm1/drivers/firmware/dmi-id.c.old	2007-06-03 22:17:10.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/firmware/dmi-id.c	2007-06-03 22:17:24.000000000 +0200
@@ -161,7 +161,7 @@
 
 extern int dmi_available;
 
-int __init dmi_id_init(void)
+static int __init dmi_id_init(void)
 {
 	int ret, i;
 

