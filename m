Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYG0NF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYG0NF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 09:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYG0NFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 09:05:47 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50395 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbYG0NFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:05:46 -0400
Date: Sun, 27 Jul 2008 16:05:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: takata@linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] m32r: don't offer CONFIG_ISA
Message-ID: <20080727130510.GM9301@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I know no M32R hardware actually has ISA slots.

And ISA drivers don't compile on M32R.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 11 Jun 2008

ecb434c7ed05067f4fc9fae1b8fc9df1525b5484 diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index de153de..bd96c2e 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -409,11 +409,7 @@ config PCI_DIRECT
 source "drivers/pci/Kconfig"
 
 config ISA
-	bool "ISA support"
-	help
-	  Find out whether you have ISA slots on your motherboard.  ISA is the
-	  name of a bus system, i.e. the way the CPU talks to the other stuff
-	  inside your box.  If you have ISA, say Y, otherwise N.
+	bool
 
 source "drivers/pcmcia/Kconfig"
 

