Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZHNVpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZHNVpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZHNVp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:45:29 -0400
Received: from kroah.org ([198.145.64.141]:40767 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbZHNVp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:45:28 -0400
Date: Fri, 14 Aug 2009 14:43:08 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Soeren Sonnenburg <bugreports@nn7.de>
Subject: [PATCH] samsung-backlight: Added support for Samsung NC10 laptop
Message-ID: <20090814214308.GA4351@kroah.com>
References: <20090814194815.GA31474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814194815.GA31474@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Info was provided by Soeren Sonnenburg <bugreports@nn7.de>

Cc: Soeren Sonnenburg <bugreports@nn7.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/platform/x86/samsung-backlight.c
+++ b/drivers/platform/x86/samsung-backlight.c
@@ -119,6 +119,15 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 		},
 		.callback = dmi_check_cb,
 	},
+	{
+		.ident = "NC10",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "NC10"),
+			DMI_MATCH(DMI_BOARD_NAME, "NC10"),
+		},
+		.callback = dmi_check_cb,
+	},
 	{ },
 };
 
@@ -144,3 +153,4 @@ MODULE_LICENSE("GPL");
 module_param(offset, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(offset, "The offset into the PCI device for the brightness control");
 MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnN130:*:rnN130:*");
+MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnNC10:*:rnNC10:*");
