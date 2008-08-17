Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYHQTml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYHQTml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYHQTlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:41:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:15010 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYHQTlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OSHuk2mEcv/Yiemzv5AWDXxT3vdZaoNCQwp/bwqBnPNDp0TxWvMqpXqt+5/lKcMwX4
         eCiqEfLvHBKiPm/ZZSpfuUfzNPNDABx2iWOAdwzoTynQQJO1B1iGH9q1Gr7dx+t6mRLn
         x7C9+Q+57nFrySRaRexrGDXl6b1+arGkPQgE0=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 2/9] x86: apic - unify setup_boot_APIC_clock
Date: Sun, 17 Aug 2008 23:41:40 +0400
Message-Id: <7930e894e5baf413c41cb16c9a2d623cd02f1068.1219001352.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
References: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <68106c6e85398a15b2a5d556764159541e1d66fe.1219001352.git.gorcunov@gmail.com>
References: <68106c6e85398a15b2a5d556764159541e1d66fe.1219001352.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 8d1febf..80db3e0 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -612,6 +612,7 @@ void __init setup_boot_APIC_clock(void)
 	 * broadcast mechanism is used. On UP systems simply ignore it.
 	 */
 	if (disable_apic_timer) {
+		printk(KERN_INFO "Disabling APIC timer\n");
 		/* No broadcast on UP ! */
 		if (num_possible_cpus() > 1) {
 			lapic_clockevent.mult = 1;
-- 
1.6.0.rc1.34.g0fe8c

