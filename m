Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbXFYXyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbXFYXyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 19:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXFYXyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 19:54:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40216 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751942AbXFYXyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 19:54:47 -0400
Date: Tue, 26 Jun 2007 01:55:09 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.22 patch] kconfig help: recommend SLAB
Message-ID: <20070625235509.GG1094@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

During "make oldconfig", the help text only said
  This option allows to select a slab allocator.

This patch adds an
  If unsure, choose SLAB.
which is the safe choice for users wanting to avoid regressions.

It also inckudes an indentation fix.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6/init/Kconfig.old	2007-06-26 01:29:41.000000000 +0200
+++ linux-2.6.22-rc6/init/Kconfig	2007-06-26 01:30:07.000000000 +0200
@@ -556,7 +556,9 @@
 	prompt "Choose SLAB allocator"
 	default SLAB
 	help
-	   This option allows to select a slab allocator.
+	  This option allows to select a slab allocator.
+	  
+	  If unsure, choose SLAB.
 
 config SLAB
 	bool "SLAB"

