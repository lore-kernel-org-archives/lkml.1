Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbXLTBmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbXLTBmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759159AbXLTBf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11752 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708AbXLTBej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=l2yQC8rrccZ/C9kBGPLOUC3zSv0YOJQTmAyyWhoqDvtyE8QzaTaWWgzDyUxtD9RDqJfEgBVGaAsOOVlAKOaUViOHXZ9A80Fn4AQxAcel6yExYal22CA0GrvHg+E3kkgZR3gJy5TLKT/+3lztwuLKac3PWl5jg5W2pKN5ADLg8zA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 34/63] ide-cd: remove duplicate sense keys definitions from ide-cd.h
Date: Thu, 20 Dec 2007 02:19:20 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200219.20219.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ide-cd.c already uses sense keys definitions from <scsi/scsi.h>.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.h |   17 -----------------
 1 file changed, 17 deletions(-)

Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -158,23 +158,6 @@ struct cdrom_info {
  */
 
 /* This stuff should be in cdrom.h, since it is now generic... */
-
-/* ATAPI sense keys (from table 140 of ATAPI 2.6) */
-#define NO_SENSE                0x00
-#define RECOVERED_ERROR         0x01
-#define NOT_READY               0x02
-#define MEDIUM_ERROR            0x03
-#define HARDWARE_ERROR          0x04
-#define ILLEGAL_REQUEST         0x05
-#define UNIT_ATTENTION          0x06
-#define DATA_PROTECT            0x07
-#define BLANK_CHECK             0x08
-#define ABORTED_COMMAND         0x0b
-#define MISCOMPARE              0x0e
-
- 
-
-/* This stuff should be in cdrom.h, since it is now generic... */
 #if VERBOSE_IDE_CD_ERRORS
 
  /* The generic packet command opcodes for CD/DVD Logical Units,
