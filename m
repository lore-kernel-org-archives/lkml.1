Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbYFJUyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbYFJUyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbYFJUva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:51:30 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:29680 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249AbYFJUv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:51:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=kYws3+skO95BWqwtc1xCxIzVTD2rzwNfScG7mta532X/frgEVN7U4LJjNQlQgkcZFv
         2ebXV7mJzyEWv2lsJg2ivPU0wPZcSDOrgY0jkVSi6NwT+eWm3WHR84+IyNjJMgS9uAEL
         LRNMCPPOdCV4By/QbVuAp8mNUsGt+cOqfhPew=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:52:59 +0200
Message-Id: <20080610205259.18469.50696.sendpatchset@localhost.localdomain>
In-Reply-To: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
References: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/14] ide: remove needless includes from ide-taskfile.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-taskfile.c |   11 -----------
 1 file changed, 11 deletions(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -8,28 +8,17 @@
  *  The big the bad and the ugly.
  */
 
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/major.h>
 #include <linux/errno.h>
-#include <linux/genhd.h>
-#include <linux/blkpg.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
-#include <linux/bitops.h>
-#include <linux/scatterlist.h>
 
-#include <asm/byteorder.h>
-#include <asm/irq.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
