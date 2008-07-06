Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbYGFQOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbYGFQOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbYGFQNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:13:52 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:54239 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbYGFQNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:13:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=wbjYBc0y2gM5Wi+wYJKSUT3FuNgJ6tKofRcmSQmJRrPoxvPFpOceDo6aryOQMjCtJS
         e1Wkzn6i8ifKg1PYRObujTgzIWJfDQPk23rBxIo1rulQ37NBx9ZSxkhG8BIHPbnOcOPg
         apG8fOEv4CTuvDUm9qS4sZqYs+ic+Xwqnf5Mc=
Message-ID: <a4423d670807060913red9187bj7bcc886d1fb20ad3@mail.gmail.com>
Date: Sun, 6 Jul 2008 20:13:49 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: mingo@elte.hu, yhlu.kernel@gmail.com, tglx@linutronix.de, hpa@zytor.com,
       kernel-janitors@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 setup.c: cleanup includes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

The patch applies to the linux-next tree.


x86: remove double includes in setup.c

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 3c98693..f4c9b58 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -57,12 +57,8 @@
 #include <linux/slab.h>
 #include <linux/user.h>
 #include <linux/delay.h>
-#include <linux/highmem.h>

 #include <linux/kallsyms.h>
-#include <linux/edd.h>
-#include <linux/iscsi_ibft.h>
-#include <linux/kexec.h>
 #include <linux/cpufreq.h>
 #include <linux/dma-mapping.h>
 #include <linux/ctype.h>
@@ -104,7 +100,6 @@
 #include <asm/paravirt.h>

 #include <asm/percpu.h>
-#include <asm/sections.h>
 #include <asm/topology.h>
 #include <asm/apicdef.h>
 #ifdef CONFIG_X86_64
