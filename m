Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbXC0BCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbXC0BCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 21:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933864AbXC0BCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 21:02:33 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35465 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933883AbXC0BCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:02:32 -0400
Date: Tue, 27 Mar 2007 03:02:37 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make arch/i386/kernel/setup.c:remapped_pgdat_init() static
Message-ID: <20070327010237.GT16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global remapped_pgdat_init() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc4-mm1/arch/i386/kernel/setup.c.old	2007-03-26 15:53:44.000000000 +0200
+++ linux-2.6.21-rc4-mm1/arch/i386/kernel/setup.c	2007-03-26 15:54:00.000000000 +0200
@@ -476,7 +476,7 @@
  *
  * This should all compile down to nothing when NUMA is off.
  */
-void __init remapped_pgdat_init(void)
+static void __init remapped_pgdat_init(void)
 {
 	int nid;
 

