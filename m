Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbZCUFuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbZCUFuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 01:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761483AbZCUFtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 01:49:36 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:58102 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761440AbZCUFtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 01:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=chTDXaiafmO88yCAvbJS8PRQOuzE3ucLBd6aUVRyDlNgJLK85SVZTdO6Lcx4Q3MmXY
         6xMYg8MTNBhi3qn2AGO0YFxIPX4sekcw/DwPAvKCCqVYyuEnrPVJt2D1tiLwZzxRlzwt
         yklmp9sNktpw888c8f4DQ1pn+vXMN+DpJVYgk=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH] staging: remove duplicated #include's
Date: Sat, 21 Mar 2009 13:49:05 +0800
Message-Id: <1237614545-4056-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated #include's.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/staging/comedi/comedidev.h |    1 -
 drivers/staging/rt2860/rt_linux.h  |    1 -
 drivers/staging/rt2870/rt_linux.h  |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 3735355..4679911 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -36,7 +36,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/vmalloc.h>
-#include <linux/mm.h>
 #include "interrupt.h"
 #include <linux/dma-mapping.h>
 #include <linux/uaccess.h>
diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
index 0fd58f5..f168691 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -65,7 +65,6 @@
 #include <linux/vmalloc.h>
 
 
-#include <linux/wireless.h>
 #include <net/iw_handler.h>
 
 // load firmware
diff --git a/drivers/staging/rt2870/rt_linux.h b/drivers/staging/rt2870/rt_linux.h
index 859f9ce..49ad37f 100644
--- a/drivers/staging/rt2870/rt_linux.h
+++ b/drivers/staging/rt2870/rt_linux.h
@@ -65,7 +65,6 @@
 #include <linux/vmalloc.h>
 
 
-#include <linux/wireless.h>
 #include <net/iw_handler.h>
 
 // load firmware
-- 
1.6.0.4

