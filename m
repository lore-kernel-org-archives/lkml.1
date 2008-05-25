Return-Path: <linux-kernel-owner+w=401wt.eu-S1762993AbYEYKZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762993AbYEYKZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758173AbYEYKXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbYEYKXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:42 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 08/28] pcxhr: treat firmware data as const
Message-Id: <E1K0DO5-0007DI-AK@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:37 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 sound/pci/pcxhr/pcxhr_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/pcxhr/pcxhr_core.c b/sound/pci/pcxhr/pcxhr_core.c
index 78aa81f..957e6af 100644
--- a/sound/pci/pcxhr/pcxhr_core.c
+++ b/sound/pci/pcxhr/pcxhr_core.c
@@ -269,7 +269,7 @@ int pcxhr_load_xilinx_binary(struct pcxhr_mgr *mgr, const struct firmware *xilin
 	unsigned int chipsc;
 	unsigned char data;
 	unsigned char mask;
-	unsigned char *image;
+	const unsigned char *image;
 
 	/* test first xilinx */
 	chipsc = PCXHR_INPL(mgr, PCXHR_PLX_CHIPSC);
@@ -316,7 +316,7 @@ static int pcxhr_download_dsp(struct pcxhr_mgr *mgr, const struct firmware *dsp)
 	int err;
 	unsigned int i;
 	unsigned int len;
-	unsigned char *data;
+	const unsigned char *data;
 	unsigned char dummy;
 	/* check the length of boot image */
 	snd_assert(dsp->size > 0, return -EINVAL);
-- 
1.5.4.5

