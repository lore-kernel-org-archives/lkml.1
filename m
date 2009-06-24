Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbZFXLXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbZFXLXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZFXLXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:23:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:39894 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751517AbZFXLXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:23:00 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+1OSNjOHm1TTS93p2zb/ADBND9eEeYEp8QZYNesq
	CWsHBtqiTpeaBK
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: trivial@kernel.org
Subject: [PATCH] scsi: adding __init/__exit macros to ibmvstgt.c
Date: Wed, 24 Jun 2009 13:22:57 +0200
User-Agent: KMail/1.9.9
Cc: kernel-janitors@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, peterhuewe@gmx.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906241322.58136.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init and __exit macros to the module_init /
module_exit functions from drivers/scsi/ibmvscsi/ibmvstgt.c
linux version 2.6.30 - linus git tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
I'm sorry if you receive this message twice - but my first message does 
not seemto be delivered to any of the mailing lists.
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index d5eaf97..30a25da 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -955,7 +955,7 @@ static struct srp_function_template ibmvstgt_transport_functions = {
 	.it_nexus_response = ibmvstgt_it_nexus_response,
 };
 
-static int ibmvstgt_init(void)
+static int __init ibmvstgt_init(void)
 {
 	int err = -ENOMEM;
 
@@ -986,7 +986,7 @@ release_transport:
 	return err;
 }
 
-static void ibmvstgt_exit(void)
+static void __exit ibmvstgt_exit(void)
 {
 	printk("Unregister IBM virtual SCSI driver\n");
 
