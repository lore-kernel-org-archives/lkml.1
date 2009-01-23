Return-Path: <linux-kernel-owner+w=401wt.eu-S1762386AbZAWLBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762386AbZAWLBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756990AbZAWLAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:00:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:5663 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761734AbZAWLAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:00:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=R6BsAJVDW/zjdIHs0tMiIjQ3xZr3eMsdZxJG9f7z7WM31lrxCctA3UtNIT7P1HTfbn
         kU8AO7BJhA5ynUeKfLHW7BottbN3bWql/V4hooMoOqoSxyy6Qk6Kpj+j6L3tUlO8vCae
         IMGbkB3kSmZxsWHelh+LqvlBAm1i2Jyk5vGDQ=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, gregkh@suse.de,
       roel.kluin@gmail.com, lethal@linux-sh.org, tglx@linutronix.de,
       mingo@redhat.com, Magnus Damm <magnus.damm@gmail.com>
Date: Fri, 23 Jan 2009 19:58:28 +0900
Message-Id: <20090123105828.18779.18079.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
References: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
Subject: [PATCH 005/011] sh: plat_early_device_setup() for sh3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds sh3 code to register early platform devices
using plat_early_device_setup().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 arch/sh/kernel/cpu/sh3/setup-sh7705.c |    5 +++++
 arch/sh/kernel/cpu/sh3/setup-sh770x.c |    5 +++++
 arch/sh/kernel/cpu/sh3/setup-sh7710.c |    5 +++++
 arch/sh/kernel/cpu/sh3/setup-sh7720.c |    5 +++++
 4 files changed, 20 insertions(+)

--- 0012/arch/sh/kernel/cpu/sh3/setup-sh7705.c
+++ work/arch/sh/kernel/cpu/sh3/setup-sh7705.c	2009-01-23 17:05:57.000000000 +0900
@@ -158,6 +158,11 @@ static int __init sh7705_devices_setup(v
 }
 __initcall(sh7705_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7705_devices, ARRAY_SIZE(sh7705_devices));
+}
+
 void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
--- 0012/arch/sh/kernel/cpu/sh3/setup-sh770x.c
+++ work/arch/sh/kernel/cpu/sh3/setup-sh770x.c	2009-01-23 17:06:23.000000000 +0900
@@ -204,6 +204,11 @@ static int __init sh770x_devices_setup(v
 }
 __initcall(sh770x_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh770x_devices, ARRAY_SIZE(sh770x_devices));
+}
+
 void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
--- 0012/arch/sh/kernel/cpu/sh3/setup-sh7710.c
+++ work/arch/sh/kernel/cpu/sh3/setup-sh7710.c	2009-01-23 17:06:48.000000000 +0900
@@ -165,6 +165,11 @@ static int __init sh7710_devices_setup(v
 }
 __initcall(sh7710_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7710_devices, ARRAY_SIZE(sh7710_devices));
+}
+
 void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
--- 0012/arch/sh/kernel/cpu/sh3/setup-sh7720.c
+++ work/arch/sh/kernel/cpu/sh3/setup-sh7720.c	2009-01-23 17:07:03.000000000 +0900
@@ -152,6 +152,11 @@ static int __init sh7720_devices_setup(v
 }
 __initcall(sh7720_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7720_devices, ARRAY_SIZE(sh7720_devices));
+}
+
 enum {
 	UNUSED = 0,
 
