Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbZJVWMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbZJVWMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbZJVWM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:12:29 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:51004 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbZJVWMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:12:25 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ubdqS3aXlVRiKW9hgyc0V
Subject: [PATCH 06/10] omap: Fix detection of n8x0
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 22 Oct 2009 15:12:28 -0700
Message-ID: <20091022221228.27408.66649.stgit@localhost>
In-Reply-To: <20091022221013.27408.443.stgit@localhost>
References: <20091022221013.27408.443.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise the machine_is_nokia_n8*() does not work.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Kconfig |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 75b1c7e..aad194f 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -73,9 +73,21 @@ config MACH_OMAP_3430SDP
 	bool "OMAP 3430 SDP board"
 	depends on ARCH_OMAP3 && ARCH_OMAP34XX
 
+config MACH_NOKIA_N800
+       bool
+
+config MACH_NOKIA_N810
+       bool
+
+config MACH_NOKIA_N810_WIMAX
+       bool
+
 config MACH_NOKIA_N8X0
 	bool "Nokia N800/N810"
 	depends on ARCH_OMAP2420
+	select MACH_NOKIA_N800
+	select MACH_NOKIA_N810
+	select MACH_NOKIA_N810_WIMAX
 
 config MACH_NOKIA_RX51
 	bool "Nokia RX-51 board"

