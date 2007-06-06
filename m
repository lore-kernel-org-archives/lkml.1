Return-Path: <linux-kernel-owner+w=401wt.eu-S936759AbXFFWhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936759AbXFFWhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935191AbXFFWh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:37:26 -0400
Received: from gw.goop.org ([64.81.55.164]:55306 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934903AbXFFWhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:37:24 -0400
Message-ID: <4667370D.5080403@goop.org>
Date: Wed, 06 Jun 2007 15:37:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>
Subject: [PATCH] xen: don't include unnecessary headers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Strays left over from the first implementation of
paravirt_disable_iospace().

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/setup.c |    2 --
 1 file changed, 2 deletions(-)

===================================================================
--- a/arch/i386/xen/setup.c
+++ b/arch/i386/xen/setup.c
@@ -8,14 +8,12 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/pm.h>
-#include <linux/ioport.h>
 
 #include <asm/elf.h>
 #include <asm/e820.h>
 #include <asm/setup.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
-#include <asm/io.h>
 
 #include <xen/interface/physdev.h>
 #include <xen/features.h>

