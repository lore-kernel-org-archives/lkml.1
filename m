Return-Path: <linux-kernel-owner+w=401wt.eu-S1764552AbXHQK7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764552AbXHQK7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 06:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbXHQK70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 06:59:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53977 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbXHQK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 06:59:25 -0400
Date: Fri, 17 Aug 2007 12:59:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
In-Reply-To: <20070817.010638.24337787.anemo@mba.ocn.ne.jp>
Message-ID: <Pine.LNX.4.64.0708171258360.5492@fbirervta.pbzchgretzou.qr>
References: <20070817.010638.24337787.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 17 2007 01:06, Atsushi Nemoto wrote:
>Add an MODULE_ALIAS() to make this platform driver hotplug-aware.
>
>Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
>---
>diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
>index b2e5481..4bd22dc 100644
>--- a/drivers/rtc/rtc-ds1742.c
>+++ b/drivers/rtc/rtc-ds1742.c
>@@ -273,3 +273,4 @@ MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
> MODULE_DESCRIPTION("Dallas DS1742 RTC driver");
> MODULE_LICENSE("GPL");
> MODULE_VERSION(DRV_VERSION);
>+MODULE_ALIAS("ds1742");

Why exactly is this needed? What script refers to the module as ds1742 instead
of rtc-ds1742? Regular hotplug (e.g. udev/modprobe) also go by PCI ID or
whatever is applicable and load the module which provides support for said ID.


	Jan
-- 
