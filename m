Return-Path: <linux-kernel-owner+w=401wt.eu-S1762909AbZAWLCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762909AbZAWLCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762088AbZAWLA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:00:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:5663 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762033AbZAWLAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:00:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gtAZVGH5cNpG92fxHKKkICR8meVhWHzpTwzuxjftw/5Kmq2kTPl8TGH8OI+hcB8f3Q
         cZh3TUWPxL0jpqld/OY52bhnmCGyJUqfRTWt+yXE7Nt/u5j+Xxo3DEpycR7cvIQklwbp
         5loI8HLoLeI5YJsYQDoRCia6jh1L5uKeDTvIk=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, gregkh@suse.de, roel.kluin@gmail.com,
       lethal@linux-sh.org, tglx@linutronix.de,
       Magnus Damm <magnus.damm@gmail.com>, mingo@redhat.com,
       akpm@linux-foundation.org
Date: Fri, 23 Jan 2009 19:58:50 +0900
Message-Id: <20090123105850.18779.88018.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
References: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
Subject: [PATCH 007/011] sh: plat_early_device_setup() for sh4a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds sh4a code to register early platform devices
using plat_early_device_setup().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 arch/sh/kernel/cpu/sh4a/setup-sh7343.c |    5 +++++
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c |    5 +++++
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    5 +++++
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |    5 +++++
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c |    5 +++++
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c |    5 +++++
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c |    5 +++++
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c |    5 +++++
 arch/sh/kernel/cpu/sh4a/setup-shx3.c   |    5 +++++
 9 files changed, 45 insertions(+)

--- 0019/arch/sh/kernel/cpu/sh4a/setup-sh7343.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7343.c	2009-01-23 14:26:37.000000000 +0900
@@ -267,6 +267,11 @@ static int __init sh7343_devices_setup(v
 }
 __initcall(sh7343_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7343_devices, ARRAY_SIZE(sh7343_devices));
+}
+
 enum {
 	UNUSED = 0,
 
--- 0019/arch/sh/kernel/cpu/sh4a/setup-sh7366.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7366.c	2009-01-23 14:28:10.000000000 +0900
@@ -223,6 +223,11 @@ static int __init sh7366_devices_setup(v
 }
 __initcall(sh7366_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7366_devices, ARRAY_SIZE(sh7366_devices));
+}
+
 enum {
 	UNUSED=0,
 
--- 0019/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7722.c	2009-01-23 14:25:34.000000000 +0900
@@ -288,6 +288,11 @@ static int __init sh7722_devices_setup(v
 }
 __initcall(sh7722_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7722_devices, ARRAY_SIZE(sh7722_devices));
+}
+
 enum {
 	UNUSED=0,
 
--- 0019/arch/sh/kernel/cpu/sh4a/setup-sh7723.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7723.c	2009-01-23 14:26:02.000000000 +0900
@@ -338,6 +338,11 @@ static int __init sh7723_devices_setup(v
 }
 __initcall(sh7723_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7723_devices, ARRAY_SIZE(sh7723_devices));
+}
+
 enum {
 	UNUSED=0,
 
--- 0010/arch/sh/kernel/cpu/sh4a/setup-sh7763.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7763.c	2009-01-23 14:28:36.000000000 +0900
@@ -155,6 +155,11 @@ static int __init sh7763_devices_setup(v
 }
 __initcall(sh7763_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7363_devices, ARRAY_SIZE(sh7363_devices));
+}
+
 enum {
 	UNUSED = 0,
 
--- 0001/arch/sh/kernel/cpu/sh4a/setup-sh7770.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7770.c	2009-01-23 14:29:14.000000000 +0900
@@ -87,6 +87,11 @@ static int __init sh7770_devices_setup(v
 }
 __initcall(sh7770_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7770_devices, ARRAY_SIZE(sh7770_devices));
+}
+
 void __init plat_irq_setup(void)
 {
 }
--- 0010/arch/sh/kernel/cpu/sh4a/setup-sh7780.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7780.c	2009-01-23 14:29:46.000000000 +0900
@@ -86,6 +86,11 @@ static int __init sh7780_devices_setup(v
 }
 __initcall(sh7780_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7780_devices, ARRAY_SIZE(sh7780_devices));
+}
+
 enum {
 	UNUSED = 0,
 
--- 0010/arch/sh/kernel/cpu/sh4a/setup-sh7785.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7785.c	2009-01-23 14:30:02.000000000 +0900
@@ -121,6 +121,11 @@ static int __init sh7785_devices_setup(v
 }
 __initcall(sh7785_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7785_devices, ARRAY_SIZE(sh7785_devices));
+}
+
 enum {
 	UNUSED = 0,
 
--- 0010/arch/sh/kernel/cpu/sh4a/setup-shx3.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-shx3.c	2009-01-23 14:30:29.000000000 +0900
@@ -88,6 +88,11 @@ static int __init shx3_devices_setup(voi
 }
 __initcall(shx3_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(shx3_devices, ARRAY_SIZE(shx3_devices));
+}
+
 enum {
 	UNUSED = 0,
 
