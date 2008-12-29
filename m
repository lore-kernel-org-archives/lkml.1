Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbYL2TFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbYL2TFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 14:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYL2TEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 14:04:23 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:54079 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbYL2TEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 14:04:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=kYiJ7Fe7ehHAT+lgpBDNu4pYH/8volR64Kn+h+EcxcJH3OOEx2gilVy/sZe3ZJK/zY
         LUIcBZTfSnQHJLymzXJQZHL9kqvh1WqeKXW/DZ8/u9Iy3MWu8D+XxBIls31NTX/NN0BD
         Lg9q2WFdlZe3fZc2kBNGLWy8VoiqIDviFh2zg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 29 Dec 2008 20:04:42 +0100
Message-Id: <20081229190442.1020.69066.sendpatchset@localhost.localdomain>
In-Reply-To: <20081229190415.1020.43119.sendpatchset@localhost.localdomain>
References: <20081229190415.1020.43119.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/6] ide: remove unused ide_hwif_t.sg_mapped field
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove unused ide_hwif_t.sg_mapped field

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    1 -
 1 file changed, 1 deletion(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -819,7 +819,6 @@ typedef struct hwif_s {
 	unsigned	extra_ports;	/* number of extra dma ports */
 
 	unsigned	present    : 1;	/* this interface exists */
-	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
 	unsigned	busy	   : 1; /* serializes devices on a port */
 
 	struct device		gendev;
