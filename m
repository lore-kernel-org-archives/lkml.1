Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbYIHBBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbYIHBBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 21:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYIHA7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:59:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:6916 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYIHA7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ht+382yLF3Iwo4FDOgso0XIBI/kSi6Isy/I61zFqYXmH8vKNhIr4JxDZ4EhGTuFzBY
         scCMgILmleZLUR6YexJdszZiwNvZXjNn0I1desl4VIAEhlJXIquu86yo+ir5O9jXXJp9
         N5/XyVnjche/5z+gt+d5zLNBw3rzQcTkyFcpo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 8/9] x86: lapic address print out like io apic addr
Date: Sun,  7 Sep 2008 17:58:57 -0700
Message-Id: <1220835538-18280-8-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 0556f37..f3f5085 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1548,7 +1548,7 @@ void __init init_apic_mappings(void)
 		apic_phys = mp_lapic_addr;
 
 	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
 				APIC_BASE, apic_phys);
 
 	/*
-- 
1.5.4.5

