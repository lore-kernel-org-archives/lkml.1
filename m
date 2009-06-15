Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZFOOQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZFOOQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZFOOQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:16:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:14408 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbZFOOQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:16:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,222,1243839600"; 
   d="scan'208";a="524694632"
Date: Mon, 15 Jun 2009 22:16:13 +0800
From: Yan Li <yan.i.li@intel.com>
To: linux-input@vger.kernel.org
Cc: yanli@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, greg@kroah.com
Subject: [PATCH] More i8042-reset quirks for MSI Wind-clone netbooks
Message-ID: <20090615141613.GA7876@sage.bj.intel.com>
Mail-Followup-To: linux-input@vger.kernel.org, yanli@infradead.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	greg@kroah.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When testing Moblin on various netbooks, we've got reports that many
MSI Wind clones need the i8042 reset quirks for the keyboard and/or
touchpad's proper function.

Signed-off-by: Yan Li <yan.i.li@intel.com>
---
 drivers/input/serio/i8042-x86ia64io.h |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index fb8a3cd..924e8ed 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -392,6 +392,34 @@ static struct dmi_system_id __initdata i8042_dmi_reset_table[] = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LG Electronics Inc."),
 		},
 	},
+	{
+		.ident = "Acer Aspire One 150",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
+		},
+	},
+	{
+		.ident = "Advent 4211",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "DIXONSXP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Advent 4211"),
+		},
+	},
+	{
+		.ident = "Medion Akoya Mini E1210",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E1210"),
+		},
+	},
+	{
+		.ident = "Mivvy M310",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "VIOOO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N10"),
+		},
+	},
 	{ }
 };
 
-- 
1.6.3.1


-- 
Best regards,
Li, Yan

Moblin Team, Opensource Technology Center, SSG, Intel
Office tel.: +86-10-82171695 (inet: 8-758-1695)
OpenPGP key: 5C6C31EF
IRC: yanli on network irc.freenode.net
