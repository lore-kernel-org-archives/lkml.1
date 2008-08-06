Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYHFPd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYHFPd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758579AbYHFPdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:33:24 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:43051 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758529AbYHFPdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:33:22 -0400
X-BigFish: VPS5(zz1cddkzz10d3izzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K56R70-02-ZRQ-01
Message-ID: <20080806152319.479475593@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Wed, 6 Aug 2008 17:21:19 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 2/5] [PATCH 2/5] x86: Minor correction to header file
References: <20080806152117.198754464@amd.com>
Content-Disposition: inline;
	filename="0002-x86-Minor-correction-to-header-file.patch"
X-OriginalArrivalTime: 06 Aug 2008 15:32:10.0009 (UTC) FILETIME=[97665890:01C8F7D9]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 include/asm-x86/microcode.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
index 072bef1..fb08022 100644
--- a/include/asm-x86/microcode.h
+++ b/include/asm-x86/microcode.h
@@ -1,5 +1,5 @@
-extern int microcode_init(void *opaque, struct module *module);
-extern void microcode_exit(void);
+int microcode_init(void *opaque, struct module *module);
+void microcode_exit(void);
 
 struct microcode_header_intel {
 	unsigned int            hdrver;
-- 
1.5.4.5




