Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbYG2PqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbYG2PqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbYG2Poi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:44:38 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:25873 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605AbYG2Poh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:44:37 -0400
X-BigFish: VPS14(zz1cddkzz10d3izzz32i43j68o)
X-Spam-TCS-SCL: 7:0
X-WSS-ID: 0K4RYDT-01-3KO-01
Message-ID: <20080729154145.832932580@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Tue, 29 Jul 2008 17:41:06 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Oruba <peter.oruba@amd.com>
Subject: [patch 3/4] x86: Moved function declarations out from AMD microcode patch loader to heade file.
References: <20080729154103.007575982@amd.com>
Content-Disposition: inline;
	filename="0003-x86-Moved-function-declarations-out-from-AMD-microc.patch"
X-OriginalArrivalTime: 29 Jul 2008 15:43:49.0150 (UTC) FILETIME=[E4D0CBE0:01C8F191]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 6789530..2b98e6a 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -56,9 +56,6 @@ MODULE_LICENSE("GPL v2");
 	((((struct microcode_amd *)mc)->hdr.mc_patch_data_len * 28) \
 	 + MC_HEADER_SIZE)
 
-extern int microcode_init(void *opaque, struct module *module);
-extern void microcode_exit(void);
-
 /* serialize access to the physical write */
 static DEFINE_SPINLOCK(microcode_update_lock);
 
-- 
1.5.4.5




