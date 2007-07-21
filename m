Return-Path: <linux-kernel-owner+w=401wt.eu-S940520AbXGUPPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940520AbXGUPPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939000AbXGUPEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:40095 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939490AbXGUPEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=AuJB2t/pijUkR/55hvrtjBPxzUKQrigNxag2/BhmvEK7ZpuWcIi6z0Onuc5lKESmDCnEc+YkhDj1AI81Ahkjw09HlyAf1n/XhEmYk5OoKCIm221VETS/JXLxxrLATL3KzuCup56MsnPsVT7fpGzECxEVvbxStbQer0Zhu3zbW4w=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][27/37] Clean up duplicate includes in net/bridge/
Date: Sat, 21 Jul 2007 17:03:36 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       David S Miller <davem@davemloft.net>,
       Bart De Schuymer <bdschuym@pandora.be>,
       Harald Welte <laforge@netfilter.org>,
       netfilter-devel@lists.netfilter.org,
       Rusty Russell <rusty@rustcorp.com.au>, Marc Boucher <marc@mbsi.ca>,
       James Morris <jmorris@namei.org>, Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.37119.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	net/bridge/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 031bfa4..89d0d59 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -9,7 +9,6 @@
  *
  */
 
-#include <linux/in.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_log.h>
 #include <linux/netfilter.h>
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 9411db6..a31402a 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -36,7 +36,6 @@
 #include <linux/timer.h>
 #include <linux/netlink.h>
 #include <linux/netdevice.h>
-#include <linux/module.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_ulog.h>
 #include <net/sock.h>
