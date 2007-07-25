Return-Path: <linux-kernel-owner+w=401wt.eu-S1765642AbXGYMzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765642AbXGYMzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761650AbXGYMze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:55:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39751 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759752AbXGYMzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:55:33 -0400
Message-ID: <46A7483C.60005@fr.ibm.com>
Date: Wed, 25 Jul 2007 14:55:24 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.23-rc1-mm1
References: <20070725040304.111550f4.akpm@linux-foundation.org>
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/

from pm-move-definition-of-struct-pm_ops-to-suspendh.patch :

drivers/video/chipsfb.c: In function 'chipsfb_pci_suspend':
drivers/video/chipsfb.c:461: error: 'PM_SUSPEND_MEM' undeclared (first use in this function)
drivers/video/chipsfb.c:461: error: (Each undeclared identifier is reported only once
drivers/video/chipsfb.c:461: error: for each function it appears in.)

Cheers,

C.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 drivers/video/chipsfb.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.23-rc1-mm1/drivers/video/chipsfb.c
===================================================================
--- 2.6.23-rc1-mm1.orig/drivers/video/chipsfb.c
+++ 2.6.23-rc1-mm1/drivers/video/chipsfb.c
@@ -27,6 +27,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/console.h>
+#include <linux/suspend.h>
 #include <asm/io.h>
 
 #ifdef CONFIG_PMAC_BACKLIGHT

