Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbYEYKXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbYEYKXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbYEYKXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbYEYKXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:38 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 06/28] vx222: treat firmware data as const
Message-Id: <E1K0DO3-0007DA-7S@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:35 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 sound/pci/vx222/vx222_ops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/vx222/vx222_ops.c b/sound/pci/vx222/vx222_ops.c
index b4bfc1a..631f3a6 100644
--- a/sound/pci/vx222/vx222_ops.c
+++ b/sound/pci/vx222/vx222_ops.c
@@ -359,7 +359,7 @@ static int vx2_load_xilinx_binary(struct vx_core *chip, const struct firmware *x
 {
 	unsigned int i;
 	unsigned int port;
-	unsigned char *image;
+	const unsigned char *image;
 
 	/* XILINX reset (wait at least 1 milisecond between reset on and off). */
 	vx_outl(chip, CNTRL, VX_CNTRL_REGISTER_VALUE | VX_XILINX_RESET_MASK);
-- 
1.5.4.5

