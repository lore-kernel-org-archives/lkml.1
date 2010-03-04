Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab0CDFas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 00:30:48 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:49119 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0CDFar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 00:30:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=YoPkSGV4UaaH4qnzgcPIcFxQhGKf25xEkIh+JI2MxbTY5slVJDiqFKMbjR6S0GtKy8
         rRz9qJt7RvBYtxtMcpnE3SMge6plh/D/PPBCoCat+Znidzedgo/hay3X6SCfASP/x8ZA
         ILFYRR0Oygalo46YFqeQN5AEbE02Pcf1Pfio8=
Date: Thu, 4 Mar 2010 21:28:57 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 2/2] Init: Fix some coding styles in init/main.c
Message-ID: <20100304132857.GB3740@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding styles in init/main.c

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 init/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 4cb47a1..d187382 100644
--- a/init/main.c
+++ b/init/main.c
@@ -738,9 +738,8 @@ int do_one_initcall(initcall_t fn)
 		strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
 		local_irq_enable();
 	}
-	if (msgbuf[0]) {
+	if (msgbuf[0])
 		printk("initcall %pF returned with %s\n", fn, msgbuf);
-	}
 
 	return ret.result;
 }
-- 
1.6.5.3

