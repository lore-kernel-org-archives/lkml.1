Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYIDSnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYIDSnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbYIDSjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:39:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:15551 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbYIDSjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:39:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=aMCOAh+94HEP0iWMAePPJlHlnjNyB8eTDEq1AjxcyIPxFf3i9FHp/bpV5ru8bIrhuS
         pmU/b/Z//NZBv2QtUJ3mEn7OMJqr+Zl7SenY2YgMZsVqjDpqI6NRHaNqlwJ+jfEEK101
         8G2ftq81uRwJ1Egp2wHNkNUyak1zytDfuvDFU=
References: <20080904183748.950151853@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 04 Sep 2008 22:37:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/3] x86: io-apic - use ARRAY_SIZE macro
Content-Disposition: inline; filename=x86-ioapic-use-ARRAY_SIZE
Message-ID: <48c02b69.0405560a.6570.7100@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the code width a bit shorter with ARRAY_SIZE macro.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic.c	2008-09-04 20:34:14.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic.c	2008-09-04 21:35:48.000000000 +0400
@@ -166,7 +166,7 @@ static void __init init_work(void *data)
 
 	memcpy(cfg, irq_cfg_legacy, sizeof(irq_cfg_legacy));
 
-	legacy_count = sizeof(irq_cfg_legacy)/sizeof(irq_cfg_legacy[0]);
+	legacy_count = ARRAY_SIZE(irq_cfg_legacy);
 	for (i = legacy_count; i < *da->nr; i++)
 		init_one_irq_cfg(&cfg[i]);
 

-- 
