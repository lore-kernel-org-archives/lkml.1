Return-Path: <linux-kernel-owner+w=401wt.eu-S965584AbXBTAIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965584AbXBTAIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbXBTAHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:07:48 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36080 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965580AbXBTAHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:24 -0500
Date: Tue, 20 Feb 2007 01:07:23 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Eric Moore <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] make mptspi_target_destroy() static
Message-ID: <20070220000723.GS13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global mptspi_target_destroy() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.20-mm1/drivers/message/fusion/mptspi.c.old	2007-02-18 01:01:26.000000000 +0100
+++ linux-2.6.20-mm1/drivers/message/fusion/mptspi.c	2007-02-18 01:02:04.000000000 +0100
@@ -446,7 +446,7 @@
 	return 0;
 }
 
-void
+static void
 mptspi_target_destroy(struct scsi_target *starget)
 {
 	if (starget->hostdata)

