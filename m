Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbYCEQsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbYCEQsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbYCEQrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:47:55 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3276 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbYCEQry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:47:54 -0500
Subject: Re: [PATCH] include/asm-arm - use angle brackets for includes
From: Joe Perches <joe@perches.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>
Cc: Nicolas Pitre <nico@cam.org>, linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1204677978.5180.90.camel@localhost>
References: <1204677978.5180.90.camel@localhost>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 08:44:13 -0800
Message-Id: <1204735453.17370.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.1mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signature too...

Signed-off-by: Joe Perches <joe@perches.com>

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


