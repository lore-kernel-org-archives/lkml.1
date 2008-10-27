Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYJ0JcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYJ0JcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYJ0JcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:32:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:35341 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbYJ0JcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TxqLRUbaa3ocalrKu/T9KjQq0xEryUVpUA0nlUMyCB2pIjV1L7IXNYVr9vf56etCcs
         DTHKWRxbEsfl2WTbMk4MDgBP9W4f96SaMO5bydHSScJzM0ZuZe1/p8WVExpKtbSSjO2h
         FEoaeu+AZNJTmWdVbTfXbP9sBii6ZbIW5eX1s=
Message-ID: <6e4284620810270231y7d03d898p8d2d832bec42b10e@mail.gmail.com>
Date: Mon, 27 Oct 2008 10:31:59 +0100
From: "Vlada Peric" <vlada.peric@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] cirrusfb: remove unused variables
Cc: krzysztof.h1@wp.pl
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9R9WMdq026846

After commit a1d35a7a (cirrusfb: use modedb and add mode_option parameter),these variables are no longer used, so remove them to fix compilation warning.
Signed-off-by: Vlada Periæ <vlada.peric@gmail.com>CC: Krzysztof Helt <krzysztof.h1@wp.pl>--- drivers/video/cirrusfb.c |    3 +-- 1 files changed, 1 insertions(+), 2 deletions(-)
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.cindex 048b139..ace4001 100644--- a/drivers/video/cirrusfb.c+++ b/drivers/video/cirrusfb.c@@ -2462,8 +2462,7 @@ static int __init cirrusfb_init(void)
 #ifndef MODULE static int __init cirrusfb_setup(char *options) {-	char *this_opt, s[32];-	int i;+	char *this_opt;
 	DPRINTK("ENTER\n");
-- 1.6.0.3ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
