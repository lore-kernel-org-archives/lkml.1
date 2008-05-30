Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYE3MqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYE3MqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 08:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYE3Mpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 08:45:52 -0400
Received: from mail.atmel.fr ([81.80.104.162]:61157 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYE3Mpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 08:45:51 -0400
Message-ID: <483FF6F4.80406@atmel.com>
Date: Fri, 30 May 2008 14:45:40 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: =?ISO-8859-1?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>,
       =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] mmc: at91_mci: add multiwrite switch
References: <483FE9E7.7020707@atmel.com>
In-Reply-To: <483FE9E7.7020707@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91_mci is capable of multiwrite. Enable it before it disappears.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
drivers/mmc/host/at91_mci.c |    1 +
1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 6b9662e..df975e0 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -923,6 +923,7 @@ static int __init at91_mci_probe(struct 
platform_device *pdev)
	mmc->f_min = 375000;
	mmc->f_max = 25000000;
	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
+	mmc->caps = MMC_CAP_MULTIWRITE;

	mmc->max_blk_size = 4095;
	mmc->max_blk_count = mmc->max_req_size;
-- 
1.5.3.7



