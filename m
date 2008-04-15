Return-Path: <linux-kernel-owner+w=401wt.eu-S1764072AbYDOCHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764072AbYDOCHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 22:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761271AbYDOCHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 22:07:04 -0400
Received: from exch-gw.rose-hulman.edu ([137.112.8.200]:29763 "EHLO
	EXCH-GW.rose-hulman.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761080AbYDOCHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 22:07:01 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2008 22:07:01 EDT
Date: Tue, 15 Apr 2008 01:51:50 +0000
From: Andy Spencer <spenceal@rose-hulman.edu>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] i8k support for Dell Precisions
Message-ID: <20080415015150.GA5297@a.dhcp.rose-hulman.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 15 Apr 2008 01:51:50.0403 (UTC) FILETIME=[458CBD30:01C89E9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a small patch to make i8k work on Dell Precisions. I have been
using this on my Dell Precision M70 for a while and haven't noticed any
problems.

Please CC me on responses.


diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 8609b82..78c42b2 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -480,6 +480,13 @@ static struct dmi_system_id __initdata i8k_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MP061"),
 		},
 	},
+	{
+		.ident = "Dell Precision",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision"),
+		},
+	},
 	{ }
 };

