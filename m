Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbXCZKNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbXCZKNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbXCZKNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:13:13 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:13204 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbXCZKNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:13:11 -0400
X-IronPort-AV: i="4.14,329,1170651600"; 
   d="scan'208"; a="25489889:sNHT20502048"
Subject: [PATCH -mm] Blackfin: rtc fix rtc_update_irq augument
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, a.zummo@towertech.it,
       vapier@gentoo.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 26 Mar 2007 18:13:42 +0800
Message-Id: <1174904023.32691.75.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Replacing class_dev to directly using rtc_dev.

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
---

 drivers/rtc/rtc-bfin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/rtc/rtc-bfin.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-bfin.c
+++ linux-2.6/drivers/rtc/rtc-bfin.c
@@ -166,7 +166,7 @@
 		events |= RTC_UF | RTC_IRQF;
 	}
 
-	rtc_update_irq(&rtc->rtc_dev->class_dev, 1, events);
+	rtc_update_irq(rtc->rtc_dev, 1, events);
 
 	spin_unlock_irq(&rtc->lock);
 
_

Thanks,
-Bryan Wu
