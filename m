Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbXBEQ7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbXBEQ7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXBEQ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:59:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:25383 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662AbXBEQ66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:58:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=iqyKfHcQqQXz+f965kOX38AgtuxpC2s2zcmFj9i1jNTSsH+PJ4OcvWYPne7fSdrI+pOadD1irP2flCDEhFpHkLhv+JyvUUIQsgvN34S6zy8EcZHytcdgnOawFtrvqw/fC8RabSeuxf19uC8moK0yvvHmkAwjwOFZvuoOho6PXrs=
Date: Mon, 5 Feb 2007 18:58:52 +0200
To: jkmaline@cc.hut.fi, linville@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2.6.20] hostap: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070205165852.GJ3896@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205165429.GD3896@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A patch to use ARRAY_SIZE macro in the Host AP wireless driver.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Patch is compile tested.

diff --git a/drivers/net/wireless/hostap/hostap.h b/drivers/net/wireless/hostap/hostap.h
index e89c890..ef37a75 100644
--- a/drivers/net/wireless/hostap/hostap.h
+++ b/drivers/net/wireless/hostap/hostap.h
@@ -2,13 +2,14 @@
 #define HOSTAP_H
 
 #include <linux/ethtool.h>
+#include <linux/kernel.h>
 
 #include "hostap_wlan.h"
 #include "hostap_ap.h"
 
 static const long freq_list[] = { 2412, 2417, 2422, 2427, 2432, 2437, 2442,
 				  2447, 2452, 2457, 2462, 2467, 2472, 2484 };
-#define FREQ_COUNT (sizeof(freq_list) / sizeof(freq_list[0]))
+#define FREQ_COUNT ARRAY_SIZE(freq_list)
 
 /* hostap.c */
 

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
