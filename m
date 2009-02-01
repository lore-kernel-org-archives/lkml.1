Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbZBAGGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbZBAGGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 01:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZBAGGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 01:06:01 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:4505 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZBAGGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 01:06:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=eR6JYHhRRUILdsL504yER88750lHgyueSzJgo/Y2Sb6fivlnSHaHr+JwP9w5/CkNRA
         /G1pyW4+izWwWPwr63+SkcIlBw0VXOmHrwBe5iEvIKfefU9C4yndQ0SpuRQnX7tS7/JA
         5vJSdkczskZ/AzMl4WScYnEs/T0sLI17pa5ps=
Date: Sun, 01 Feb 2009 14:05:53 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Subject: staging: remove duplicated #include's
Cc: linux-kernel@vger.kernel.org
Message-Id: <20090201140429.6002.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include's in drivers/staging/altpciechdma/altpciechdma.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/staging/altpciechdma/altpciechdma.c b/drivers/staging/altpciechdma/altpciechdma.c
index f516140..3e04a62 100644
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

