Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbXGAUZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbXGAUZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758476AbXGAUWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:22:19 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46871 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758852AbXGAUWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:22:17 -0400
Date: Sun, 1 Jul 2007 22:22:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [-mm patch] fix duplicate CONFIG_DMAR Makefile line
Message-ID: <20070701202243.GQ10869@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
> +intel-iommu-intel-iommu-driver.patch
>...
>  Intel IOMMU support
>...


Contrary to popular belief, two identical Makefile lines don't bring any 
advantages.   ;-)

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/drivers/pci/Makefile.old	2007-06-30 03:33:54.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/pci/Makefile	2007-06-30 03:34:04.000000000 +0200
@@ -23,9 +23,6 @@
 # Build Intel IOMMU support
 obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
 
-#Build Intel-IOMMU support
-obj-$(CONFIG_DMAR) += iova.o dmar.o intel-iommu.o
-
 #
 # Some architectures use the generic PCI setup functions
 #

