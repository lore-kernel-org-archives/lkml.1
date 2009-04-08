Return-Path: <linux-kernel-owner+w=401wt.eu-S1764400AbZDHL37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764400AbZDHL37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763125AbZDHLXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:23:04 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39430 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762892AbZDHLW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:58 -0400
X-Sasl-enc: JruTR4mfDMUVLTVev2uRw5WZlAsaXpQrI/afzC6vn+wL 1239189774
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 16/56] idle: Remove void casts
Date: Wed,  8 Apr 2009 12:21:48 +0100
Message-Id: <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/idle/i7300_idle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
index bf74039..112a4d1 100644
--- a/drivers/idle/i7300_idle.c
+++ b/drivers/idle/i7300_idle.c
@@ -227,7 +227,7 @@ static int __init i7300_idle_ioat_init(void)
 	writew(IOAT_CHANCTRL_CHANNEL_IN_USE,
 		ioat_chanbase + IOAT_CHANCTRL_OFFSET);
 
-	ioat_desc = (struct ioat_dma_descriptor *)dma_alloc_coherent(
+	ioat_desc = dma_alloc_coherent(
 			&dummy_dma_dev, 4096,
 			(dma_addr_t *)&ioat_desc_phys, GFP_KERNEL);
 	if (!ioat_desc) {
-- 
1.5.4.3

