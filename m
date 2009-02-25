Return-Path: <linux-kernel-owner+w=401wt.eu-S1762683AbZBYKcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683AbZBYKcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760802AbZBYKc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:32:29 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:35304 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759761AbZBYKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:32:28 -0500
X-BigFish: VPS1(zzzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KFMALT-01-2O6-01
Date: Wed, 25 Feb 2009 11:31:49 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] x86: memtest: add additional (regular) test patterns
Message-ID: <20090225103149.GW6298@alberich.amd.com>
References: <20090225102337.GP6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090225102337.GP6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Feb 2009 10:32:16.0456 (UTC) FILETIME=[54434C80:01C99734]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/memtest.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 9c52ef1..0bcd788 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -14,6 +14,19 @@ static u64 patterns[] __initdata = {
 	0xffffffffffffffffULL,
 	0x5555555555555555ULL,
 	0xaaaaaaaaaaaaaaaaULL,
+	0x1111111111111111ULL,
+	0x2222222222222222ULL,
+	0x4444444444444444ULL,
+	0x8888888888888888ULL,
+	0x3333333333333333ULL,
+	0x6666666666666666ULL,
+	0x9999999999999999ULL,
+	0xccccccccccccccccULL,
+	0x7777777777777777ULL,
+	0xbbbbbbbbbbbbbbbbULL,
+	0xddddddddddddddddULL,
+	0xeeeeeeeeeeeeeeeeULL,
+	0x7a6c7258554e494cULL, /* yeah ;-) */
 };
 
 static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
-- 
1.6.1.3



