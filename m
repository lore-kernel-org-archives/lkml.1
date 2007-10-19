Return-Path: <linux-kernel-owner+w=401wt.eu-S935641AbXJSSdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935641AbXJSSdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764042AbXJSSdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:33:37 -0400
Received: from slackadelic.com ([65.196.224.53]:51340 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759548AbXJSSdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:33:36 -0400
From: Carlos Corbacho <cathectic@slackadelic.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: x86: Add HPET force support for MCP55 (nForce 5) chipsets
Date: Fri, 19 Oct 2007 19:34:15 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Mikko Tiihonen <mikko.tiihonen@iki.fi>
References: <200710190423.31714.cathectic@slackadelic.com> <200710191907.43789.cathectic@slackadelic.com> <alpine.LFD.0.9999.0710192014070.22770@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710192014070.22770@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191934.16585.cathectic@slackadelic.com>
X-slackadelic.com-MailScanner-Information: Please contact the ISP for more information
X-slackadelic.com-MailScanner: Found to be clean
X-slackadelic.com-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0.1, required 4, RDNS_DYNAMIC 0.10)
X-slackadelic.com-MailScanner-From: cathectic@slackadelic.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Corbacho <cathectic@gmail.com>

Add support to force_hpet for all known MCP55 (nForce 5) chipset
LPC bridges.
---
These are the untested nForce 5 chips (taken from Mikko's original 
patch, and checked against pci.ids).

 arch/x86/kernel/quirks.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index df01a1e..8f72148 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -354,6 +354,24 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0050,
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0051,
 			nvidia_force_enable_hpet);
 
+/* LPC bridges */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0360,
+			nvidia_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0361,
+			nvidia_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0362,
+			nvidia_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0363,
+			nvidia_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0364,
+			nvidia_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0365,
+			nvidia_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0366,
+			nvidia_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0367,
+			nvidia_force_enable_hpet);
+
 void force_hpet_resume(void)
 {
 	switch (force_hpet_resume_type) {
-- 
1.5.2.2

