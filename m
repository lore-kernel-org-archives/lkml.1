Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab0BOWXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:23:21 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:40256 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab0BOWXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:23:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=jUlquRqnK8pY5adFt4rbXavbm2XPqX8EYfktL8ZQFVJeuxYZ8es78bbbi/Wnx3CwoU
         Qhq8/1QNmD2dQ8Zv2Ue0JhrN4TLfvtAJ63LthSkbUCE8Lw9LK5WuXbCLibnjCkMvhfCH
         aYW2QdfDkSs3BTCIfDY6ftBWaZCnwvTThB1gw=
Message-ID: <4B79CB0E.1060403@gmail.com>
Date: Mon, 15 Feb 2010 23:30:38 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] dvb-usb/opera1: misplaced parenthesis
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parenthesis was misplaced, tmp is set to 0 or break occurs,
while debugging opera1_usb_i2c_msgxfer() retval was not shown.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
index d4e2309..8305576 100644
--- a/drivers/media/dvb/dvb-usb/opera1.c
+++ b/drivers/media/dvb/dvb-usb/opera1.c
@@ -138,7 +138,7 @@ static int opera1_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 					(msg[i].addr<<1)|(msg[i].flags&I2C_M_RD?0x01:0),
 					msg[i].buf,
 					msg[i].len
-					)!= msg[i].len)) {
+					)) != msg[i].len) {
 			break;
 		}
 		if (dvb_usb_opera1_debug & 0x10)
