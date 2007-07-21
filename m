Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbXGUPDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbXGUPDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936610AbXGUPCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:02:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939078AbXGUPCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=SLI4VBattDFFvPkd4H+5JYRAGsYqouUt+scgUoM4JnXrWwKYsXFdWDfIXddMLgBWzQpCe31/qXzT1dZddme4PEpHz0mY+kg6ijAW88jFqqvz4C9nDRvlbR/BDIU5NpcMUCVV7gSZTrnzCDWp4cbCG90BGpyFBh6fbAIXK+G7m18=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][02/37] Clean up duplicate includes in arch/i386/kernel/
Date: Sat, 21 Jul 2007 17:01:43 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Greg Kroah-Hartman <greg@kroah.com>, Andi Kleen <ak@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211701.44129.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	arch/i386/kernel/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/arch/i386/kernel/pci-dma.c b/arch/i386/kernel/pci-dma.c
index 048f09b..c8a332c 100644
--- a/arch/i386/kernel/pci-dma.c
+++ b/arch/i386/kernel/pci-dma.c
@@ -12,7 +12,6 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <asm/io.h>
 
 struct dma_coherent_mem {
