Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYE1VnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYE1VnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbYE1Vm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:42:27 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:42112 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbYE1Vm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:42:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NWfzWNtp0TwBqUcUeGPGmn81hqAy8pyn+Qvr1R95up0sVY8b2pVx4jbpXVdySPCOtBLrf8a2MgHYw9HA+S0ch727UuzkmvmPlycQLUJthIQFPij6768+qHC4H4wsRlvGQndySMhXI6RcpjLq38mROHuYViaTQjgcR/7G+HR55ik=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:39:54 +0200
Message-Id: <20080528213954.16327.43382.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/21] ide: remove needless includes from ide-lib.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-lib.c |   15 ---------------
 1 file changed, 15 deletions(-)

Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -1,26 +1,11 @@
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/interrupt.h>
-#include <linux/major.h>
-#include <linux/errno.h>
-#include <linux/genhd.h>
-#include <linux/blkpg.h>
-#include <linux/slab.h>
-#include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/bitops.h>
 
-#include <asm/byteorder.h>
-#include <asm/irq.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
-
 static const char *udma_str[] =
 	 { "UDMA/16", "UDMA/25",  "UDMA/33",  "UDMA/44",
 	   "UDMA/66", "UDMA/100", "UDMA/133", "UDMA7" };
