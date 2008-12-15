Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYLOXk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYLOXk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 18:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYLOXkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 18:40:12 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:54119 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbYLOXkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 18:40:11 -0500
Message-ID: <4946EA3D.8060604@oracle.com>
Date: Mon, 15 Dec 2008 15:37:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] mtd: fix nandsim sched.h references
References: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
In-Reply-To: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4946EA32.003C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sched.h references:

build-r7149.out:/local/linsrc/linux-next-20081215/drivers/mtd/nand/nandsim.c:1326: error: dereferencing pointer to incomplete type
build-r7149.out:/local/linsrc/linux-next-20081215/drivers/mtd/nand/nandsim.c:1326: error: 'PF_MEMALLOC' undeclared (first use in this function)
build-r7149.out:/local/linsrc/linux-next-20081215/drivers/mtd/nand/nandsim.c:1328: error: dereferencing pointer to incomplete type
build-r7149.out:/local/linsrc/linux-next-20081215/drivers/mtd/nand/nandsim.c:1335: error: dereferencing pointer to incomplete type
build-r7149.out:/local/linsrc/linux-next-20081215/drivers/mtd/nand/nandsim.c:1335: error: 'PF_MEMALLOC' undeclared (first use in this function)
build-r7149.out:make[4]: *** [drivers/mtd/nand/nandsim.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/mtd/nand/nandsim.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20081215.orig/drivers/mtd/nand/nandsim.c
+++ linux-next-20081215/drivers/mtd/nand/nandsim.c
@@ -38,6 +38,7 @@
 #include <linux/delay.h>
 #include <linux/list.h>
 #include <linux/random.h>
+#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 
