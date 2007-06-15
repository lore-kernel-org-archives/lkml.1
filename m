Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbXFOVuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbXFOVuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbXFOVub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:50:31 -0400
Received: from 71-87-215-106.dhcp.oxfr.ma.charter.com ([71.87.215.106]:44449
	"EHLO ghaskins-t60p.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752530AbXFOVub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:50:31 -0400
X-Greylist: delayed 1909 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 17:50:31 EDT
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] natsemi irq flags
To: linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2007 17:17:50 -0400
Message-ID: <20070615211608.11079.35368.stgit@ghaskins-t60p.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The spinlock irq flags should be a unsigned long to properly support 64 bit

Signed-off-by: Gregory Haskins <ghaskins@novell.com>

---

 drivers/net/natsemi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index 4cf0d3f..460a087 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -690,7 +690,7 @@ static ssize_t natsemi_set_dspcfg_workaround(struct device *dev,
 {
 	struct netdev_private *np = netdev_priv(to_net_dev(dev));
 	int new_setting;
-	u32 flags;
+	unsigned long flags;
 
         /* Find out the new setting */
         if (!strncmp("on", buf, count - 1) || !strncmp("1", buf, count - 1))

