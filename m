Return-Path: <linux-kernel-owner+w=401wt.eu-S1751852Ab0AVNA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0AVNA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 08:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931Ab0AVNA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 08:00:57 -0500
Received: from mail.octasic.com ([70.54.254.106]:25729 "EHLO
	MAILEXCH.octasic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0AVNA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 08:00:56 -0500
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jan 2010 08:00:55 EST
Subject: [PATCH] dw_spi_mmio depends on HAVE_CLK
To: Grant Likely <grant.likely@secretlab.ca>
From: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Fri, 22 Jan 2010 07:45:39 -0500
Message-ID: <20100122124515.2619.14103.stgit@station520.octasic.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jan 2010 12:45:40.0061 (UTC) FILETIME=[CD83C0D0:01CA9B60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dw_spi_mmio is dependent on the clock framework. This marks it as such
in Kconfig.


Signed-off-by: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>
---
 drivers/spi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 505f1c2..c1ac092 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -319,7 +319,7 @@ config SPI_DW_PCI
 
 config SPI_DW_MMIO
 	tristate "Memory-mapped io interface driver for DW SPI core"
-	depends on SPI_DESIGNWARE
+	depends on SPI_DESIGNWARE && HAVE_CLK
 
 #
 # There are lots of SPI device types, with sensors and memory

