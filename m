Return-Path: <linux-kernel-owner+w=401wt.eu-S935731AbYCEAv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935731AbYCEAv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763410AbYCEAtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:49:20 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2507 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760592AbYCEAtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:49:19 -0500
Subject: [PATCH] include/asm-arm - use angle brackets for includes
From: Joe Perches <joe@perches.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>, Nicolas Pitre <nico@cam.org>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 16:46:18 -0800
Message-Id: <1204677978.5180.90.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.1mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com

include/asm-arm/plat-s3c/uncompress.h |    4 ++--
 include/asm-arm/proc-fns.h            |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-arm/plat-s3c/uncompress.h b/include/asm-arm/plat-s3c/uncompress.h
index b5e6208..19b9eda 100644
--- a/include/asm-arm/plat-s3c/uncompress.h
+++ b/include/asm-arm/plat-s3c/uncompress.h
@@ -27,8 +27,8 @@ static void arch_detect_cpu(void);
 
 /* defines for UART registers */
 
-#include "asm/plat-s3c/regs-serial.h"
-#include "asm/plat-s3c/regs-watchdog.h"
+#include <asm/plat-s3c/regs-serial.h>
+#include <asm/plat-s3c/regs-watchdog.h>
 
 /* working in physical space... */
 #undef S3C2410_WDOGREG
diff --git a/include/asm-arm/proc-fns.h b/include/asm-arm/proc-fns.h
index a4ce457..75ec760 100644
--- a/include/asm-arm/proc-fns.h
+++ b/include/asm-arm/proc-fns.h
@@ -214,9 +214,9 @@
 #ifndef __ASSEMBLY__
 
 #ifndef MULTI_CPU
-#include "asm/cpu-single.h"
+#include <asm/cpu-single.h>
 #else
-#include "asm/cpu-multi32.h"
+#include <asm/cpu-multi32.h>
 #endif
 
 #include <asm/memory.h>


