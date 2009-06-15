Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbZFOOD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbZFOOD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZFOODV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:03:21 -0400
Received: from legaljet.webserversystems.com ([67.18.134.218]:58898 "EHLO
	compulab.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZFOODV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:03:21 -0400
X-Greylist: delayed 2911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 10:03:21 EDT
Message-ID: <4A364942.8080802@compulab.co.il>
Date: Mon, 15 Jun 2009 16:14:42 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.19 (X11/20090114)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Reboot quirk for sbc-fitpc2 board
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle problems with rebooting on CompuLab SBC-FITPC2 board.

Signed-off by Denis Turischev <denis@compulab.co.il>

--- linux-2.6.30.orig/arch/x86/kernel/reboot.c  2009-06-15
15:34:49.000000000 +0300
+++ linux-2.6.30/arch/x86/kernel/reboot.c       2009-06-15
15:37:07.000000000 +0300
@@ -240,6 +240,14 @@
                        DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
                },
        },
+       {       /* Handle problems with rebooting on CompuLab SBC-FITPC2
board */
+               .callback = set_bios_reboot,
+               .ident = "CompuLab SBC-FITPC2",
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "CompuLab"),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
+               },
+       },
        { }
 };

