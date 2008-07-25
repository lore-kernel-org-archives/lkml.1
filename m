Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYGYPaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYGYPaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYGYPaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:30:23 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:61458 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYGYPaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=NJAQ4ILxy91Z5KKPZWa5SOZ+bLztt12xRf0PDNZHhxw4EZnKfHNTMuh8mkfA/jeAgR
         8S1Ut9JynNna+tmK95XHhRK4tJAB/U6EIhwOs5Uyy4Ypsi9tcYTvjiOIz5IPHpME0zN+
         y3DTr7RjPPbKsjpV7vp/+kH6G4Z0DN6kQ0YYM=
Date: Fri, 25 Jul 2008 23:30:18 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: a.zummo@towertech.it, p_gortmaker@yahoo.com
Subject: drivers/char/rtc.c: Removed duplicated include
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Message-Id: <20080725230642.9143.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated include file <linux/smp_lock.h> in
drivers/char/rtc.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index dbefbb3..985a917 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -78,7 +78,6 @@
 #include <linux/wait.h>
 #include <linux/bcd.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <linux/uaccess.h>

 #include <asm/current.h>


