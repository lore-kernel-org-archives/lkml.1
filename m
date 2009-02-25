Return-Path: <linux-kernel-owner+w=401wt.eu-S1762683AbZBYKbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683AbZBYKbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762620AbZBYKbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:31:25 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:24001
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762611AbZBYKbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:31:24 -0500
X-BigFish: VPS-1(z5edJzzzzzz32i6bh66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KFMAK0-01-2ND-01
Date: Wed, 25 Feb 2009 11:30:45 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] x86: update description for memtest boot parameter
Message-ID: <20090225103045.GV6298@alberich.amd.com>
References: <20090225102337.GP6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090225102337.GP6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Feb 2009 10:31:13.0217 (UTC) FILETIME=[2E91CB10:01C99734]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 Documentation/kernel-parameters.txt |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 319785b..8cc4518 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1308,8 +1308,13 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	memtest=	[KNL,X86] Enable memtest
 			Format: <integer>
-			range: 0,4 : pattern number
 			default : 0 <disable>
+			Specifies the number of memtest passes to be
+			performed. Each pass selects another test
+			pattern from a given set of patterns. Memtest
+			fills the memory with this pattern, validates
+			memory contents and reserves bad memory
+			regions that are detected.
 
 	meye.*=		[HW] Set MotionEye Camera parameters
 			See Documentation/video4linux/meye.txt.
-- 
1.6.1.3



