Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbZFBNif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbZFBNif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZFBNi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:38:28 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:11189 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZFBNi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:38:28 -0400
X-SpamScore: 9
X-BigFish: VPS9(z1857r34a4jz4015Lzz1202hzzz32i17ch6bh63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KKM5VP-02-FZS-01
Date: Tue, 2 Jun 2009 15:37:31 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: add description for check_enable_amd_mmconf boot
	parameter
Message-ID: <20090602133731.GC5736@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 02 Jun 2009 13:38:16.0834 (UTC) FILETIME=[626F9620:01C9E387]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 Documentation/kernel-parameters.txt |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

Patch is against tip/master.
Please apply.

Thanks,

Andreas


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 8df6dcd..273824a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1732,6 +1732,9 @@ and is between 256 and 4096 characters. It is defined in the file
 				root domains (aka PCI segments, in ACPI-speak).
 		nommconf	[X86] Disable use of MMCONFIG for PCI
 				Configuration
+		check_enable_amd_mmconf [X86] check for and enable
+				properly configured MMIO access to PCI
+				config space on AMD family 10h CPU
 		nomsi		[MSI] If the PCI_MSI kernel config parameter is
 				enabled, this kernel boot option can be used to
 				disable the use of MSI interrupts system-wide.
-- 
1.6.3.1



