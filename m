Return-Path: <linux-kernel-owner+w=401wt.eu-S1761591AbZAWLBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591AbZAWLBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760875AbZAWLAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:00:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:5663 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761610AbZAWLAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:00:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=D4NckUN590PijB5a5NjWWQ1pZQCy9QGiSIFv5XC0iCiP9Bryuk1w1nn8zJ+M2D7Ouz
         fHNdcMWrY5i/lemTCGp38+FTeUYthUnPYaY0RCVvXsQjnUjMQLd2tsssReRw+Iv5a6G+
         f6SetE5L0Ur2wXbaeObPRDcff08tIpHNPPAP8=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, gregkh@suse.de, roel.kluin@gmail.com,
       lethal@linux-sh.org, tglx@linutronix.de,
       Magnus Damm <magnus.damm@gmail.com>, mingo@redhat.com,
       akpm@linux-foundation.org
Date: Fri, 23 Jan 2009 19:58:16 +0900
Message-Id: <20090123105816.18779.89128.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
References: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
Subject: [PATCH 004/011] sh: plat_early_device_setup() for sh2a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds sh2a code to register early platform devices
using plat_early_device_setup().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 arch/sh/kernel/cpu/sh2a/setup-mxg.c    |    5 +++++
 arch/sh/kernel/cpu/sh2a/setup-sh7201.c |    5 +++++
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c |    5 +++++
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c |    5 +++++
 4 files changed, 20 insertions(+)

--- 0014/arch/sh/kernel/cpu/sh2a/setup-mxg.c
+++ work/arch/sh/kernel/cpu/sh2a/setup-mxg.c	2009-01-23 17:30:02.000000000 +0900
@@ -158,6 +158,11 @@ static int __init mxg_devices_setup(void
 }
 __initcall(mxg_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(mxg_devices, ARRAY_SIZE(mxg_devices));
+}
+
 void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
--- 0014/arch/sh/kernel/cpu/sh2a/setup-sh7201.c
+++ work/arch/sh/kernel/cpu/sh2a/setup-sh7201.c	2009-01-23 17:28:28.000000000 +0900
@@ -397,6 +397,11 @@ static int __init sh7201_devices_setup(v
 }
 __initcall(sh7201_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7201_devices, ARRAY_SIZE(sh7201_devices));
+}
+
 void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
--- 0014/arch/sh/kernel/cpu/sh2a/setup-sh7203.c
+++ work/arch/sh/kernel/cpu/sh2a/setup-sh7203.c	2009-01-23 17:28:47.000000000 +0900
@@ -342,6 +342,11 @@ static int __init sh7203_devices_setup(v
 }
 __initcall(sh7203_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7203_devices, ARRAY_SIZE(sh7203_devices));
+}
+
 void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
--- 0014/arch/sh/kernel/cpu/sh2a/setup-sh7206.c
+++ work/arch/sh/kernel/cpu/sh2a/setup-sh7206.c	2009-01-23 17:29:43.000000000 +0900
@@ -243,6 +243,11 @@ static int __init sh7206_devices_setup(v
 }
 __initcall(sh7206_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7206_devices, ARRAY_SIZE(sh7206_devices));
+}
+
 void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
