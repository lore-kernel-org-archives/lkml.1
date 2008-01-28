Return-Path: <linux-kernel-owner+w=401wt.eu-S1763045AbYA1WOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763045AbYA1WOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760762AbYA1WKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:10:50 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46458 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760741AbYA1WKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:10:49 -0500
Date: Tue, 29 Jan 2008 00:11:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make tuner-core.c:tuner_list static
Message-ID: <20080128221115.GV8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tuner_list can become static - and it's anyway a way too generic name 
for a global variable - see commit b00ef4b8d8c29bfb5f6f92ee60bc04b604f36ef2
for a completely different global variable of the same name I just made 
static...

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
5cfd60a0b711973033b2acbed08e8696e126016f 
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index ba538f6..78a09a2 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1038,7 +1038,7 @@ static int tuner_resume(struct i2c_client *c)
 
 /* ---------------------------------------------------------------------- */
 
-LIST_HEAD(tuner_list);
+static LIST_HEAD(tuner_list);
 
 /* Search for existing radio and/or TV tuners on the given I2C adapter.
    Note that when this function is called from tuner_probe you can be

