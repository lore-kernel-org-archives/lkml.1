Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934880Ab0BZBTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 20:19:23 -0500
Received: from smtp-out-185.synserver.de ([212.40.180.185]:1045 "HELO
	smtp-out-185.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934850Ab0BZBTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 20:19:19 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 10864
From: Lars-Peter Clausen <lars@metafoo.de>
To: ben-linux@fluff.org
Cc: akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend] s3cmci: s3cmci_card_present: Use no_detect to decide whether there is a card detect pin
Date: Fri, 26 Feb 2010 02:12:08 +0100
Message-Id: <1267146728-8369-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1267146728-8369-1-git-send-email-lars@metafoo.de>
References: <1267146728-8369-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mmc/host/s3cmci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index b9c96cc..2fdf768 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1179,7 +1179,7 @@ static int s3cmci_card_present(struct mmc_host *mmc)
 	struct s3c24xx_mci_pdata *pdata = host->pdata;
 	int ret;
 
-	if (pdata->gpio_detect == 0)
+	if (pdata->no_detect)
 		return -ENOSYS;
 
 	ret = gpio_get_value(pdata->gpio_detect) ? 0 : 1;
-- 
1.5.6.5

