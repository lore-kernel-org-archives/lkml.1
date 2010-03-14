Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab0CNMJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 08:09:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41641 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997Ab0CNMJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 08:09:09 -0400
Date: Sun, 14 Mar 2010 23:07:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?B?IlJpY2hhcmQgUsO2amZvcnMi?= 
	<richard.rojfors@pelagicore.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ben Dooks <ben@fluff.org>,
       linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
       xtfeng@gmail.com, linux-next@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH, fix 2/2] Add include to i2c-xii.c to fix build error
Message-Id: <20100314230747.1a118846.sfr@canb.auug.org.au>
In-Reply-To: <20100314230525.352410e5.sfr@canb.auug.org.au>
References: <4B94C951.6050703@pelagicore.com>
	<20100308150121.GW10014@trinity.fluff.org>
	<4B956F9E.8020304@oracle.com>
	<4B960420.8040804@pelagicore.com>
	<20100314230525.352410e5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Thu, 04 Feb 2010 12:11:09 -0800

drivers/i2c/busses/i2c-xiic.c:493: error: implicit declaration of function 'mdelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Richard Röjfors" <richard.rojfors@pelagicore.com>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/i2c/busses/i2c-xiic.c |    1 +
 1 file changed, 1 insertion(+)

Hi Linus,

This patch has been in linux-next for a while as well.  Please apply.

--- linux-next-20100204.orig/drivers/i2c/busses/i2c-xiic.c
+++ linux-next-20100204/drivers/i2c/busses/i2c-xiic.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
