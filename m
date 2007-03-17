Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbXCRACN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbXCRACN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 20:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbXCRACN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 20:02:13 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:40889 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbXCRACL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 20:02:11 -0400
Date: Sun, 18 Mar 2007 00:58:23 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: mike@i-Connect.Net, ballabio_dario@emc.com
Cc: linux-eata@i-Connect.Net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070317235535.16691.87890.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] drivers/scsi/eata_generic.h: Remove FALSE/TRUE defines
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Only included by drivers/scsi/eata_pio.c and it only uses FALSE/TRUE
in comments.


diff --git a/drivers/scsi/eata_generic.h b/drivers/scsi/eata_generic.h
index 635c148..5016af5 100644
--- a/drivers/scsi/eata_generic.h
+++ b/drivers/scsi/eata_generic.h
@@ -18,13 +18,6 @@
  * Misc. definitions			     *
  *********************************************/
 
-#ifndef TRUE
-#define TRUE 1
-#endif
-#ifndef FALSE
-#define FALSE 0
-#endif
-
 #define R_LIMIT 0x20000
 
 #define MAXISA	   4
