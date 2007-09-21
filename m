Return-Path: <linux-kernel-owner+w=401wt.eu-S1764433AbXIUUzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764433AbXIUUzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763027AbXIUUp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:26 -0400
Received: from ns2.suse.de ([195.135.220.15]:33006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763375AbXIUUpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:15 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: bunk@stusta.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [31/45] i386: make struct apic_probe static
Message-Id: <20070921204513.D188A14F09@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

This patch makes the needlessly global struct apic_probe static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/mach-generic/probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/mach-generic/probe.c
===================================================================
--- linux.orig/arch/i386/mach-generic/probe.c
+++ linux/arch/i386/mach-generic/probe.c
@@ -22,7 +22,7 @@ extern struct genapic apic_default;
 
 struct genapic *genapic = &apic_default;
 
-struct genapic *apic_probe[] __initdata = { 
+static struct genapic *apic_probe[] __initdata = {
 	&apic_summit,
 	&apic_bigsmp, 
 	&apic_es7000,
