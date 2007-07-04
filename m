Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbXGDItW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbXGDItW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbXGDItN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:49:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39905 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbXGDItN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:49:13 -0400
From: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.22-rc7] remove duplicate header include line
Date: Wed, 4 Jul 2007 17:48:32 +0900
User-Agent: KMail/1.9.7
Cc: muneda.takahiro@jp.fujitsu.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041748.35104.muneda.takahiro@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

<linux/pci.h> is included twice. This patch removes the duplication.
I've confirmed the binary file with/without patch is completely same.

Thanks,
MUNE

Remove duplicate header include line from arch/i386/kernel/pci-dma.c

Signed-off-by: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>

---
 arch/i386/kernel/pci-dma.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.22-rc7/arch/i386/kernel/pci-dma.c
===================================================================
--- linux-2.6.22-rc7.orig/arch/i386/kernel/pci-dma.c	2007-07-04 17:09:03.000000000 +0900
+++ linux-2.6.22-rc7/arch/i386/kernel/pci-dma.c	2007-07-04 17:09:14.000000000 +0900
@@ -12,7 +12,6 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <asm/io.h>
 
 struct dma_coherent_mem {

