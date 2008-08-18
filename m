Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYHRQqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYHRQqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYHRQps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:24576 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYHRQpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kUSP5DRNGTJAQpVcNxBRnZuucU5UV5m17O/D0AneAYACV/nNmsLUvXtR2Dt9JI8HyX
         kvhTQPEfzyT0pkSYzYx1C6ShESiBIj86yDWoPAMgVAVfncQUo5vAmxLiOOPz8vnhiZ5f
         UD2liZFb6qO3+Tp4yHLrc3W3KTAB3qtHVnXrw=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 02/15] x86: apic - unify setup_boot_APIC_clock
Date: Mon, 18 Aug 2008 20:45:50 +0400
Message-Id: <64a01a009ce913a15b02e51860ab246e5411e5b8.1219073223.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
References: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
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

