Return-Path: <linux-kernel-owner+w=401wt.eu-S1762653AbYEYK1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653AbYEYK1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760137AbYEYKX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762251AbYEYKXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:55 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 23/28] gp8psk: treat firmware data as const
Message-Id: <E1K0DOL-0007EG-8J@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:53 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/media/dvb/dvb-usb/gp8psk.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/gp8psk.c b/drivers/media/dvb/dvb-usb/gp8psk.c
index 9a942af..85836da 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -86,7 +86,8 @@ static int gp8psk_load_bcm4500fw(struct dvb_usb_device *d)
 {
 	int ret;
 	const struct firmware *fw = NULL;
-	u8 *ptr, *buf;
+	const u8 *ptr;
+	u8 *buf;
 	if ((ret = request_firmware(&fw, bcm4500_firmware,
 					&d->udev->dev)) != 0) {
 		err("did not find the bcm4500 firmware file. (%s) "
-- 
1.5.4.5

