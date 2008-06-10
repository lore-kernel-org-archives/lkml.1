Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbYFJUyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbYFJUyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758199AbYFJUvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:51:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:30333 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680AbYFJUvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:51:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=cbXCZE5Hr/ubZCnVKwcR9Ti0+HvmJ5ng2VIgSCSAU/LRPH2yNEuOG6G+sCryxDySsp
         RSRd9fe/3yDOnV3eFwIHTqQO5kToHYo9JQaw5O/fps3bEhFJ8hY3M7D2qZoa3gD3NLlB
         bt1OARAanRcwRC3SYmS1nYzM4Y7oq1fq15Ihc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:52:49 +0200
Message-Id: <20080610205249.18469.5758.sendpatchset@localhost.localdomain>
In-Reply-To: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
References: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/14] ide: remove needless includes from ide.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |   13 -------------
 1 file changed, 13 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -50,29 +50,16 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/major.h>
 #include <linux/errno.h>
 #include <linux/genhd.h>
-#include <linux/blkpg.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/ide.h>
 #include <linux/completion.h>
-#include <linux/reboot.h>
-#include <linux/cdrom.h>
-#include <linux/seq_file.h>
 #include <linux/device.h>
-#include <linux/bitops.h>
-
-#include <asm/byteorder.h>
-#include <asm/irq.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
 
 
 /* default maximum number of failures */
