Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbXLQEBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbXLQEBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 23:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXLQEBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 23:01:14 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2453 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbXLQEBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 23:01:14 -0500
Subject: Re: [PATCH net-2.6.25 8/8] Remove unused IPV4TYPE macros
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071216.134825.261226998.davem@davemloft.net>
References: <1197589141-7020-7-git-send-email-joe@perches.com>
	 <e2ebcbf24539c0a3ef2ac77147dbfa55d8ac9e33.1197432867.git.joe@perches.com>
	 <1197589141-7020-8-git-send-email-joe@perches.com>
	 <20071216.134825.261226998.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 20:01:06 -0800
Message-Id: <1197864066.4894.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-12-16 at 13:48 -0800, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Thu, 13 Dec 2007 15:39:01 -0800
> > Signed-off-by: Joe Perches <joe@perches.com>
> Applied, thanks for doing this work Joe.

I broke the parisc build.  Bad Joe...

Here's the patch:

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index a6d6b24..703b85e 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -364,7 +364,7 @@ static __inline__ int led_get_net_activity(void)
 	    struct in_device *in_dev = __in_dev_get_rcu(dev);
 	    if (!in_dev || !in_dev->ifa_list)
 		continue;
-	    if (LOOPBACK(in_dev->ifa_list->ifa_local))
+	    if (ipv4_is_loopback(in_dev->ifa_list->ifa_local))
 		continue;
 	    stats = dev->get_stats(dev);
 	    rx_total += stats->rx_packets;


