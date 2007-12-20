Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbXLTBjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbXLTBjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbXLTBew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:12451 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbXLTBeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VHypE1Bzcs6js6dOnOzX0ZheCA60g6wNP7QZE/J2jZ+125/OyTWjdY6Mb/3pVioWHTDgLNZwHpp22uXCHd0sfbYy/9O1Fo3U2Vs7FC2L+ZxG2IRYFAPhnMo+2TwBs8gOAxDu4nwNqUkFp40z2pJQOpyHh/6VKsmAATYG/5BTGLo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 16/63] ide-cd: remove stale cdrom_transfer_packet_command() comment
Date: Thu, 20 Dec 2007 02:04:25 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200204.25234.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    4 ----
 1 file changed, 4 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -684,10 +684,6 @@ static ide_startstop_t cdrom_start_packe
    by cdrom_start_packet_command.
    HANDLER is the interrupt handler to call when the command completes
    or there's data ready. */
-/*
- * changed 5 parameters to 3 for dvd-ram
- * struct packet_command *pc; now packet_command_t *pc;
- */
 #define ATAPI_MIN_CDB_BYTES 12
 static ide_startstop_t cdrom_transfer_packet_command (ide_drive_t *drive,
 					  struct request *rq,
