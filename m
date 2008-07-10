Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbYGJRCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbYGJRCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbYGJRBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:01:18 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:64886 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758273AbYGJRBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:01:17 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3SV9K-01-VJF-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/5] x86/pci: Fix warnings in subsys_initcall functions
Date: Thu, 10 Jul 2008 18:58:25 +0200
Message-ID: <1215709106-9182-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 10 Jul 2008 17:00:50.0711 (UTC) FILETIME=[81A1CA70:01C8E2AE]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/legacy.c |    2 ++
 arch/x86/pci/visws.c  |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index d8b6e92..132876c 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -66,5 +66,7 @@ int __init pci_subsys_init(void)
 	pci_numa_init();
 #endif
 	pcibios_init();
+
+	return 0;
 }
 subsys_initcall(pci_subsys_init);
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index 16e5206..852998b 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -109,5 +109,7 @@ static __init int pci_subsys_init(void)
 {
 	pci_visws_init();
 	pcibios_init();
+
+	return 0;
 }
 subsys_initcall(pci_subsys_init);
-- 
1.5.5.4


