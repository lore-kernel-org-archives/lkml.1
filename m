Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbZCaMlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbZCaMlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbZCaMle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:41:34 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:35687 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbZCaMld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=d5b8Buh49GOs7eG0ncXZEpIuUp1Fp5lFIHzwgFJmHu4GEN6smrlI3ZwZlCCYRltzlp
         /Orn+P/wvx9s3dOiO7/EHqguoA71zGd12qMpyZSHGD5Z1UE4hOTsaxlfP9bpJ+SAYOo2
         hhVUcSsgdYOfGofHoHMyHSreFVFewAdQ/r8XM=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mingo@elte.hu, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 2/3] x86, mce: remove duplicated #include
Date: Tue, 31 Mar 2009 20:41:26 +0800
Message-Id: <1238503286-3736-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated #include in arch/x86/kernel/cpu/mcheck/mce_intel_64.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index 57df3d3..552279f 100644
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
1.6.0.4

