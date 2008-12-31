Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYLaMHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYLaMHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 07:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbYLaMHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 07:07:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbYLaMHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 07:07:05 -0500
Subject: [PATCH] x86: nmi.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 17:35:02 +0530
Message-Id: <1230725102.3738.10.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems

Fixes style problems:
WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
WARNING: Use #include <linux/nmi.h> instead of <asm/nmi.h>

total: 0 errors, 2 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/nmi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 8bd1bf9..45a09cc 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -26,11 +26,10 @@
 #include <linux/kernel_stat.h>
 #include <linux/kdebug.h>
 #include <linux/smp.h>
+#include <linux/nmi.h>
 
 #include <asm/i8259.h>
 #include <asm/io_apic.h>
-#include <asm/smp.h>
-#include <asm/nmi.h>
 #include <asm/proto.h>
 #include <asm/timer.h>
 
-- 
1.5.5.1



