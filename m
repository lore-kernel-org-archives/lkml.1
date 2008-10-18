Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbYJRDwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbYJRDwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 23:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYJRDwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 23:52:16 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:37271 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbYJRDwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 23:52:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=qqM2fFVgOpsQM0YZnPt8Wk+vdPcQtlT0KHkBM7S5Axs/FfKLif9oUyMCeaqg0/TCoC
         tgIZJeaW6y4juUQ9R7kdNveXQYX+YAQDFV+73rlnnl03is4tYYW+tZsTsZraP2LC6jC0
         oi/Lom/dNrWbvVbkEl8LojLV909l4HxvKhviE=
Date: Sat, 18 Oct 2008 11:52:11 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Subject: staging: SLICOSS: remove duplicated #include's
Cc: linux-kernel@vger.kernel.org
Message-Id: <20081018113734.61B1.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include's in drivers/staging/slicoss/slicoss.c.
  linux/delay.h
  linux/etherdevice.h
  linux/init.h
  linux/netdevice.h
  linux/pci.h
  linux/skbuff.h
  linux/slab.h
  linux/string.h

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss
index b61ac4b..059f7e3 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -96,17 +96,9 @@
 #include <linux/moduleparam.h>

 #include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/dma-mapping.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
 #include <linux/mii.h>
 #include <linux/if_vlan.h>
-#include <linux/skbuff.h>
-#include <linux/string.h>
 #include <asm/unaligned.h>

 #include <linux/ethtool.h>


