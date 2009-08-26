Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZHZKWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZHZKWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbZHZKWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:22:19 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:38580 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776AbZHZKWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to:cc
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=k9H2mt2E9nzRW9EB56rVM8wNuLoQD4OMKZ/G9FIXHs55wyI4404rBvchHqh0/BCqvm
         gBfXhYYhS9Pqm9eDFluua380J5aQ5SbZEEzyeV/87ZNBCWmLdGfi49nYDtgFVqZ5nTQ0
         7UVkee5BtqEFftnZ8hU/UFDdSpSCWWsawoXiw=
From: Florian Fainelli <florian@openwrt.org>
Date: Wed, 26 Aug 2009 12:22:11 +0200
Subject: [PATCH] VLYNQ: includecheck fix: drivers/vlynq/vlynq.c
MIME-Version: 1.0
X-Length: 1366
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908261222.14343.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: VLYNQ: includecheck fix: drivers/vlynq/vlynq.c

fix the following 'make includecheck' warning:

drivers/vlynq/vlynq.c: linux/device.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
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
 
