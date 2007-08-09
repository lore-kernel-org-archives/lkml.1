Return-Path: <linux-kernel-owner+w=401wt.eu-S933664AbXHIV1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664AbXHIV1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933453AbXHIV0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:26:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:3113 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933409AbXHIV0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:26:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,242,1183359600"; 
   d="scan'208";a="261139732"
Date: Thu, 9 Aug 2007 14:23:48 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: htejun@gmail.com, akpm@linux-foundation.org, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 2/4] increase number of allowable device flags
Message-Id: <20070809142348.9b2f1358.kristen.c.accardi@intel.com>
In-Reply-To: <20070809211800.022150464@intel.com>
References: <20070809211800.022150464@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/include/linux/libata.h
===================================================================
--- 2.6-git.orig/include/linux/libata.h
+++ 2.6-git/include/linux/libata.h
@@ -139,7 +139,7 @@ enum {
 	ATA_DFLAG_FLUSH_EXT	= (1 << 4), /* do FLUSH_EXT instead of FLUSH */
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
-	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
+	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
 	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */

-- 
