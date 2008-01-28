Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbYA1WPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbYA1WPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbYA1WKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:10:54 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47992 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760862AbYA1WKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:10:52 -0500
Date: Tue, 29 Jan 2008 00:11:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Chris Pascoe <c.pascoe@itee.uq.edu.au>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] tuner-xc2028.c: make a function static
Message-ID: <20080128221119.GW8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump_firm_type_and_int_freq() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ca482dc248480ecc87fb342df548f086c3e67663 
diff --git a/drivers/media/video/tuner-xc2028.c b/drivers/media/video/tuner-xc2028.c
index f191f6a..33a51fa 100644
--- a/drivers/media/video/tuner-xc2028.c
+++ b/drivers/media/video/tuner-xc2028.c
@@ -145,7 +145,7 @@ static unsigned int xc2028_get_reg(struct xc2028_data *priv, u16 reg, u16 *val)
 }
 
 #define dump_firm_type(t) 	dump_firm_type_and_int_freq(t, 0)
-void dump_firm_type_and_int_freq(unsigned int type, u16 int_freq)
+static void dump_firm_type_and_int_freq(unsigned int type, u16 int_freq)
 {
 	 if (type & BASE)
 		printk("BASE ");

