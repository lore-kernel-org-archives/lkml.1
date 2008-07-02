Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbYGBVUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbYGBVUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbYGBVSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:18:32 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:46737 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528AbYGBVS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:18:28 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3EDU0-01-1WY-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 10/11] x86/pci: visws: Renaming pcibios_init()
Date: Wed, 2 Jul 2008 22:50:28 +0200
Message-ID: <1215031829-29124-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 02 Jul 2008 21:17:56.0443 (UTC) FILETIME=[18C7B2B0:01C8DC89]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/visws.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index c2df4e9..c3dc9f2 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -85,7 +85,7 @@ void __init pcibios_update_irq(struct pci_dev *dev, int irq)
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
 }
 
-static int __init pcibios_init(void)
+static int __init pci_visws_init(void)
 {
 	/* The VISWS supports configuration access type 1 only */
 	pci_probe = (pci_probe | PCI_PROBE_CONF1) &
@@ -105,4 +105,4 @@ static int __init pcibios_init(void)
 	return 0;
 }
 
-subsys_initcall(pcibios_init);
+subsys_initcall(pci_visws_init);
-- 
1.5.5.4


