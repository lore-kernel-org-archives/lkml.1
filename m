Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbXJNEhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbXJNEhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 00:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbXJNEhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 00:37:17 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:10327 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbXJNEhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 00:37:15 -0400
Date: Sat, 13 Oct 2007 22:36:57 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/2] mpc52xx-ata: fix compile warning (unused variable)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, paulus@ozlabs.org
Message-id: <20071014043657.23348.56519.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Trivial unused variable fix

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/ata/pata_mpc52xx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 099f4cd..f1c3f4d 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -309,7 +309,6 @@ mpc52xx_ata_init_one(struct device *dev, struct mpc52xx_ata_priv *priv)
 	struct ata_host *host;
 	struct ata_port *ap;
 	struct ata_ioports *aio;
-	int rc;
 
 	host = ata_host_alloc(dev, 1);
 	if (!host)

