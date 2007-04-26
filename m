Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbXDZXuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbXDZXuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXDZXuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:50:19 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35856 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755261AbXDZXrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:47:43 -0400
Date: Fri, 27 Apr 2007 01:47:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] arch/i386/kernel/i8253.c should #include <asm/timer.h>
Message-ID: <20070426234754.GL3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 27 Mar 2007

--- linux-2.6.21-rc4-mm1/arch/i386/kernel/i8253.c.old	2007-03-26 15:58:48.000000000 +0200
+++ linux-2.6.21-rc4-mm1/arch/i386/kernel/i8253.c	2007-03-26 15:59:01.000000000 +0200
@@ -13,6 +13,7 @@
 #include <asm/delay.h>
 #include <asm/i8253.h>
 #include <asm/io.h>
+#include <asm/timer.h>
 
 #include "io_ports.h"
 

