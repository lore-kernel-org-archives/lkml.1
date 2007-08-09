Return-Path: <linux-kernel-owner+w=401wt.eu-S936837AbXHIEn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936837AbXHIEn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 00:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXHIEmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 00:42:35 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:64877 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbXHIEme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 00:42:34 -0400
Message-Id: <20070809044125.115351934@goodmis.org>
References: <20070809043626.830486783@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 09 Aug 2007 00:36:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>,
       Andi Kleen <ak@suse.de>
Subject: [PATCH 2/5 -v2] Change lguest launcher to use asm generic include
Content-Disposition: inline; filename=0002-Change-lguest-launcher-to-use-asm-generic-include.txt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Have the lguest launcher include e820.h via asm/e820.h instead of explicitly
saying i386.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/lguest/lguest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index f791840..eb7a01c 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -46,7 +46,7 @@ typedef uint32_t u32;
 typedef uint16_t u16;
 typedef uint8_t u8;
 #include "../../include/linux/lguest_launcher.h"
-#include "../../include/asm-i386/e820.h"
+#include "../../include/asm/e820.h"
 /*:*/
 
 #define PAGE_PRESENT 0x7 	/* Present, RW, Execute */
-- 
1.4.4.4

-- 
