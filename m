Return-Path: <linux-kernel-owner+w=401wt.eu-S1763102AbYBHMXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763102AbYBHMXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 07:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758208AbYBHMWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 07:22:49 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:53086 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471AbYBHMWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 07:22:47 -0500
From: Andi Kleen <ak@suse.de>
References: <20080208122.996401758@suse.de>
In-Reply-To: <20080208122.996401758@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/2] Fix and simplify k8.c Kconfig dependencies
Message-Id: <20080208122245.071CE1B41BB@basil.firstfloor.org>
Date: Fri,  8 Feb 2008 13:22:45 +0100 (CET)
X-OriginalArrivalTime: 08 Feb 2008 12:16:24.0827 (UTC) FILETIME=[6C5ECCB0:01C86A4C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Check for K8_NUMA instead of NUMA && PCI
- No need to check for x86_64 explicitely

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -1540,7 +1540,7 @@ endif # X86_32
 
 config K8_NB
 	def_bool y
-	depends on AGP_AMD64 || (X86_64 && (GART_IOMMU || (PCI && NUMA)))
+	depends on AGP_AMD64 || GART_IOMMU || K8_NUMA
 
 source "drivers/pcmcia/Kconfig"
 
