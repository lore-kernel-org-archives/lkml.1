Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbXJXJMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbXJXJMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXJXJMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:12:45 -0400
Received: from ns2.suse.de ([195.135.220.15]:51213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbXJXJMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:12:45 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove bogus default y for DMAR and NET_DMA
Date: Wed, 24 Oct 2007 11:12:39 +0200
User-Agent: KMail/1.9.6
Cc: akpm@osdl.org, shannon.nelson@intel.com, anil.s.keshavamurthy@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710241112.39451.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please queue for next merge. Thanks.

----

No reason I can think of of making them default y
Most people don't have the hardware and with default y they
just pollute lots of configs during make oldconfig.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.24-rc1-hack/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.24-rc1-hack.orig/arch/x86_64/Kconfig
+++ linux-2.6.24-rc1-hack/arch/x86_64/Kconfig
@@ -753,7 +753,6 @@ config PCI_DOMAINS
 config DMAR
 	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
 	depends on PCI_MSI && ACPI && EXPERIMENTAL
-	default y
 	help
 	  DMA remapping (DMAR) devices support enables independent address
 	  translations for Direct Memory Access (DMA) from devices.
Index: linux-2.6.24-rc1-hack/drivers/dma/Kconfig
===================================================================
--- linux-2.6.24-rc1-hack.orig/drivers/dma/Kconfig
+++ linux-2.6.24-rc1-hack/drivers/dma/Kconfig
@@ -43,7 +43,6 @@ comment "DMA Clients"
 config NET_DMA
 	bool "Network: TCP receive copy offload"
 	depends on DMA_ENGINE && NET
-	default y
 	help
 	  This enables the use of DMA engines in the network stack to
 	  offload receive copy-to-user operations, freeing CPU cycles.
