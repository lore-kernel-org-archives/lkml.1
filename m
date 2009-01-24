Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbZAXSpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbZAXSpe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 13:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZAXSpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 13:45:19 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57619 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbZAXSpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 13:45:18 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 Jan 2009 19:45:09 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/7] ieee1394: sbp2: follow up on "ieee1394: inherit ud
 vendor_id from node vendor_id"
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
Message-ID: <tkrat.af7cbda4b5c56b90@s5r6.in-berlin.de>
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -1403,8 +1403,7 @@ static void sbp2_parse_unit_directory(st
 			  "(firmware_revision 0x%06x, vendor_id 0x%06x,"
 			  " model_id 0x%06x)",
 			  NODE_BUS_ARGS(ud->ne->host, ud->ne->nodeid),
-			  workarounds, firmware_revision,
-			  ud->vendor_id ? ud->vendor_id : ud->ne->vendor_id,
+			  workarounds, firmware_revision, ud->vendor_id,
 			  model);
 
 	/* We would need one SCSI host template for each target to adjust

-- 
Stefan Richter
-=====-==--= ---= ==---
http://arcgraph.de/sr/

