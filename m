Return-Path: <linux-kernel-owner+w=401wt.eu-S1764294AbXHQBkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764294AbXHQBkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 21:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbXHQBkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 21:40:41 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:21983 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756993AbXHQBkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 21:40:40 -0400
X-Greylist: delayed 1425 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 21:40:40 EDT
Date: Fri, 17 Aug 2007 10:16:47 +0900 (JST)
Message-Id: <20070817.101647.93018729.nemoto@toshiba-tops.co.jp>
To: lethal@linux-sh.org
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] rtc: Make rtc-ds1553 driver hotplug-aware
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070816161450.GE13927@linux-sh.org>
References: <20070817.010627.110331225.anemo@mba.ocn.ne.jp>
	<20070816161450.GE13927@linux-sh.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 01:14:50 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> > +MODULE_ALIAS("ds1742");
> 
> Presumably this should be ds1553.

Oh of course!  Thanks.


Subject: [PATCH] rtc: Make rtc-ds1553 driver hotplug-aware

Add an MODULE_ALIAS() to make this platform driver hotplug-aware.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index 46da571..a2eafd2 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -417,3 +417,4 @@ MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
 MODULE_DESCRIPTION("Dallas DS1553 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("ds1553");
