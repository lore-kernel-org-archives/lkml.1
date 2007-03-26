Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbXCZPTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbXCZPTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 11:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXCZPTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 11:19:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbXCZPTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 11:19:43 -0400
Date: Mon, 26 Mar 2007 17:19:33 +0200
From: Bernhard Walle <bwalle@suse.de>
To: discuss@x86-64.org
Cc: linux-kernel@vger.kernel.org, ak@suse.de
Subject: [PATCH] Fix "Section mismatch" compile warning
Message-ID: <20070326151933.GA8765@strauss.suse.de>
Mail-Followup-To: discuss@x86-64.org, linux-kernel@vger.kernel.org,
	ak@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "Section mismatch" warnings in arch/x86_64/kernel/time.c

Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/x86_64/kernel/time.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc4-mm1/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/arch/x86_64/kernel/time.c
+++ linux-2.6.21-rc4-mm1/arch/x86_64/kernel/time.c
@@ -282,7 +282,7 @@ static unsigned int __init pit_calibrate
 #define PIT_MODE 0x43
 #define PIT_CH0  0x40
 
-static void __init __pit_init(int val, u8 mode)
+static void __pit_init(int val, u8 mode)
 {
 	unsigned long flags;
 
@@ -298,12 +298,12 @@ void __init pit_init(void)
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
