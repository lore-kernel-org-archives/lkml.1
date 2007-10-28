Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbXJ1O1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbXJ1O1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 10:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXJ1O1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 10:27:06 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:43409 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbXJ1O1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 10:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Qq0fmhoZ6xbty4Z8e3cMCXQwGuHvtvJkmBU90zNJSVxExM33dOtAedp0deztbd2mu9I6H0MZKdDFSmH5XuOO6Rac53pysb2oy2CCdta657v/8eqL8QvfiI2ey0gEln4scYo9xVr/t5S8PXOAMpVdMZ8kNLm8o8eIx7bZ5w1gMi8=
Message-ID: <8b67d60710280727k651ddea7sebaf3f4b995241eb@mail.gmail.com>
Date: Sun, 28 Oct 2007 14:27:04 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Dreamcast AICA sound - Get rid of annoying compiler warning
Cc: linuxsh-dev@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supresses an annoying compiler warning that the variable
err may be used uninitialised.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>


diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index 88dc840..8861d2f 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -237,6 +237,7 @@ static int aica_dma_transfer(int channels, int buffer_size,
 	struct snd_card_aica *dreamcastcard;
 	struct snd_pcm_runtime *runtime;
 	unsigned long flags;
+	err = 0;
 	dreamcastcard = substream->pcm->private_data;
 	period_offset = dreamcastcard->clicks;
 	period_offset %= (AICA_PERIOD_NUMBER / channels);
