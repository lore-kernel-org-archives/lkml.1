Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbYEYK1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbYEYK1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762292AbYEYKX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42022 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761822AbYEYKX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:56 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 24/28] tuners: treat firmware data as const
Message-Id: <E1K0DOM-0007EK-A7@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:54 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/media/common/tuners/tuner-xc2028.c |    2 +-
 drivers/media/common/tuners/xc5000.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 9e9003c..0a6e26a 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -255,7 +255,7 @@ static int load_all_firmwares(struct dvb_frontend *fe)
 {
 	struct xc2028_data    *priv = fe->tuner_priv;
 	const struct firmware *fw   = NULL;
-	unsigned char         *p, *endp;
+	const unsigned char   *p, *endp;
 	int                   rc = 0;
 	int		      n, n_array;
 	char		      name[33];
diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index ceae6db..d21a5a7 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -277,7 +277,7 @@ static int xc_read_reg(struct xc5000_priv *priv, u16 regAddr, u16 *i2cData)
 	return result;
 }
 
-static int xc_load_i2c_sequence(struct dvb_frontend *fe, u8 i2c_sequence[])
+static int xc_load_i2c_sequence(struct dvb_frontend *fe, const u8 *i2c_sequence)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 
-- 
1.5.4.5

