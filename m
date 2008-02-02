Return-Path: <linux-kernel-owner+w=401wt.eu-S934258AbYBBUEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbYBBUEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759602AbYBBUEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:04:16 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:36306 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbYBBUEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:04:15 -0500
Message-ID: <47A4CCB7.9010703@tiscali.nl>
Date: Sat, 02 Feb 2008 21:04:07 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: thomas@winischhofer.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] [video/sis/sis_main.c] add parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'!' has a higher priority than '&': bitanding has no effect.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 93ae747..5b28fa2 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -427,7 +427,7 @@ sisfb_interpret_edid(struct sisfb_monitor *monitor, u8 *buffer)
 
 	monitor->feature = buffer[0x18];
 
-	if(!buffer[0x14] & 0x80) {
+	if(!(buffer[0x14] & 0x80)) {
 		if(!(buffer[0x14] & 0x08)) {
 			printk(KERN_INFO
 				"sisfb: WARNING: Monitor does not support separate syncs\n");

