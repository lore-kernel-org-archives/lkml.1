Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYH2Lst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYH2Lst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYH2Lsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:48:41 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:13806 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbYH2Lsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:48:40 -0400
Message-Id: <48B7FE83.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 12:49:55 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: init annotations in early_printk() setup
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/early_printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.27-rc5/arch/x86/kernel/early_printk.c	2008-08-21 14:37:29.000000000 +0200
+++ 2.6.27-rc5-x86-early-printk-init/arch/x86/kernel/early_printk.c	2008-08-22 15:24:33.000000000 +0200
@@ -111,7 +111,7 @@ static __init void early_serial_init(cha
 		if (!strncmp(s, "0x", 2)) {
 			early_serial_base = simple_strtoul(s, &e, 16);
 		} else {
-			static int bases[] = { 0x3f8, 0x2f8 };
+			static const int __initconst bases[] = { 0x3f8, 0x2f8 };
 
 			if (!strncmp(s, "ttyS", 4))
 				s += 4;
@@ -194,7 +194,7 @@ static struct console simnow_console = {
 
 /* Direct interface for emergencies */
 static struct console *early_console = &early_vga_console;
-static int early_console_initialized;
+static int __initdata early_console_initialized;
 
 asmlinkage void early_printk(const char *fmt, ...)
 {



