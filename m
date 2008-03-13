Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYCMBS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYCMBS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 21:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYCMBST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 21:18:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44728 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYCMBST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 21:18:19 -0400
Date: Wed, 12 Mar 2008 18:18:16 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Subject: [PATCH] ibmpex: Update Kconfig to list more supported models
Message-ID: <20080313011816.GB5731@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhanced the list of supported machines.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 368879f..4dc76bc 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -337,8 +337,9 @@ config SENSORS_IBMPEX
 	help
 	  If you say yes here you get support for the temperature and
 	  power sensors in various IBM System X servers that support
-	  PowerExecutive.  So far this includes the x3550, x3650, x3655,
-	  x3755, and certain HS20 blades.
+	  PowerExecutive.  So far this includes the x3350, x3550, x3650,
+	  x3655, and x3755; the x3800, x3850, and x3950 models that have
+	  PCI Express; and some of the HS2x, LS2x, and QS2x blades.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called ibmpex.
