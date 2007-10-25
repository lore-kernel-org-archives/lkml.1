Return-Path: <linux-kernel-owner+w=401wt.eu-S1760714AbXJYLun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714AbXJYLun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbXJYLug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:50:36 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46649 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894AbXJYLuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:50:35 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 25 Oct 2007 17:20:20 +0530
Message-Id: <20071025115020.30481.60740.sendpatchset@balbir-laptop>
Subject: [x86 patch] Fix UML ubd_kern.c build error
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Fix UML build error, include linux/scatterlist.h in arch/um/drivers/ubd_kern.c,
to resolve the definition of sg_page()

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 arch/um/drivers/ubd_kern.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/drivers/ubd_kern.c~fix-uml-ubd_kern-build-error arch/um/drivers/ubd_kern.c
--- 2.6.24-rc1/arch/um/drivers/ubd_kern.c~fix-uml-ubd_kern-build-error	2007-10-25 17:15:42.000000000 +0530
+++ 2.6.24-rc1-balbir/arch/um/drivers/ubd_kern.c	2007-10-25 17:15:57.000000000 +0530
@@ -35,6 +35,7 @@
 #include "linux/genhd.h"
 #include "linux/spinlock.h"
 #include "linux/platform_device.h"
+#include "linux/scatterlist.h"
 #include "asm/segment.h"
 #include "asm/uaccess.h"
 #include "asm/irq.h"
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
