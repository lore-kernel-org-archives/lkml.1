Return-Path: <linux-kernel-owner+w=401wt.eu-S965450AbXG2WBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965450AbXG2WBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964808AbXG2WBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:01:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:63640 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965356AbXG2WBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=mXHc8rNIEIHYQtM5IPUgUoU0mgg6cBD2sVHTUUUE63NrzHXjFzmIwAAAAHEHOLM7a0z14NVLA7LqJ28EknkfKHKKqTkwY2VoE58aCmRyvfatXxMdMnTMApJzMn2omFj1HvX+eyto7VbDCtot6wv/yF0pHIDK+iG5obpLp69FtT0=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-mips@linux-mips.org
Subject: [PATCH] mips: remove some duplicate includes
Date: Sun, 29 Jul 2007 23:59:35 +0200
User-Agent: KMail/1.9.7
Cc: Ralf Baechle <ralf@linux-mips.org>, Fuxin Zhang <zhangfx@lemote.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707292359.35971.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch removes some duplicate includes from arch/mips/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 arch/mips/kernel/signal32.c   |    1 -
 arch/mips/lemote/lm2e/irq.c   |    1 -
 arch/mips/mipssim/sim_setup.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index 486b8e5..64b612a 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -18,7 +18,6 @@
 #include <linux/errno.h>
 #include <linux/wait.h>
 #include <linux/ptrace.h>
-#include <linux/compat.h>
 #include <linux/suspend.h>
 #include <linux/compiler.h>
 #include <linux/uaccess.h>
diff --git a/arch/mips/lemote/lm2e/irq.c b/arch/mips/lemote/lm2e/irq.c
index 05693bc..3e0b7be 100644
--- a/arch/mips/lemote/lm2e/irq.c
+++ b/arch/mips/lemote/lm2e/irq.c
@@ -25,7 +25,6 @@
  */
 #include <linux/delay.h>
 #include <linux/io.h>
-#include <linux/irq.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/arch/mips/mipssim/sim_setup.c b/arch/mips/mipssim/sim_setup.c
index 17819b5..d012719 100644
--- a/arch/mips/mipssim/sim_setup.c
+++ b/arch/mips/mipssim/sim_setup.c
@@ -22,7 +22,6 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/ioport.h>
-#include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>


