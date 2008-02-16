Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbYBPUOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbYBPUOf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbYBPUMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:12:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:14715 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759536AbYBPUMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:12:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=fvxLENRyLuD+B7g8g3kuRkvSnzsqAX612CG+NTCfbU/AB8NWRAGDIXtuiV/g5mAFlsTdcfjKskmspGJQP3G9QQ8h8L1iVcJ+yQz764lzTZjc2obc8ASL9e5xPhMsFMVLEKDUeOqjhMOWbyfLsZ+C4i1bJoQqb2C5p+8+8vpmxM4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 21:27:15 +0100
Message-Id: <20080216202715.25536.60906.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
References: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/9] ht6560b: use driver name for resource allocation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/ht6560b.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -32,6 +32,7 @@
  *  Try:  http://www.maf.iki.fi/~maf/ht6560b/
  */
 
+#define DRV_NAME	"ht6560b"
 #define HT6560B_VERSION "v0.07"
 
 #include <linux/module.h>
@@ -339,7 +340,7 @@ static int __init ht6560b_init(void)
 	hwif = &ide_hwifs[0];
 	mate = &ide_hwifs[1];
 
-	if (!request_region(HT_CONFIG_PORT, 1, hwif->name)) {
+	if (!request_region(HT_CONFIG_PORT, 1, DRV_NAME)) {
 		printk(KERN_NOTICE "%s: HT_CONFIG_PORT not found\n",
 			__FUNCTION__);
 		return -ENODEV;
