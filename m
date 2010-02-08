Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab0BHKbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:31:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57010 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753773Ab0BHKbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:31:47 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 3/3] nozomi: Tidy up the PCI table
To: greg@kroah.com, linux-kernel@vger.kernel.org, p.hardwick@option.com
Date: Mon, 08 Feb 2010 10:07:15 +0000
Message-ID: <20100208100710.2794.73323.stgit@localhost.localdomain>
In-Reply-To: <20100208100642.2794.73225.stgit@localhost.localdomain>
References: <20100208100642.2794.73225.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/nozomi.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)


diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index fac9157..86c9e64 100644
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
+	{PCI_DEVICE(0x1931, 0x000c)},	/* Nozomi HSPDA */
 	{},
 };
 

