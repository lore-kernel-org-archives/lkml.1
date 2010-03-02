Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0CBXq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:46:26 -0500
Received: from kroah.org ([198.145.64.141]:51644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904Ab0CBXhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/36] nozomi: Tidy up the PCI table
Date: Tue,  2 Mar 2010 15:36:36 -0800
Message-Id: <1267573003-782-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/nozomi.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index fac9157..584910f 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -136,10 +136,6 @@ static int debug;
 #define RECEIVE_BUF_MAX		4
 
 
-/* Define all types of vendors and devices to support */
-#define VENDOR1		0x1931	/* Vendor Option */
-#define DEVICE1		0x000c	/* HSDPA card */
-
 #define R_IIR		0x0000	/* Interrupt Identity Register */
 #define R_FCR		0x0000	/* Flow Control Register */
 #define R_IER		0x0004	/* Interrupt Enable Register */
@@ -407,7 +403,7 @@ struct buffer {
 
 /*    Global variables */
 static const struct pci_device_id nozomi_pci_tbl[] __devinitconst = {
-	{PCI_DEVICE(VENDOR1, DEVICE1)},
+	{PCI_DEVICE(0x1931, 0x000c)},	/* Nozomi HSDPA */
 	{},
 };
 
-- 
1.7.0.1

