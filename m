Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbZEBUq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbZEBUq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbZEBUqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:46:49 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:52065 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbZEBUqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:46:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=o06RVzRer5t/xGlX6c+rvceTQ4Rov/CDdMMRfPFsljcTO4DPBkEdqUf94cgSZWeL4C
         K/imF0dQ5Ifb337INZK1tdtWOX7SfuPmz/MiKRq4I4VZD4UpkPzPVRX3EHaXIB8qa0YI
         PlsJ2Q4j2ZdM+bNk4ZL3svQqEd6UYMjvKF46Q=
Message-ID: <49FCB137.8000003@gmail.com>
Date: Sat, 02 May 2009 22:46:47 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] staging: &&/|| typo?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix &&/|| typo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
vi drivers/staging/go7007/wis-sony-tuner.c +218
#define MPX_NUM_MODES   ARRAY_SIZE(mpx_audio_modes)

diff --git a/drivers/staging/go7007/wis-sony-tuner.c b/drivers/staging/go7007/wis-sony-tuner.c
index c965c60..086896c 100644
--- a/drivers/staging/go7007/wis-sony-tuner.c
+++ b/drivers/staging/go7007/wis-sony-tuner.c
@@ -370,7 +370,7 @@ static int set_if(struct i2c_client *client)
 	i2c_transfer(client->adapter, &msg, 1);
 
 	/* Select MPX mode if not forced by the user */
-	if (force_mpx_mode >= 0 || force_mpx_mode < MPX_NUM_MODES)
+	if (force_mpx_mode >= 0 && force_mpx_mode < MPX_NUM_MODES)
 		t->mpxmode = force_mpx_mode;
 	else
 		t->mpxmode = default_mpx_mode;
