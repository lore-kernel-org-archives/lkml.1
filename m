Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbZAKJWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbZAKJWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 04:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZAKJWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 04:22:35 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:13558 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZAKJWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 04:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=J9vztaLu1Vr4SHWZGC4XB4FgR+9Y8N+ud/ao+ECmBIIu8RYA/TgZKR3BunFZkFYERj
         zKgOE3RHvV7qWZcMAILDumW5cEjOzLPRtedbGm1f/UAEgj0j7O13SVeOjNNJZMrsHwhu
         fcSdtewdV6J8fIlbQpRJoIAyHSbbM6WkRESwA=
Date: Sun, 11 Jan 2009 17:22:36 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Subject: staging: remove duplicated #include's
Cc: linux-kernel@vger.kernel.org
Message-Id: <20090111171449.0AB4.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include's in 
  drivers/staging/altpciechdma/altpciechdma.c
  drivers/staging/comedi/comedidev.h
  drivers/staging/rt2860/rt_linux.h
  drivers/staging/rt2870/rt_linux.h

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/staging/altpciechdma/altpciechdma.c b/drivers/staging/altpciechdma/altpciechdma.c
index 8e2b4ca..03dfade 100644
--- a/drivers/staging/altpciechdma/altpciechdma.c
+++ b/drivers/staging/altpciechdma/altpciechdma.c
@@ -46,7 +46,6 @@
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
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

