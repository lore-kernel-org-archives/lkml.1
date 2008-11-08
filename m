Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYKHIjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYKHIjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 03:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYKHIjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 03:39:43 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:58428 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYKHIjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 03:39:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=N82DA+mifn8N4IsKiY5sPGA6JaUQqn/RYaqt2QjorargZgW+Y1hUkKGCXf//bWdK6l
         ympYc3mQ96maB7nAdGEyagOI6vCVAIJLTAt78RvDcvFdRT0G0LL54WvTndAeicQNmLyO
         FvRlsJmiBEEx1o21OrGFH7U7PLL+34F9rYU/E=
Date: Sat, 8 Nov 2008 16:39:29 +0800
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] /drivers/staging/usbip/stub_tx.c: cleanup kerneldoc
Message-ID: <20081108163929.68db4e06@ubuntu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No argument named @regs in stub_complete(), remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
index d5563cd..78058f5 100644
--- a/drivers/staging/usbip/stub_tx.c
+++ b/drivers/staging/usbip/stub_tx.c
@@ -54,7 +54,6 @@ void stub_enqueue_ret_unlink(struct stub_device *sdev, __u32 seqnum,
 /**
  * stub_complete - completion handler of a usbip urb
  * @urb: pointer to the urb completed
- * @regs:
  *
  * When a urb has completed, the USB core driver calls this function mostly in
  * the interrupt context. To return the result of a urb, the completed urb is
