Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391Ab0AQTUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab0AQTUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 14:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291Ab0AQTUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 14:20:52 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:43266 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0AQTUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 14:20:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=iCnWBShjPc7pbT7v7YyOAvvMFWoKfHcBh0+iqw91HdntaWIJftESc7iPiu9pzJW9po
         g3OOUmLv/wMGDOI6D8P4zgrYhiesdyCBbCFXyAT4kxMcZRO23j7YdRIlhqgVBCLPmAi0
         bnbOPuxFWxHt2BclBiOyZe5PMgsuO+fbKMWg0=
Message-ID: <4B536430.6000704@gmail.com>
Date: Sun, 17 Jan 2010 20:25:36 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] msm_sdcc.c: missing brackets in msmsdcc_resume()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the curly brackets were missing the test and enable_irq(),
if true, occurred twice.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/mmc/host/msm_sdcc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index b31946e..4c068e5 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1250,9 +1250,7 @@ msmsdcc_resume(struct platform_device *dev)
 
 		if (mmc->card && mmc->card->type != MMC_TYPE_SDIO)
 			mmc_resume_host(mmc);
-			if (host->stat_irq)
-				enable_irq(host->stat_irq);
-		else if (host->stat_irq)
+		if (host->stat_irq)
 			enable_irq(host->stat_irq);
 	}
 	return 0;
