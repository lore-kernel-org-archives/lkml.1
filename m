Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbYGJRBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbYGJRBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYGJRBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:01:05 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:18480 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbYGJRBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:01:03 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3SV9B-01-VJ0-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/5] x86/pci: Fix build error for X86_VISWS
Date: Thu, 10 Jul 2008 18:58:22 +0200
Message-ID: <1215709106-9182-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 10 Jul 2008 17:00:50.0633 (UTC) FILETIME=[8195E390:01C8E2AE]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bb0c0d0..51329ee 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -283,7 +283,7 @@ config X86_VOYAGER
 
 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
-	depends on X86_32 && !PCI
+	depends on X86_32 && PCI
 	help
 	  The SGI Visual Workstation series is an IA32-based workstation
 	  based on SGI systems chips with some legacy PC hardware attached.
-- 
1.5.5.4


