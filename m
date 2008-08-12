Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYHLIsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYHLIsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 04:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYHLIsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 04:48:03 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:59677 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYHLIsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 04:48:01 -0400
X-BigFish: VPS1(zz3117Kzz10d3izzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5HCFJ-02-6CG-01
Date: Tue, 12 Aug 2008 10:47:41 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] Documentation: describe bootmem_debug kernel parameter
Message-ID: <20080812084741.GC5952@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Aug 2008 08:47:43.0966 (UTC) FILETIME=[163087E0:01C8FC58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

"bootmem_debug" is not mentioned in kernel-parameters.txt. Recently I
had to use that kernel option and I think it should be documented.

Regards,
Andreas


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e7bea3e..a897646 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -365,6 +365,8 @@ and is between 256 and 4096 characters. It is defined in the file
 			no delay (0).
 			Format: integer
 
+	bootmem_debug	[KNL] Enable bootmem allocator debug messages.
+
 	bttv.card=	[HW,V4L] bttv (bt848 + bt878 based grabber cards)
 	bttv.radio=	Most important insmod options are available as
 			kernel args too.
-- 
1.5.6.4



