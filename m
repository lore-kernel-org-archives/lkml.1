Return-Path: <linux-kernel-owner+w=401wt.eu-S1763260AbYEYK3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763260AbYEYK3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762619AbYEYKYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43327 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762571AbYEYKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:14 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 15/28] p54: treat firmware data as const
Message-Id: <E1K0DOC-0007Dk-Px@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:44 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/p54/p54usb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 98ddbb3..6728254 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -375,7 +375,8 @@ static int p54u_upload_firmware_3887(struct ieee80211_hw *dev)
 	const struct firmware *fw_entry = NULL;
 	int err, alen;
 	u8 carry = 0;
-	u8 *buf, *tmp, *data;
+	u8 *buf, *tmp;
+	const u8 *data;
 	unsigned int left, remains, block_size;
 	struct x2_header *hdr;
 	unsigned long timeout;
@@ -522,7 +523,7 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
 	void *buf;
 	__le32 reg;
 	unsigned int remains, offset;
-	u8 *data;
+	const u8 *data;
 
 	buf = kmalloc(512, GFP_KERNEL);
 	if (!buf) {
-- 
1.5.4.5

