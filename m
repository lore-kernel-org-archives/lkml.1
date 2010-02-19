Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0BSHdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 02:33:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34121
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754582Ab0BSHdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 02:33:04 -0500
Date: Thu, 18 Feb 2010 23:33:21 -0800 (PST)
Message-Id: <20100218.233321.226788593.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, kristoffer@gaisler.com
Subject: Re: linux-next: build failure after final merge (net tree)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100219173713.e3f9f386.sfr@canb.auug.org.au>
References: <20100219173713.e3f9f386.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 19 Feb 2010 17:37:13 +1100

> I assume that this driver was written and tested only on Sparc
> ... maybe it should depend on SPARC?

Indeed, it should.  I thought for some reason that all OF
platforms have of_remap() and of_device->resource[], oh
well :-)

Will commit the following, thanks!

net: Make GRETH driver depend on SPARC.

Reported by Stephen Rothwell.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 17ff15f..46af867 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -997,7 +997,7 @@ config ETHOC
 
 config GRETH
 	tristate "Aeroflex Gaisler GRETH Ethernet MAC support"
-	depends on OF
+	depends on SPARC
 	select PHYLIB
 	select CRC32
 	help
-- 
1.6.6.1

