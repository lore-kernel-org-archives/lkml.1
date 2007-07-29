Return-Path: <linux-kernel-owner+w=401wt.eu-S1765589AbXG2PFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765589AbXG2PFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764288AbXG2O6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:58:31 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47812 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764245AbXG2O63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:58:29 -0400
Date: Sun, 29 Jul 2007 16:58:06 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mattia Dongili <malattia@linux.it>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make struct sony_nc_ids[] static
Message-ID: <20070729145806.GU16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sony_nc_ids[] can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/misc/sony-laptop.c.old	2007-07-26 16:05:54.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/misc/sony-laptop.c	2007-07-26 16:06:05.000000000 +0200
@@ -845,7 +845,7 @@
 };
 
 /* SNC-only model map */
-struct dmi_system_id sony_nc_ids[] = {
+static struct dmi_system_id sony_nc_ids[] = {
 		{
 			.ident = "Sony Vaio FE Series",
 			.callback = sony_nc_C_enable,

