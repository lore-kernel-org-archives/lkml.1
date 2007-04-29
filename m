Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbXD2K6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbXD2K6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbXD2K5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:57:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:51366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbXD2Kxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:38 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Bernhard Walle <bwalle@suse.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [47/48] x86_64: Fix "Section mismatch" compile warning
Message-Id: <20070429105337.DE416151D2@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Bernhard Walle <bwalle@suse.de>
Fix "Section mismatch" warnings in arch/x86_64/kernel/time.c

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/time.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -328,7 +328,7 @@ static unsigned int __init pit_calibrate
 #define PIT_MODE 0x43
 #define PIT_CH0  0x40
 
-static void __init __pit_init(int val, u8 mode)
+static void __pit_init(int val, u8 mode)
 {
 	unsigned long flags;
 
@@ -344,12 +344,12 @@ void __init pit_init(void)
 	__pit_init(LATCH, 0x34); /* binary, mode 2, LSB/MSB, ch 0 */
 }
 
-void __init pit_stop_interrupt(void)
+void pit_stop_interrupt(void)
 {
 	__pit_init(0, 0x30); /* mode 0 */
 }
 
-void __init stop_timer_interrupt(void)
+void stop_timer_interrupt(void)
 {
 	char *name;
 	if (hpet_address) {
