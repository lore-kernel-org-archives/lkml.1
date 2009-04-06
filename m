Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbZDFJUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbZDFJUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZDFJUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:20:08 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:43505 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbZDFJUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:20:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ddcm2fiEx5hCZWuzSJwNtKRn8veUjM1AeosVIk4XhzB1hPszF9+CIonAPCnDXdo6hc
         bWHnYZWjtKWZ86IzCe3BqMfHzKEdmBISLTa7b4Ev4+/LLha90yv9ChBbtswEwzysKaqb
         6Ntdl0YhpTg3TIIxYsHD7k4nw5DQzY6N0TfO8=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 3/8] x86, mce: remove dupilcated #include
Date: Mon,  6 Apr 2009 17:19:55 +0800
Message-Id: <1239009595-3836-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dupilicated #include in arch/x86/kernel/cpu/mcheck/mce_intel_64.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index d6b72df..aedf976 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -15,7 +15,6 @@
 #include <asm/hw_irq.h>
 #include <asm/idle.h>
 #include <asm/therm_throt.h>
-#include <asm/apic.h>
 
 asmlinkage void smp_thermal_interrupt(void)
 {
-- 
1.6.1.3

