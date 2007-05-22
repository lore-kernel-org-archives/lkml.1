Return-Path: <linux-kernel-owner+w=401wt.eu-S1765684AbXEVILz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765684AbXEVILz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758780AbXEVIGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:35 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:62660 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673AbXEVIGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:17 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com,
       Guillaume Thouvenin <guillaume.thouvenin@bull.net>
Subject: [PATCH 12/15] x86-64: Calgary - cleanup of unneeded macros
Date: Tue, 22 May 2007 04:06:01 -0400
Message-Id: <11798211671872-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <11798211673144-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <11798211672108-git-send-email-muli@il.ibm.com> <1179821167481-git-send-email-muli@il.ibm.com> <11798211673003-git-send-email-muli@il.ibm.com> <11798211672822-git-send-email-muli@il.ibm.com> <1179821167443-git-send-email-muli@il.ibm.com> <11798211673144-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@bull.net>

Cleanup unneeded macros used for register space address calculation.
Now we are using the EBDA to find the space address.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@bull.net>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 9efecf3..5ec9be2 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -52,11 +52,6 @@ int use_calgary __read_mostly = 0;
 #define PCI_DEVICE_ID_IBM_CALGARY 0x02a1
 #define PCI_DEVICE_ID_IBM_CALIOC2 0x0308
 
-/* we need these for register space address calculation */
-#define START_ADDRESS           0xfe000000
-#define CHASSIS_BASE            0
-#define ONE_BASED_CHASSIS_NUM   1
-
 /* register offsets inside the host bridge space */
 #define CALGARY_CONFIG_REG	0x0108
 #define PHB_CSR_OFFSET		0x0110 /* Channel Status */
-- 
1.4.4

