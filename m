Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbXHIAfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbXHIAfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936999AbXHIAeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:34:19 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:39294 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936675AbXHIAeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:34:17 -0400
Message-Id: <20070809003343.829371800@goodmis.org>
References: <20070809003211.373543702@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 20:32:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 5/7] Change lguest launcher to use asm generic include
Content-Disposition: inline; filename=0005-Change-lguest-launcher-to-use-asm-generic-include-instead-of-explicitly.txt
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
