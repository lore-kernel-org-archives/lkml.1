Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbYLISxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbYLISxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbYLISxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:53:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:61500 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbYLISxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:53:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Lufbm+eiUsTtQ527lgB+2BbIid2esz1BZd1ShTTJi8w/d3Afw1OL2mhV4U7upj+W8t
         QdUQiiGUZdyvWerrKbVsYu6JD5GyKrRdy9fNlsBz+026o9Uc037UKq8V7GZo/xson+76
         05a8PQvpkJJSG54sfH4Lclup/tl+tg+8njV7E=
Message-ID: <493EBE8B.2070008@gmail.com>
Date: Tue, 09 Dec 2008 19:52:59 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: rpurdie@rpsys.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/33] leds: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/leds/leds-pca9532.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 4064d4f..fa060f8 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -151,8 +151,8 @@ static int pca9532_set_blink(struct led_classdev *led_cdev,
 	return pca9532_setpwm(client, 0, psc, led_cdev->brightness);
 }
 
-int pca9532_event(struct input_dev *dev, unsigned int type, unsigned int code,
-	int value)
+static int pca9532_event(struct input_dev *dev, unsigned int type,
+		unsigned int code, int value)
 {
 	struct pca9532_data *data = input_get_drvdata(dev);
 

