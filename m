Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbZG1Srb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbZG1Srb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbZG1Sra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:47:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:21654 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbZG1Sr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:subject:to:cc;
        b=GVl6CXUuRUp+JSPYlY3rjpz9fR5bbRXwPLwqNO9+jICyXeKdhu98NWH6+ZK1//Z3wE
         W4HZsB8AWJN7FVplge16HTjtbVdSFYbkJLq4k8r/6MurRyIPoIxlvpqCG2ykdGxZxmFU
         pgMt9NMbDRV1Tsvk1eEzB4OPFP6/zK2SVej4Q=
Message-Id: <200907281845.n6SIjq3m025462@home.pavel.comp>
From: Paul Fertser <fercerpav@gmail.com>
Date: Tue, 28 Jul 2009 01:09:04 +0400
Subject: [PATCH] pcf50633: fix wrong define for 10bit ADC mode
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 include/linux/mfd/pcf50633/adc.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/mfd/pcf50633/adc.h b/include/linux/mfd/pcf50633/adc.h
index 56669b4..b35e628 100644
--- a/include/linux/mfd/pcf50633/adc.h
+++ b/include/linux/mfd/pcf50633/adc.h
@@ -25,7 +25,8 @@
 #define PCF50633_REG_ADCS3		0x57
 
 #define PCF50633_ADCC1_ADCSTART		0x01
-#define PCF50633_ADCC1_RES_10BIT	0x02
+#define PCF50633_ADCC1_RES_8BIT		0x02
+#define PCF50633_ADCC1_RES_10BIT	0x00
 #define PCF50633_ADCC1_AVERAGE_NO	0x00
 #define PCF50633_ADCC1_AVERAGE_4	0x04
 #define PCF50633_ADCC1_AVERAGE_8	0x08
-- 
1.6.0.6

