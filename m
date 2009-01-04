Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbZADKw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbZADKw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZADKws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:52:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZADKwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:52:47 -0500
Subject: [PATCH -tip] x86: traps.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:20:40 +0530
Message-Id: <1231066240.27852.8.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems

Fixes style problems:
WARNING: Use #include <linux/nmi.h> instead of <asm/nmi.h>
WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
WARNING: Use #include <linux/io.h> instead of <asm/io.h>

total: 0 errors, 3 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/traps.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 18f056a..94dee48 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -66,9 +66,6 @@
 #else
 #include <asm/processor-flags.h>
 #include <asm/arch_hooks.h>
-#include <asm/nmi.h>
-#include <asm/smp.h>
-#include <asm/io.h>
 #include <asm/traps.h>
 
 #include "cpu/mcheck/mce.h"
-- 
1.5.5.1



