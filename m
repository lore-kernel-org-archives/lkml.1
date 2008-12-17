Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751712AbYLQRv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbYLQRv7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbYLQRvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:51:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbYLQRvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:51:49 -0500
Subject: [PATCH] x86: process.c declare c1e_remove_cpu before they get used
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 23:20:05 +0530
Message-Id: <1229536205.23068.6.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Included asm/idle.h for c1e_remove_cpu declaration.

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/kernel/process.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f50f8bf..25313de 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -10,6 +10,7 @@
 #include <linux/ftrace.h>
 #include <asm/system.h>
 #include <asm/apic.h>
+#include <asm/idle.h>
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
-- 
1.5.5.1



