Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbYJMK66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbYJMK66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbYJMK6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:58:49 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:54883 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbYJMK6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=content-disposition:subject:from:date:mime-version:to:cc
         :content-type:content-transfer-encoding:message-id;
        b=ccshBU8N/ljwMlpTUcRUED19y8IMz4jdR+pZyTKxzSnp5MzofZlc8dFOLAyJOlTR8m
         ICR8ND5lfY7CUtmI72RUFGYS/VCLt/zelgMyEhZtsZSzCzrzjj8D0BqCP1GB+waMBtK9
         Kfd7mkS+zfqeKEDNyQdPq5ANPPtI88Odi0Vu8=
Content-Disposition: inline
Subject: [PATCH] led-calss.c: trivial fix on comment
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
Date: Mon, 13 Oct 2008 18:58:43 +0800
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200810131858.43141.qhfeng.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function led_classdev_unregister() has not a prefix "__",
juset to remove it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 559a408..3c5215c 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -147,7 +147,7 @@ err_out:
 EXPORT_SYMBOL_GPL(led_classdev_register);
 
 /**
- * __led_classdev_unregister - unregisters a object of led_properties class.
+ * led_classdev_unregister - unregisters a object of led_properties class.
  * @led_cdev: the led device to unregister
  *
  * Unregisters a previously registered via led_classdev_register object.
