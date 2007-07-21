Return-Path: <linux-kernel-owner+w=401wt.eu-S941162AbXGUPRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941162AbXGUPRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939515AbXGUPFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:05:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:41052 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939355AbXGUPE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=okVIwT8S+Oj/y7PN8eVUcdlT8oOKtGh+8MF/UXf95C8iJvXCGszrtfOWzaZJnUQbfiVEAy/i0D0MJuQ+9WHsuZ0dUV5bHs5mfFKKJ5EE2GQiWMP/22SWDL+YcW01oQYlBf5KabD1yGBY6CoevoBw0AlSXcElX4TdCGI5N0hjYNk=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][34/37] Clean up duplicate includes in  net/xfrm/
Date: Sat, 21 Jul 2007 17:04:01 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, netdev@vger.kernel.org,
       David S Miller <davem@davemloft.net>,
       Kunihiro Ishiguro <kunihiro@ipinfusion.com>,
       Derek Atkins <derek@ihtfp.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707211704.01339.jesper.juhl@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	net/xfrm/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index c3a4b0a..e67489a 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -23,10 +23,9 @@
 #include <linux/netfilter.h>
 #include <linux/module.h>
 #include <linux/cache.h>
+#include <linux/audit.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
-#include <linux/audit.h>
-#include <linux/cache.h>
 
 #include "xfrm_hash.h"
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 38f90ca..b2552b1 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -19,9 +19,8 @@
 #include <linux/ipsec.h>
 #include <linux/module.h>
 #include <linux/cache.h>
-#include <asm/uaccess.h>
 #include <linux/audit.h>
-#include <linux/cache.h>
+#include <asm/uaccess.h>
 
 #include "xfrm_hash.h"
 
