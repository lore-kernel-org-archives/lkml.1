Return-Path: <linux-kernel-owner+w=401wt.eu-S1764357AbYEYKbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764357AbYEYKbB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762291AbYEYKYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43338 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762569AbYEYKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:14 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 20/28] ttusb-dec: treat firmware data as const
Message-Id: <E1K0DOI-0007E4-2N@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:50 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/media/dvb/ttusb-dec/ttusb_dec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
index 42eee04..8af88f1 100644
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -1275,7 +1275,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 	u8 b1[] = { 0x61 };
 	u8 *b;
 	char idstring[21];
-	u8 *firmware = NULL;
+	const u8 *firmware = NULL;
 	size_t firmware_size = 0;
 	u16 firmware_csum = 0;
 	u16 firmware_csum_ns;
-- 
1.5.4.5

