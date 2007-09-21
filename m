Return-Path: <linux-kernel-owner+w=401wt.eu-S1764112AbXIUUrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764112AbXIUUrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761915AbXIUUow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:44:52 -0400
Received: from mail.suse.de ([195.135.220.2]:50021 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762819AbXIUUov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:51 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: jesper.juhl@gmail.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/45] i386: Clean up duplicate includes in arch/i386/kernel/
Message-Id: <20070921204450.7B32814EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in arch/i386/kernel/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

---
 arch/i386/kernel/pci-dma.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/arch/i386/kernel/pci-dma.c
===================================================================
--- linux.orig/arch/i386/kernel/pci-dma.c
+++ linux/arch/i386/kernel/pci-dma.c
@@ -12,7 +12,6 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <asm/io.h>
 
 struct dma_coherent_mem {
