Return-Path: <linux-kernel-owner+w=401wt.eu-S1759033AbXGMQcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbXGMQcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXGMQci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:32:38 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:15754 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbXGMQch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:32:37 -0400
Message-ID: <4697A923.5080506@mvista.com>
Date: Fri, 13 Jul 2007 09:32:35 -0700
From: Kevin Hilman <khilman@mvista.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: v2.6.22.1-rt3
References: <1184325752.12353.312.camel@chaos>
In-Reply-To: <1184325752.12353.312.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

A typo in preempt-irqs-core.patch, where IRQF_TIMER is changed to
_IRQF_TIMER but called later as __IRQF_TIMER.

Here's a patch to compile, but not sure if you want one or two underscores.

With these two paches, -rt3 is building/booting for ARM/OMAP1.

Kevin

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -52,7 +52,7 @@
 #define IRQF_SAMPLE_RANDOM     0x00000040
 #define IRQF_SHARED            0x00000080
 #define IRQF_PROBE_SHARED      0x00000100
-#define _IRQF_TIMER            0x00000200
+#define __IRQF_TIMER           0x00000200
 #define IRQF_PERCPU            0x00000400
 #define IRQF_NOBALANCING       0x00000800
 #define IRQF_IRQPOLL           0x00001000

