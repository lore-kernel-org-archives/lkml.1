Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbYAUXUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbYAUXUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758254AbYAUXSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:18:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:43625 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930AbYAUXSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:18:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=sv5LHVueCJQESAkPeq/TR+XURrdZIiMVSqhSKXUu0EqK6Lf1RjuQ8zlSFlw2NeELQUokXK1m0TXJpLKIgJzC1NZxflWfT0lkNSvaaRND/cQequZPym8H+ykQZh1B3sLGpHwIb5rbGiLTtrFC52suUPovctF9F7GWSw+u4ptbscs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:31:23 +0100
Message-Id: <20080121233123.30311.35221.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/16] ide: convert ->straight8 field in ide_hwif_t to bit flag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -488,7 +488,6 @@ typedef struct hwif_s {
 	u8 major;	/* our major number */
 	u8 index;	/* 0 for ide0; 1 for ide1; ... */
 	u8 channel;	/* for dual-port chips: 0=primary, 1=secondary */
-	u8 straight8;	/* Alan's straight 8 check */
 	u8 bus_state;	/* power state of the IDE bus */
 
 	u32 host_flags;
@@ -609,6 +608,7 @@ typedef struct hwif_s {
 	unsigned	reset      : 1;	/* reset after probe */
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
 	unsigned	mmio       : 1; /* host uses MMIO */
+	unsigned	straight8  : 1;	/* Alan's straight 8 check */
 
 	struct device	gendev;
 	struct completion gendev_rel_comp; /* To deal with device release() */
