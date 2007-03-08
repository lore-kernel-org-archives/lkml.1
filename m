Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbXCHGcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbXCHGcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 01:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXCHGcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 01:32:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47722 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424AbXCHGcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 01:32:00 -0500
Reply-To: <kmpark@infradead.org>
From: "Kyungmin Park" <kmpark@infradead.org>
To: <drzeus-mmc@drzeus.cx>
Cc: <linux-kernel@vger.kernel.org>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org> <20070307224111.GD3441@stusta.de>
Subject: MMC: Fix typo in mmc highspeed
Date: Thu, 8 Mar 2007 15:31:53 +0900
Message-ID: <006301c7614b$790f8450$c7a3580a@swcenter.sec.samsung.co.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-reply-to: <20070307224111.GD3441@stusta.de>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-index: AcdhCdzH2+6hzKr3TheYDQ6rZKP4HwAQU1lA
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MMC: Fix typo in mmc highspeed

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
--
diff --git a/drivers/mmc/mmc.c b/drivers/mmc/mmc.c
index 4a73e8b..3b8f7af 100644
--- a/drivers/mmc/mmc.c
+++ b/drivers/mmc/mmc.c
@@ -1134,7 +1134,7 @@ static void mmc_process_ext_csds(struct mmc_host
*host)
 
 			mmc_card_set_highspeed(card);
 
-			host->ios.timing = MMC_TIMING_SD_HS;
+			host->ios.timing = MMC_TIMING_MMC_HS;
 			mmc_set_ios(host);
 		}

