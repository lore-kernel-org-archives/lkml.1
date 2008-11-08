Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYKHIgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYKHIgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 03:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYKHIgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 03:36:10 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:58092 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYKHIgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 03:36:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=xgo1q4nr0bfw+bzqHrhqnXwi+Wlcf/WvJ3VlpnYoMZ5DwaLS4//rQ/gD0pFtlwIRxz
         xxILM3t+ea9zkwp8keTCs3xHnJJ4KK6QJ/G2cm5FlAKLLpBSLlvzp8gt6w7XqYLodJXe
         /jKlAicyPF1w1G8+dkNyoAf6f6+5vZ24XxM4Y=
Date: Sat, 8 Nov 2008 16:35:56 +0800
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] /drivers/message/i2o/iop.c: cleanup kerneldoc
Message-ID: <20081108163556.048086ea@ubuntu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no argument named @msg in i2o_msg_get_wait(), remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index be2b592..6e53a30 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -49,7 +49,6 @@ static int i2o_hrt_get(struct i2o_controller *c);
 /**
  *	i2o_msg_get_wait - obtain an I2O message from the IOP
  *	@c: I2O controller
- *	@msg: pointer to a I2O message pointer
  *	@wait: how long to wait until timeout
  *
  *	This function waits up to wait seconds for a message slot to be
