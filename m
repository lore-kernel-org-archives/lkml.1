Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYHBWxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYHBWxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 18:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYHBWxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 18:53:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:32774 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYHBWxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 18:53:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=oi0Yi9l49AzWTc6678QVGPiHT9Vg7QIAxQfYYUa3UcpojJhg/CaAR0Oj70oFA2PynZ
         d4dlupaPeGjs++4jSBE9xQDZ974pCCE9iAy2phUaUUj9aPueO6F/LJSw+JripT7mB8JL
         WdQOL1vkgA/O6JV+MvaLDjrjTICe2C1JeaYgw=
Date: Sun, 3 Aug 2008 02:53:04 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: viro@zeniv.linux.org.uk, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/mtd/mtdsuper.c: fix build error
Message-ID: <20080802225304.GD4856@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

drivers/mtd/mtdsuper.c: fix build error

drivers/mtd/mtdsuper.c:184: error: implicit declaration of
	function 'lookup_bdev'
drivers/mtd/mtdsuper.c:197: error: implicit declaration of
	function 'bdput'

Introduced by commit d5686b444ff3f72808d2b3fbd58672a86cdf38e7


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---

 drivers/mtd/mtdsuper.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index 9b6af7e..ec950cd 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -13,6 +13,7 @@
 #include <linux/mtd/super.h>
 #include <linux/namei.h>
 #include <linux/ctype.h>
+#include <linux/fs.h>
 
 /*
  * compare superblocks to see if they're equivalent
