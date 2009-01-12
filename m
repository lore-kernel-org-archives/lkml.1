Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbZALFm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbZALFm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 00:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZALFmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 00:42:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:44396 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZALFmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:42:49 -0500
Message-ID: <496AD835.6000509@kernel.org>
Date: Sun, 11 Jan 2009 21:42:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: include apicnum.h in acpidef.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: clean up

it seems Ingo revert it wrongly.
put it back again

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/apicdef.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6/arch/x86/include/asm/apicdef.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apicdef.h
+++ linux-2.6/arch/x86/include/asm/apicdef.h
@@ -132,12 +132,7 @@
 #define APIC_BASE_MSR	0x800
 #define X2APIC_ENABLE	(1UL << 10)
 
-#ifdef CONFIG_X86_32
-# define MAX_IO_APICS 64
-#else
-# define MAX_IO_APICS 128
-# define MAX_LOCAL_APIC 32768
-#endif
+#include <asm/apicnum.h>
 
 /*
  * All x86-64 systems are xAPIC compatible.
