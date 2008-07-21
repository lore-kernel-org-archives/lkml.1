Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYGUTea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYGUTea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYGUTdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:33:49 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42243 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbYGUTds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:33:48 -0400
Date: Mon, 21 Jul 2008 22:33:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Antti Palosaari <crope@iki.fi>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb-usb/anysee.c: make struct anysee_usb_mutex static
Message-ID: <20080721193342.GD14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct anysee_usb_mutex static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
c22d5e2ad79a2b855e4145cf8a7a035ac567efc9 
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index adfd4fc..2f408d2 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -43,7 +43,7 @@ module_param_named(debug, dvb_usb_anysee_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level" DVB_USB_DEBUG_STATUS);
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-struct mutex anysee_usb_mutex;
+static struct mutex anysee_usb_mutex;
 
 static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 	u8 *rbuf, u8 rlen)

