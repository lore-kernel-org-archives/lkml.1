Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbYFLWgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbYFLWgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYFLWgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:36:04 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59468 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752977AbYFLWgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:36:03 -0400
Message-Id: <20080612223343.392447000@polaris-admin.engr.sgi.com>
References: <20080612223343.257409000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 15:33:44 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] x86: Add config option to setup early serial console
Content-Disposition: inline; filename=setup-early-serial-console
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * Add config option EARLY_SERIAL_CONSOLE to enable early
   printk's to be directed to the serial console.

Based on linux-next

Signed-off-by: Mike Travis <travis@sgi.com>
---

---
 arch/x86/kernel/early_printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.tip.orig/arch/x86/kernel/early_printk.c
+++ linux-2.6.tip/arch/x86/kernel/early_printk.c
@@ -193,7 +193,7 @@ static struct console simnow_console = {
 };
 
 /* Direct interface for emergencies */
-static struct console *early_console = &early_vga_console;
+static struct console *early_console = &early_serial_console;
 static int early_console_initialized;
 
 void early_printk(const char *fmt, ...)

-- 

