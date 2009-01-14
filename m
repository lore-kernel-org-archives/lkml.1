Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbZANWxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbZANWxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbZANWxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:53:31 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:46408 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbZANWxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:53:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=c+81r6SJWRoc/1jbRKorUVxgXO9dMhPB/8kNhv60pfaqjmlkBwLaa2BKdwsI6V3WEs
         +eCUNsCkV4TRN2JQ7NH5FgLpOhYLVzXbmw4jJ6oGlVoSkN2fRk5lCXcx7U5amvECTRrR
         iWw82Ddh1/n83ZIZ7wH3fhxbrd7SghXjI7A9c=
Date: Thu, 15 Jan 2009 06:53:29 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: sameo@openedhand.com
Subject: mfd: PCF50633: remove duplicated #include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20090115064950.1F10.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include <linux/device.h> in
  drivers/mfd/pcf50633-core.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 24508e2..feb8ddd 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -15,7 +15,6 @@
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/sysfs.h>
-#include <linux/device.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>

