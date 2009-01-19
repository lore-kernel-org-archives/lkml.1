Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZASSUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZASSUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZASSUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:20:45 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35033 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZASSUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:20:44 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 19 Jan 2009 19:20:31 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: update a help string
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.33819bde6ef264d0@s5r6.in-berlin.de>
Message-ID: <tkrat.d62aec3ce0ff13f3@s5r6.in-berlin.de>
References: <tkrat.33819bde6ef264d0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -115,8 +115,8 @@
  */
 static int sbp2_max_speed = IEEE1394_SPEED_MAX;
 module_param_named(max_speed, sbp2_max_speed, int, 0644);
-MODULE_PARM_DESC(max_speed, "Force max speed "
-		 "(3 = 800Mb/s, 2 = 400Mb/s, 1 = 200Mb/s, 0 = 100Mb/s)");
+MODULE_PARM_DESC(max_speed, "Limit data transfer speed (5 <= 3200, "
+		 "4 <= 1600, 3 <= 800, 2 <= 400, 1 <= 200, 0 = 100 Mb/s)");
 
 /*
  * Set serialize_io to 0 or N to use dynamically appended lists of command ORBs.

-- 
Stefan Richter
-=====-==--= ---= =--==
http://arcgraph.de/sr/

