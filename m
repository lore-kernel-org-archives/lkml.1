Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbXKERKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbXKERKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756956AbXKERHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:07:07 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59488 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757418AbXKERHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:07:05 -0500
Date: Mon, 5 Nov 2007 18:06:41 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Alan Nisota <alannisota@gmail.com>, Patrick Boettcher <pb@linuxtv.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb-usb/gp8psk.c: #if 0 gp8psk_bcm4500_reload()
Message-ID: <20071105170641.GD12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the unused gp8psk_bcm4500_reload()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/dvb/dvb-usb/gp8psk.c |    2 ++
 drivers/media/dvb/dvb-usb/gp8psk.h |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

898220e0467b920690bad5a69655b0708bca7e39 
diff --git a/drivers/media/dvb/dvb-usb/gp8psk.c b/drivers/media/dvb/dvb-usb/gp8psk.c
index 92147ee..fea12dc 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -171,6 +171,7 @@ static int gp8psk_power_ctrl(struct dvb_usb_device *d, int onoff)
 	return 0;
 }
 
+#if 0
 int gp8psk_bcm4500_reload(struct dvb_usb_device *d)
 {
 	u8 buf;
@@ -187,6 +188,7 @@ int gp8psk_bcm4500_reload(struct dvb_usb_device *d)
 			return EINVAL;
 	return 0;
 }
+#endif  /*  0  */
 
 static int gp8psk_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
diff --git a/drivers/media/dvb/dvb-usb/gp8psk.h b/drivers/media/dvb/dvb-usb/gp8psk.h
index e83a575..e5cd814 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk.h
+++ b/drivers/media/dvb/dvb-usb/gp8psk.h
@@ -92,6 +92,5 @@ extern struct dvb_frontend * gp8psk_fe_attach(struct dvb_usb_device *d);
 extern int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen);
 extern int gp8psk_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 			     u16 index, u8 *b, int blen);
-extern int gp8psk_bcm4500_reload(struct dvb_usb_device *d);
 
 #endif

