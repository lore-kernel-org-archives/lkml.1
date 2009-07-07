Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbZGGVgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbZGGVgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbZGGVgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:36:23 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:38191 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891AbZGGVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to:cc
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=ueYoA4uiESfdrWx1vJOPLeBJR3vV+9KPntWi93VWLp92tJZ2A84hvuafwHq1fFkjXS
         PJum4Q7mkKTT+82ntWyvOg1QaGi0NPo3WxO1H+1tyrKfQl93Rvf83psh/h5qDdmp41sn
         Bbqa3Zi/Vka8n5jCKftAiq5GCcFdDihDTZxj4=
From: Florian Fainelli <florian@openwrt.org>
Date: Tue, 7 Jul 2009 23:36:14 +0200
Subject: [PATCH] vlynq: remove duplicated #include
MIME-Version: 1.0
X-Length: 1251
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907072336.14767.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated #include('s) in drivers/vlynq/vlynq.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index f05d2a3..ba3d71f 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -28,7 +28,6 @@
 #include <linux/errno.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-#include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 
