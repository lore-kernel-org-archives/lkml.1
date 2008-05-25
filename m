Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbYEYKdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbYEYKdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbYEYKY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43333 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762565AbYEYKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:14 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 11/28] cxacru: treat firmware data as const
Message-Id: <E1K0DO8-0007DU-GH@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:40 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/usb/atm/cxacru.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 5ea3093..90583d6 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -820,7 +820,7 @@ reschedule:
 }
 
 static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request fw,
-		     u8 code1, u8 code2, u32 addr, u8 *data, int size)
+		     u8 code1, u8 code2, u32 addr, const u8 *data, int size)
 {
 	int ret;
 	u8 *buf;
-- 
1.5.4.5

