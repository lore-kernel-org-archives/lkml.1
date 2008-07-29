Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbYG2Pp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbYG2Pp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYG2Poc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:44:32 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:19741 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848AbYG2Pob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:44:31 -0400
X-BigFish: VPS5(zz1cddkzz10d3izzz32i65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0K4RYDS-02-I3R-01
Message-ID: <20080729154145.463988738@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Tue, 29 Jul 2008 17:41:04 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Oruba <peter.oruba@amd.com>
Subject: [patch 1/4] x86: AMD microcode patch loader style corrections.
References: <20080729154103.007575982@amd.com>
Content-Disposition: inline;
	filename="0001-x86-AMD-microcode-patch-loader-style-corrections.patch"
X-OriginalArrivalTime: 29 Jul 2008 15:43:49.0150 (UTC) FILETIME=[E4D0CBE0:01C8F191]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 07e52be..6789530 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -47,9 +47,9 @@ MODULE_LICENSE("GPL v2");
 #define UCODE_UCODE_TYPE           0x00000001
 
 #define UCODE_MAX_SIZE          (2048)
-#define DEFAULT_UCODE_DATASIZE	(896)	  /* 896 bytes */
-#define MC_HEADER_SIZE		(sizeof(struct microcode_header_amd))	  /* 64 bytes */
-#define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE) /* 960 bytes */
+#define DEFAULT_UCODE_DATASIZE	(896)
+#define MC_HEADER_SIZE		(sizeof(struct microcode_header_amd))
+#define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE)
 #define DWSIZE			(sizeof(u32))
 /* For now we support a fixed ucode total size only */
 #define get_totalsize(mc) \
-- 
1.5.4.5




