Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZFMMVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZFMMVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 08:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZFMMVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 08:21:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:50527 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZFMMVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 08:21:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FRcoVWVD9kt9Gc32cPS8o9A5OHW4DFXPjRvYJTACTdz2KbJ/WxlYaADOKf+m9wt2an
         4wlY0D7pmoepxzJS/Km8naAefvKLrG+8AuRajOIYs7WUPLmTFKVPmugGpNUly+Lo0CJd
         1lg78WxjPCJDA4sMdx+thEI4EfZpRDbaiGh0c=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 2/3] x86: remove duplicated #include's
Date: Sat, 13 Jun 2009 20:21:26 +0800
Message-Id: <1244895686-2348-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 arch/x86/kernel/apic/probe_32.c  |   11 -----------
 arch/x86/kernel/apic/summit_32.c |    1 -
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 440a8bc..0c0182c 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -20,23 +20,12 @@
 #include <asm/apic.h>
 #include <asm/setup.h>
 
-#include <linux/threads.h>
-#include <linux/cpumask.h>
-#include <asm/mpspec.h>
-#include <asm/fixmap.h>
-#include <asm/apicdef.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
 #include <linux/smp.h>
-#include <linux/init.h>
 #include <asm/ipi.h>
 
-#include <linux/smp.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/acpi.h>
 #include <asm/e820.h>
-#include <asm/setup.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
 #define DEFAULT_SEND_IPI	(1)
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 344eee4..eafdfbd 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -44,7 +44,6 @@
 #include <asm/ipi.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/init.h>
 #include <linux/gfp.h>
 #include <linux/smp.h>
 
-- 
1.6.1.2

