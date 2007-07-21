Return-Path: <linux-kernel-owner+w=401wt.eu-S1765626AbXGUPST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765626AbXGUPST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762391AbXGUPFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:05:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763902AbXGUPE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=dSdxXDLuzJpdkcyGIZKg6CgNuz7ECJP3o1XJgtqOU+zOoOwyx8CqCVyd+PigoqASTecOcD1Z3aY7QVJW55O6TJm0hXWmb59CfZVhbfGHGSekKoQAoNFOqtcKMSN2vTS+u4fHS3zDcPVHsZf2amwzsNq+lrMtsuMkaHZ+i9GS19w=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][33/37] Clean up duplicate includes in net/tipc/
Date: Sat, 21 Jul 2007 17:03:58 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       David S Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       tipc-discussion@lists.sourceforge.net,
       Jon Maloy <jon.maloy@ericsson.com>, Per Liden <per.liden@ericsson.com>,
       Allan Stephens <allan.stephens@windriver.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.59169.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	net/tipc/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/net/tipc/port.c b/net/tipc/port.c
index 5d2b9ce..7608815 100644
--- a/net/tipc/port.c
+++ b/net/tipc/port.c
@@ -41,7 +41,6 @@
 #include "addr.h"
 #include "link.h"
 #include "node.h"
-#include "port.h"
 #include "name_table.h"
 #include "user_reg.h"
 #include "msg.h"
