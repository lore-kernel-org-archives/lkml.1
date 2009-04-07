Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbZDGPSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbZDGPSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758806AbZDGPIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48885 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608AbZDGPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:12 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [26/28] Export add_timer_on for modules
Message-Id: <20090407150809.B938E1D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:08:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Needed for the modular machine check injector.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/timer.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/kernel/timer.c
===================================================================
--- linux.orig/kernel/timer.c	2009-04-07 16:09:50.000000000 +0200
+++ linux/kernel/timer.c	2009-04-07 16:09:59.000000000 +0200
@@ -753,6 +753,7 @@
 	wake_up_idle_cpu(cpu);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
+EXPORT_SYMBOL_GPL(add_timer_on);
 
 /**
  * del_timer - deactive a timer.
