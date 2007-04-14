Return-Path: <linux-kernel-owner+w=401wt.eu-S1161162AbXDNLuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161162AbXDNLuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 07:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161187AbXDNLuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 07:50:40 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:63367 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161162AbXDNLuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 07:50:39 -0400
From: Haavard Skinnemoen <hskinnemoe@atmel.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, roland@redhat.com,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] AVR32 utrace: Add missing includes
Date: Sat, 14 Apr 2007 13:50:20 +0200
Message-Id: <1176551420509-git-send-email-hskinnemoe@atmel.com>
X-Mailer: git-send-email 1.4.4.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Include linux/tracehook.h and linux/utrace.h

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
Don't know why I missed these initially, but this should fix utrace
on avr32.

Andrew, I've rebased my avr32-arch branch so it should no longer
conflict with mainline and you can drop git-avr32-fixup.patch. Thanks
for cleaning up my mess :-)

Haavard

 arch/avr32/kernel/ptrace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/kernel/ptrace.c b/arch/avr32/kernel/ptrace.c
index e7078c5..a485117 100644
--- a/arch/avr32/kernel/ptrace.c
+++ b/arch/avr32/kernel/ptrace.c
@@ -14,6 +14,8 @@
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/kdebug.h>
+#include <linux/tracehook.h>
+#include <linux/utrace.h>
 
 #include <asm/mmu_context.h>
 #include <asm/ocd.h>
-- 
1.4.4.4

