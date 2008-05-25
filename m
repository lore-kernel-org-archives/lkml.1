Return-Path: <linux-kernel-owner+w=401wt.eu-S1762653AbYEYKZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653AbYEYKZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762086AbYEYKXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41981 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762038AbYEYKXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:45 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 13/28] zd1201: treat firmware data as const
Message-Id: <E1K0DOA-0007Dc-Md@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:42 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/zd1201.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index d5c0c66..78baa0f 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -49,7 +49,7 @@ MODULE_DEVICE_TABLE(usb, zd1201_table);
 static int zd1201_fw_upload(struct usb_device *dev, int apfw)
 {
 	const struct firmware *fw_entry;
-	char *data;
+	const char *data;
 	unsigned long len;
 	int err;
 	unsigned char ret;
-- 
1.5.4.5

