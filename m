Return-Path: <linux-kernel-owner+w=401wt.eu-S938955AbXGUPvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938955AbXGUPvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761342AbXGUPvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:51:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36675 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300AbXGUPvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:51:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 21 Jul 2007 17:51:22 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: more correct Kconfig dependencies
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20070721202637.8895b426.sfr@canb.auug.org.au>
Message-ID: <tkrat.3fa326cec414becb@s5r6.in-berlin.de>
References: <46A1D752.6070101@s5r6.in-berlin.de>
 <20070721202637.8895b426.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the option SBP2_PHYS_DMA available on all architectures where it
compiles.  This includes x86-64 where I runtime-tested it successfully.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

CONFIG_VIRT_TO_BUS is nice.  Thanks Stephen.

--- a/drivers/ieee1394/Kconfig
+++ b/drivers/ieee1394/Kconfig
@@ -97,7 +97,7 @@ config IEEE1394_SBP2
 
 config IEEE1394_SBP2_PHYS_DMA
 	bool "Enable replacement for physical DMA in SBP2"
-	depends on IEEE1394 && IEEE1394_SBP2 && EXPERIMENTAL && (X86_32 || PPC_32)
+	depends on IEEE1394_SBP2 && VIRT_TO_BUS && EXPERIMENTAL
 	help
 	  This builds sbp2 for use with non-OHCI host adapters which do not
 	  support physical DMA or for when ohci1394 is run with phys_dma=0.

-- 
Stefan Richter
-=====-=-=== -=== =-=-=
http://arcgraph.de/sr/

