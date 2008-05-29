Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbYE2S2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbYE2S2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYE2S2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:28:32 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:37212 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbYE2S2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:28:31 -0400
Date: Thu, 29 May 2008 23:58:24 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux390@de.ibm.com, apw@shadowen.org
Subject: [PATCH] linux-next: Tree for May 29 - build failure s390x -typo in ccw_timeout_log()
Message-ID: <20080529182824.GA11679@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20080529182556.2994310a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529182556.2994310a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

The next-20080529 kernel build fails on the s390x, with the error

drivers/s390/cio/device_fsm.c: In function `ccw_timeout_log':
drivers/s390/cio/device_fsm.c:55: error: syntax error before ';' token
drivers/s390/cio/device_fsm.c:56: error: syntax error before ';' token
make[2]: *** [drivers/s390/cio/device_fsm.o] Error 1
make[1]: *** [drivers/s390/cio] Error 2
make: *** [drivers/s390] Error 2

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.26-rc4/drivers/s390/cio/device_fsm.c	2008-05-29 23:24:32.000000000 +0530
+++ linux-2.6.26-rc4/drivers/s390/cio/~device_fsm.c	2008-05-29 23:29:42.000000000 +0530
@@ -52,8 +52,8 @@ static void ccw_timeout_log(struct ccw_d
 	printk(KERN_WARNING "cio: orb:\n");
 	print_hex_dump(KERN_WARNING, "cio:  ", DUMP_PREFIX_NONE, 16, 1,
 		       orb, sizeof(*orb), 0);
-	printk(KERN_WARNING "cio: ccw device bus id: %s\n", dev_name(&cdev->dev);
-	printk(KERN_WARNING "cio: subchannel bus id: %s\n", dev_name(&sch->dev);
+	printk(KERN_WARNING "cio: ccw device bus id: %s\n", dev_name(&cdev->dev));
+	printk(KERN_WARNING "cio: subchannel bus id: %s\n", dev_name(&sch->dev));
 	printk(KERN_WARNING "cio: subchannel lpm: %02x, opm: %02x, "
 	       "vpm: %02x\n", sch->lpm, sch->opm, sch->vpm);
 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
