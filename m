Return-Path: <linux-kernel-owner+w=401wt.eu-S1764145AbYEYK34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764145AbYEYK34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761504AbYEYKYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43336 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762566AbYEYKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:14 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 17/28] irda-usb: treat firmware data as const
Message-Id: <E1K0DOE-0007Ds-Ti@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:46 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/irda/irda-usb.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/irda/irda-usb.c b/drivers/net/irda/irda-usb.c
index 6f50ed7..18b471c 100644
--- a/drivers/net/irda/irda-usb.c
+++ b/drivers/net/irda/irda-usb.c
@@ -1024,7 +1024,7 @@ static int irda_usb_is_receiving(struct irda_usb_cb *self)
  *   Upload firmware code to SigmaTel 421X IRDA-USB dongle
  */
 static int stir421x_fw_upload(struct irda_usb_cb *self,
-			     unsigned char *patch,
+			     const unsigned char *patch,
 			     const unsigned int patch_len)
 {
         int ret = -ENOMEM;
@@ -1073,11 +1073,11 @@ static int stir421x_fw_upload(struct irda_usb_cb *self,
   */
 static int stir421x_patch_device(struct irda_usb_cb *self)
 {
-        unsigned int i;
-        int ret;
-        char stir421x_fw_name[11];
-        const struct firmware *fw;
-        unsigned char *fw_version_ptr; /* pointer to version string */
+	unsigned int i;
+	int ret;
+	char stir421x_fw_name[11];
+	const struct firmware *fw;
+	const unsigned char *fw_version_ptr; /* pointer to version string */
 	unsigned long fw_version = 0;
 
         /*
-- 
1.5.4.5

