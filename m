Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZDVHIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZDVHIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZDVHHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:07:38 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43923 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbZDVHHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:07:36 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 6/6] Char: cyclades, remove unused variables
Date: Wed, 22 Apr 2009 09:06:43 +0200
Message-Id: <1240384003-25499-6-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240384003-25499-1-git-send-email-jirislaby@gmail.com>
References: <1240384003-25499-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 6adbc97..4560190 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2963,7 +2963,6 @@ static void set_line_char(struct cyclades_port *info)
 	void __iomem *base_addr;
 	int chip, channel, index;
 	unsigned cflag, iflag;
-	unsigned short chip_number;
 	int baud, baud_rate = 0;
 	int i;
 
@@ -2992,7 +2991,6 @@ static void set_line_char(struct cyclades_port *info)
 
 	card = info->card;
 	channel = info->line - card->first_line;
-	chip_number = channel / 4;
 
 	if (!cy_is_Z(card)) {
 
@@ -3212,9 +3210,7 @@ static void set_line_char(struct cyclades_port *info)
 	} else {
 		struct FIRM_ID __iomem *firm_id;
 		struct ZFW_CTRL __iomem *zfw_ctrl;
-		struct BOARD_CTRL __iomem *board_ctrl;
 		struct CH_CTRL __iomem *ch_ctrl;
-		struct BUF_CTRL __iomem *buf_ctrl;
 		__u32 sw_flow;
 		int retval;
 
@@ -3224,9 +3220,7 @@ static void set_line_char(struct cyclades_port *info)
 
 		zfw_ctrl = card->base_addr +
 			(readl(&firm_id->zfwctrl_addr) & 0xfffff);
-		board_ctrl = &zfw_ctrl->board_ctrl;
 		ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
-		buf_ctrl = &zfw_ctrl->buf_ctrl[channel];
 
 		/* baud rate */
 		baud = tty_get_baud_rate(info->port.tty);
-- 
1.6.2.3

