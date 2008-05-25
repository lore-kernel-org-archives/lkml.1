Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbYEYKaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbYEYKaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762644AbYEYKYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43340 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762583AbYEYKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:14 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 19/28] bt8xx: treat firmware data as const
Message-Id: <E1K0DOH-0007E0-0L@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:49 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/media/video/bt8xx/bttv-cards.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index f20a01c..f93f1ad 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -3767,7 +3767,8 @@ static int terratec_active_radio_upgrade(struct bttv *btv)
 #define BTTV_ALT_DCLK		0x100000
 #define BTTV_ALT_NCONFIG	0x800000
 
-static int __devinit pvr_altera_load(struct bttv *btv, u8 *micro, u32 microlen)
+static int __devinit pvr_altera_load(struct bttv *btv, const u8 *micro,
+				     u32 microlen)
 {
 	u32 n;
 	u8 bits;
-- 
1.5.4.5

