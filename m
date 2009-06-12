Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbZFLLHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbZFLLHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZFLLHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:07:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:53952 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751089AbZFLLH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:07:29 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18ImbJU+bgI0YJCYIfzqLxHCN6IjV37/r71mD9wS9
	XeO8/o9B0vSx49
From: Peter Huewe <PeterHuewe@gmx.de>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH] block: adding __init/__exit macros to DAC960.c
Date: Fri, 12 Jun 2009 13:07:29 +0200
User-Agent: KMail/1.9.9
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906121307.29865.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init and __exit macros to the module_init /
module_exit functions from drivers/block/DAC960.c
linux version 2.6.30

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index f22ed6c..5b4a48b 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -7209,7 +7209,7 @@ static struct pci_driver DAC960_pci_driver = {
 	.remove		= DAC960_Remove,
 };
 
-static int DAC960_init_module(void)
+static int __init DAC960_init_module(void)
 {
 	int ret;
 
@@ -7221,7 +7221,7 @@ static int DAC960_init_module(void)
 	return ret;
 }
 
-static void DAC960_cleanup_module(void)
+static void __exit DAC960_cleanup_module(void)
 {
 	int i;
