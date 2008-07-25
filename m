Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYGYOu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYGYOu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYGYOuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:50:06 -0400
Received: from mail-va3.bigfish.com ([216.32.180.114]:34755 "EHLO
	mail171-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751728AbYGYOuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:50:05 -0400
X-BigFish: VPS8(z37d4lzzz10d3izzz32i43j)
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K4KH71-03-NBE-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/5] x86: convert pci-dma.c from round_up to roundup
Date: Fri, 25 Jul 2008 16:48:55 +0200
Message-Id: <1216997339-31427-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com>
References: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jul 2008 14:48:59.0436 (UTC) FILETIME=[925746C0:01C8EE65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index d5b9e11..8f4dbd7 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -82,7 +82,7 @@ void __init dma32_reserve_bootmem(void)
 	 * using 512M as goal
 	 */
 	align = 64ULL<<20;
-	size = round_up(dma32_bootmem_size, align);
+	size = roundup(dma32_bootmem_size, align);
 	dma32_bootmem_ptr = __alloc_bootmem_nopanic(size, align,
 				 512ULL<<20);
 	if (dma32_bootmem_ptr)
-- 
1.5.3.7


