Return-Path: <linux-kernel-owner+w=401wt.eu-S1764217AbXG2O5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764217AbXG2O5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764048AbXG2O4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:56:51 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47751 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764035AbXG2O4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:56:50 -0400
Date: Sun, 29 Jul 2007 16:56:27 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] arch/i386/mach-generic/probe.c: make struct apic_probe
	static
Message-ID: <20070729145627.GD16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct apic_probe static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 6 Jul 2007

--- linux-2.6.22-rc6-mm1/arch/i386/mach-generic/probe.c.old	2007-07-05 15:55:40.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/i386/mach-generic/probe.c	2007-07-05 15:55:51.000000000 +0200
@@ -22,7 +22,7 @@
 
 struct genapic *genapic = &apic_default;
 
-struct genapic *apic_probe[] __initdata = { 
+static struct genapic *apic_probe[] __initdata = { 
 	&apic_summit,
 	&apic_bigsmp, 
 	&apic_es7000,

