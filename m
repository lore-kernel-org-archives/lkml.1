Return-Path: <linux-kernel-owner+w=401wt.eu-S1763474AbXGEXY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763474AbXGEXY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763037AbXGEXWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:22:50 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52144 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763026AbXGEXWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:22:49 -0400
Date: Fri, 6 Jul 2007 01:23:19 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] arch/i386/mach-generic/probe.c: make struct apic_probe
	static
Message-ID: <20070705232319.GB3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct apic_probe static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

--- linux-2.6.22-rc6-mm1/arch/i386/mach-generic/probe.c.old	2007-07-05 15:55:40.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/i386/mach-generic/probe.c	2007-07-05 15:55:51.000000000 +0200
@@ -22,7 +22,7 @@
 
 struct genapic *genapic = &apic_default;
 
-struct genapic *apic_probe[] __initdata = { 
+static struct genapic *apic_probe[] __initdata = { 
 	&apic_summit,
 	&apic_bigsmp, 
 	&apic_es7000,

