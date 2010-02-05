Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0BEIMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 03:12:19 -0500
Received: from poutre.nerim.net ([62.4.16.124]:63128 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab0BEIMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 03:12:18 -0500
Date: Fri, 5 Feb 2010 09:12:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Steven King <sfking@fdwdc.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: driver for TI tmp102 temperature sensor
Message-ID: <20100205091214.2254f3e6@hyperion.delvare>
In-Reply-To: <201002041357.06748.sfking@fdwdc.com>
References: <201002031723.49976.sfking@fdwdc.com>
	<20100204193712.22e8b6e7@hyperion.delvare>
	<201002041357.06748.sfking@fdwdc.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 13:57:06 -0800, Steven King wrote:
> On Thursday 04 February 2010 10:37:12 Jean Delvare wrote:
> > Could you please send a dump of your TMP102 chip, using i2cdump in word
> > mode?
> 
> sure, like so?
> 
> # ./i2cdump 0 0x4a w
> WARNING! This program can confuse your I2C bus, cause data loss and worse!
> I will probe file /dev/i2c-0, address 0x4a, mode word
> Continue? [Y/n] y
>      0,8  1,9  2,a  3,b  4,c  5,d  6,e  7,f
> 00: d90c b062 002d 004b c01a d006 0000 0000
> 08: d90c b062 002d 004b c01a d006 0000 0000
> 10: d90c b062 002d 004b c01a d006 0000 0000
> 18: d90c b062 002d 004b c01a d006 0000 0000
> 20: d90c b062 002d 004b c01a d006 0000 0000
> 28: d90c b062 002d 004b c01a d006 0000 0000
> 30: d90c b062 002d 004b c01a d006 0000 0000
> 38: d90c b062 002d 004b c01a d006 0000 0000
> 40: d90c b062 002d 004b c01a d006 0000 0000
> 48: d90c b062 002d 004b c01a d006 0000 0000
> 50: d90c b062 002d 004b c01a d006 0000 0000
> 58: d90c b062 002d 004b c01a d006 0000 0000
> 60: d90c b062 002d 004b c01a d006 0000 0000
> 68: d90c b062 002d 004b c01a d006 0000 0000
> 70: d90c b062 002d 004b c01a d006 0000 0000
> 78: d90c b062 002d 004b c01a d006 0000 0000
> 80: d90c b062 002d 004b c01a d006 0000 0000
> 88: d90c b062 002d 004b c01a d006 0000 0000
> 90: d90c b062 002d 004b c01a d006 0000 0000
> 98: d90c b062 002d 004b c01a d006 0000 0000
> a0: d90c b062 002d 004b c01a d006 0000 0000
> a8: d90c b062 002d 004b c01a d006 0000 0000
> b0: d90c b062 002d 004b c01a d006 0000 0000
> b8: d90c b062 002d 004b c01a d006 0000 0000
> c0: d90c b062 002d 004b c01a d006 0000 0000
> c8: d90c b062 002d 004b c01a d006 0000 0000
> d0: d90c b062 002d 004b c01a d006 0000 0000
> d8: d90c b062 002d 004b c01a d006 0000 0000
> e0: d10c b062 002d 004b c01a d006 0000 0000
> e8: d10c b062 002d 004b c01a d006 0000 0000
> f0: d10c b062 002d 004b c01a d006 0000 0000
> f8: d10c b062 002d 004b c01a d006 0000 0000
> # 

Exactly, thank you!

-- 
Jean Delvare
