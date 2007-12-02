Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbXLBMB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbXLBMB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 07:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXLBMA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 07:00:58 -0500
Received: from elvis.franken.de ([193.175.24.41]:58695 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbXLBMA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 07:00:57 -0500
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
cc: wim@iguana.be
Subject: [PATCH] PARTITION: Use DEFAULT_SGI_PARTITION for SGI_PARTION default
Message-Id: <20071202115456.BDBEFC2EB6@solo.franken.de>
Date: Sun,  2 Dec 2007 12:54:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DEFAULT_SGI_PARTITION for SGI_PARTION default

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

Please apply for 2.6.25.

 fs/partitions/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/partitions/Kconfig b/fs/partitions/Kconfig
index a99acd8..cb5f0a3 100644
--- a/fs/partitions/Kconfig
+++ b/fs/partitions/Kconfig
@@ -198,7 +198,7 @@ config LDM_DEBUG
 
 config SGI_PARTITION
 	bool "SGI partition support" if PARTITION_ADVANCED
-	default y if (SGI_IP22 || SGI_IP27 || ((MACH_JAZZ || SNI_RM) && !CPU_LITTLE_ENDIAN))
+	default y if DEFAULT_SGI_PARTITION
 	help
 	  Say Y here if you would like to be able to read the hard disk
 	  partition table format used by SGI machines.
