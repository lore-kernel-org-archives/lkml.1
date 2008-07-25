Return-Path: <linux-kernel-owner+w=401wt.eu-S1751810AbYGYPak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbYGYPak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYGYPaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:30:18 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:61458 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYGYPaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=Jb1ZdGhyxulCKrBTC3rpQZXbubsa0Mtzw3aWNrMGTMOfFiPS8YS4l4TYsYhtit48cg
         jYIYrEMxsRqujJ/6ZidvpTsIC7n7gthVzR+w+SQwtF0rPWFU/5Tg1XMN2ISSAWnVAvcS
         uPbLy02IbsurDNx02WCMIkhqPCSwVLbtbU7Wc=
Date: Fri, 25 Jul 2008 23:30:13 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: arch/x86/kernel/visws_quirks.c: Removed duplicated #include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080725225407.913A.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include in arch/x86/kernel/visws_quirks.c.
      asm/apic.h
      asm/arch_hooks.h
      asm/io.h
      asm/visws/cobalt.h
      asm/visws/lithium.h
      asm/visws/piix4.h
      linux/init.h
      linux/interrupt.h
      linux/smp.h

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 41e01b1..0c75691 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -29,41 +29,26 @@
 #include <asm/reboot.h>
 #include <asm/setup.h>
 #include <asm/e820.h>
-#include <asm/smp.h>
 #include <asm/io.h>

 #include <mach_ipi.h>

 #include "mach_apic.h"

-#include <linux/init.h>
-#include <linux/smp.h>
-
 #include <linux/kernel_stat.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>

-#include <asm/io.h>
-#include <asm/apic.h>
 #include <asm/i8259.h>
 #include <asm/irq_vectors.h>
-#include <asm/visws/cobalt.h>
 #include <asm/visws/lithium.h>
-#include <asm/visws/piix4.h>

 #include <linux/sched.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>

 extern int no_broadcast;

-#include <asm/io.h>
 #include <asm/apic.h>
-#include <asm/arch_hooks.h>
-#include <asm/visws/cobalt.h>
-#include <asm/visws/lithium.h>

 char visws_board_type  = -1;
 char visws_board_rev   = -1;

