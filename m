Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYIBTvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYIBTvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 15:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYIBTtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 15:49:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:9758 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbYIBTtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 15:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=S7RSwXSLANlwk73AdVdBgVLMyG5MPllgn6fQOpfO2Lch+0gmxkeTXsn5IwG3HCA7kD
         fVeWU1gvRxYRYHG+6J1/XBXhEfb9YZULLVxsa+yanmPrIL3RyFNDAnumgcCXfBDhowfK
         7KMaBXI6pGuDvv5ebQGhFlONuTrVTUpksreBk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Sep 2008 21:47:40 +0200
Message-Id: <20080902194740.14564.87638.sendpatchset@localhost.localdomain>
In-Reply-To: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
References: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/8] ide: remove needless includes from ide-dma.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c |    8 --------
 1 file changed, 8 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -28,21 +28,13 @@
  * for supplying a Promise UDMA board & WD UDMA drive for this work!
  */
 
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/ide.h>
-#include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 
 #include <asm/io.h>
-#include <asm/irq.h>
 
 static const struct drive_list_entry drive_whitelist [] = {
 
