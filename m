Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbYFJW3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbYFJW3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYFJW3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:29:15 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:57836 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbYFJW3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:29:15 -0400
Date: Wed, 11 Jun 2008 01:28:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: takata@linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] m32r: don't offer CONFIG_ISA
Message-ID: <20080610222815.GI11685@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I know no M32R hardware actually has ISA slots.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
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
 

