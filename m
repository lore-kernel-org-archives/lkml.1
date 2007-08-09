Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbXHIUru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbXHIUru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbXHIUrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:47:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:38228 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbXHIUrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,242,1183359600"; 
   d="scan'208";a="261124829"
Subject: [GIT PULL] async_tx: update MAINTAINERS for async_tx and iop-adma
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Shannon Nelson <shannon.nelson@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 09 Aug 2007 13:47:39 -0700
Message-Id: <1186692459.21486.7.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

	git://lost.foo-projects.org/~dwillia2/git/iop async-tx-fixes-for-linus

to receive:

async_tx: update MAINTAINERS for async_tx and iop-adma

Also, rename the dma engine entry since it is now a generic offload engine
subsystem, not just memcpy.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 MAINTAINERS |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e65e96a..fa52a30 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -612,6 +612,15 @@ W:	http://sourceforge.net/projects/acpi4asus
 W:	http://xf.iksaif.net/acpi4asus
 S:	Maintained
 
+ASYNCHRONOUS TRANSFERS/TRANSFORMS API
+P:	Dan Williams
+M:	dan.j.williams@intel.com
+P:	Shannon Nelson
+M:	shannon.nelson@intel.com
+L:	linux-kernel@vger.kernel.org
+W:	http://sourceforge.net/projects/xscaleiop
+S:	Supported
+
 ATA OVER ETHERNET DRIVER
 P:	Ed L. Cashin
 M:	ecashin@coraid.com
@@ -1277,11 +1286,13 @@ M:	tori@unhappy.mine.nu
 L:	netdev@vger.kernel.org
 S:	Maintained
 
-DMA GENERIC MEMCPY SUBSYSTEM
+DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
 P:	Shannon Nelson
 M:	shannon.nelson@intel.com
+P:	Dan Williams
+M:	dan.j.williams@intel.com
 L:	linux-kernel@vger.kernel.org
-S:	Maintained
+S:	Supported
 
 DME1737 HARDWARE MONITOR DRIVER
 P:	Juerg Haefliger
@@ -1958,6 +1969,12 @@ M:	shannon.nelson@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 
+INTEL IOP-ADMA DMA DRIVER
+P:	Dan Williams
+M:	dan.j.williams@intel.com
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net
