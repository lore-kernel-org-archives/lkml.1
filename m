Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbYGTQkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbYGTQkm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 12:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbYGTQke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 12:40:34 -0400
Received: from nebensachen.de ([195.34.83.29]:39276 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471AbYGTQkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 12:40:33 -0400
X-Hashcash: 1:20:080720:mkrufky@linuxtv.org::0mtBpWRhC3Eoi915:0000000000000000000000000000000000000000004XaV
X-Hashcash: 1:20:080720:mchehab@infradead.org::JG0mYndKg5Yxb1zn:00000000000000000000000000000000000000001t7T
X-Hashcash: 1:20:080720:linux-kernel@vger.kernel.org::L8I8WnEBjrjgWnSQ:0000000000000000000000000000000001YVg
From: Elias Oltmanns <eo@nebensachen.de>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Trivial fix for drivers/media/Makefile
Date: Sun, 20 Jul 2008 18:40:21 +0200
Message-ID: <8763r0a4qy.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/media/mdtv/ doesn't exist anymore, yet it is still referenced in
the Makefile.  Due to this glitch, make clean invariably fails.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index ec2102b..09a829d 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -6,4 +6,3 @@ obj-y += common/ video/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/
 obj-$(CONFIG_DVB_CORE)  += dvb/
-obj-$(CONFIG_MDTV_ADAPTERS)  += mdtv/
\ No newline at end of file
