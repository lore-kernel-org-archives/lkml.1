Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZFESHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZFESHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZFESHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:07:35 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:54471 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZFESHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:07:34 -0400
Message-ID: <4A295FA2.1060401@oracle.com>
Date: Fri, 05 Jun 2009 11:10:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
CC: Greg KH <gregkh@suse.de>
Subject: comedi: uses udelay, needs delay.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A295EDF.0034:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

comedi driver(s) use udelay() so they need to #include delay.h.

drivers/staging/comedi/drivers/adq12b.c: In function 'adq12b_ai_rinsn':
drivers/staging/comedi/drivers/adq12b.c:328: error: implicit declaration of function 'udelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/comedi/comedidev.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090605.orig/drivers/staging/comedi/comedidev.h
+++ linux-next-20090605/drivers/staging/comedi/comedidev.h
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/kdev_t.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
