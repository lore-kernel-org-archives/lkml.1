Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498Ab0ADRnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0ADRnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215Ab0ADRnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:43:17 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36766 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0ADRnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:43:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:x-uid:x-length:organization:to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ZyDqVzVR6sLqIRFIcqU0YaWT3/B63bc9BIFE1iqJq1gVGmkHEA0kHcD42kmIFtwwZO
         yv5QEdPH7r2hqwlhkmDsIuPGGjRwy+BfCAXaQh6oKVhQdvDFjyp1BAZm0b9UrQGVSwGl
         R3B9RM8lHlK1KfrlzfSeL9Fudf/qB1U2nXna0=
From: Florian Fainelli <florian@openwrt.org>
Date: Mon, 4 Jan 2010 18:38:51 +0100
Subject: [PATCH] VLYNQ: add missing linux/irq.h include
X-Length: 796
Organization: OpenWrt
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001041838.51265.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing linux/irq.h header
which will trigger compilation errors on non-AR7
platforms (i.e: TI Davinci).

Reported-by:  Rohan Tabish <rohan_javed@yahoo.co.uk>
Signed-off-by: Regards, Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index 9554ad5..14b1af9 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -30,6 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 
 #include <linux/vlynq.h>
 
-- 
1.6.3.3

