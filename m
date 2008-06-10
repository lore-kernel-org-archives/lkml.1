Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYFJUys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYFJUys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758446AbYFJUvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:51:45 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:24509 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632AbYFJUvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=c9DB0FdveaMo8J1Af9fd11wl9Mcw+TetEoOE1yrjvW0stwCPAl5BZHor/HD9vfzcZk
         K7wd8mRlTdIm1sN8sxFb8ykpZqBRzSmvhqPnm9fSsMeI1T1w5Fl7hiyKppv+FAl91V7v
         JE+vLEg2tSoi+DEsim4UaHm2evNZChw1YssvI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:53:15 +0200
Message-Id: <20080610205315.18469.27468.sendpatchset@localhost.localdomain>
In-Reply-To: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
References: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/14] ide: remove needless includes from setup-pci.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/setup-pci.c |    5 -----
 1 file changed, 5 deletions(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -6,19 +6,14 @@
  *  May be copied or modified under the terms of the GNU General Public License
  */
 
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/init.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/ide.h>
-#include <linux/dma-mapping.h>
 
 #include <asm/io.h>
-#include <asm/irq.h>
 
 /**
  *	ide_setup_pci_baseregs	-	place a PCI IDE controller native
