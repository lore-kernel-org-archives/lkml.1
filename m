Return-Path: <linux-kernel-owner+w=401wt.eu-S936945AbZAPS25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936945AbZAPS25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759239AbZAPS2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:28:11 -0500
Received: from nxgate.netxen.com ([38.99.60.130]:54445 "EHLO unm84.unmin.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757007AbZAPS2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:28:06 -0500
From: Dhananjay Phadke <dhananjay@netxen.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] netxen: include ipv6.h (fixes build failure)
Date: Fri, 16 Jan 2009 10:28:04 -0800
Message-Id: <1232130484-25188-3-git-send-email-dhananjay@netxen.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232130484-25188-1-git-send-email-dhananjay@netxen.com>
References: <1232130484-25188-1-git-send-email-dhananjay@netxen.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a build error in absence of CONFIG_IPV6:

drivers/net/netxen/netxen_nic_main.c:1189: error: implicit declaration of function 'ipv6_hdr'
drivers/net/netxen/netxen_nic_main.c:1189: error: invalid type argument of '->'

Signed-off-by: Dhananjay Phadke <dhananjay@netxen.com>
---
 drivers/net/netxen/netxen_nic_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index f8e2629..d854f07 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -41,6 +41,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/if_vlan.h>
 #include <net/ip.h>
+#include <linux/ipv6.h>
 
 MODULE_DESCRIPTION("NetXen Multi port (1/10) Gigabit Network Driver");
 MODULE_LICENSE("GPL");
-- 
1.6.0.2

