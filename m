Return-Path: <linux-kernel-owner+w=401wt.eu-S933864AbXC0BCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864AbXC0BCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 21:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933884AbXC0BCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 21:02:36 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35467 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933864AbXC0BCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:02:35 -0400
Date: Tue, 27 Mar 2007 03:02:39 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] arch/i386/kernel/i8253.c should #include <asm/timer.h>
Message-ID: <20070327010239.GU16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc4-mm1/arch/i386/kernel/i8253.c.old	2007-03-26 15:58:48.000000000 +0200
+++ linux-2.6.21-rc4-mm1/arch/i386/kernel/i8253.c	2007-03-26 15:59:01.000000000 +0200
@@ -13,6 +13,7 @@
 #include <asm/delay.h>
 #include <asm/i8253.h>
 #include <asm/io.h>
+#include <asm/timer.h>
 
 #include "io_ports.h"
 

