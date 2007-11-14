Return-Path: <linux-kernel-owner+w=401wt.eu-S1764054AbXKNGb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764054AbXKNGb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbXKNGbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:31:50 -0500
Received: from lixom.net ([66.141.50.11]:50887 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757676AbXKNGbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:31:49 -0500
Date: Wed, 14 Nov 2007 00:32:46 -0600
From: Olof Johansson <olof@lixom.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH] [2.6.24-rc2-mm1] Fix dependencies for FSL_DMA
Message-ID: <20071114063246.GA6206@lixom.net>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113175906.497a1a6a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[POWERPC] Fix dependencies for FSL_DMA

>From a powerpc allyesconfig build:

drivers/dma/fsldma.c:504: error: implicit declaration of function 'bus_to_virt'



Signed-off-by: Olof Johansson <olof@lixom.net>

Index: mm/drivers/dma/Kconfig
===================================================================
--- mm.orig/drivers/dma/Kconfig
+++ mm/drivers/dma/Kconfig
@@ -36,7 +36,7 @@ config INTEL_IOP_ADMA
 
 config FSL_DMA
 	bool "Freescale MPC85xx/MPC83xx DMA support"
-	depends on PPC
+	depends on PPC && VIRT_TO_BUS
 	select DMA_ENGINE
 	---help---
 	  Enable support for the Freescale DMA engine. Now, it support
