Return-Path: <linux-kernel-owner+w=401wt.eu-S935796AbXGMSN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935796AbXGMSN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXGMSNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:13:10 -0400
Received: from deeprooted.net ([216.254.16.51]:38940 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760022AbXGMSNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:13:07 -0400
Message-Id: <20070713175228.108932770@mvista.com>
References: <20070713175214.336577416@mvista.com>
User-Agent: quilt/0.45-1
Date: Fri, 13 Jul 2007 10:52:16 -0700
From: Kevin Hilman <khilman@mvista.com>
To: tglx@linutronix.de, mingo@elte.hu
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -rt 2/6] Fix typo in new IRQF_TIMER name
Content-Disposition: inline; filename=irqf-timer.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Hilman <khilman@mvista.com>
---
 include/linux/interrupt.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -52,7 +52,7 @@
 #define IRQF_SAMPLE_RANDOM	0x00000040
 #define IRQF_SHARED		0x00000080
 #define IRQF_PROBE_SHARED	0x00000100
-#define _IRQF_TIMER		0x00000200
+#define __IRQF_TIMER		0x00000200
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000

--
