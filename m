Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYGJKUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYGJKUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 06:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYGJKUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 06:20:08 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:48381 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYGJKUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:20:07 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3SCP4-02-GW8-01
In-Reply-To: <20080710095757.GB5607@erda.amd.com>
References: <20080710095757.GB5607@erda.amd.com>
From: Robert Richter <robert.richter@amd.com>
Subject: [PATCH] x86/pci: Fix build error for X86_VISWS
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Message-ID: <20080710101949.EBC668403@erda.amd.com>
Date: Thu, 10 Jul 2008 12:19:49 +0200
X-OriginalArrivalTime: 10 Jul 2008 10:19:51.0078 (UTC) FILETIME=[7CF92460:01C8E276]
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


