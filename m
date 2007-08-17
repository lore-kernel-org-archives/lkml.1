Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbXHQPhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbXHQPhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbXHQPhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:37:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37710 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbXHQPhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:37:03 -0400
Date: Fri, 17 Aug 2007 17:37:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Brownell <david-b@pacbell.net>
cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
In-Reply-To: <200708170823.15894.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0708171736170.30502@fbirervta.pbzchgretzou.qr>
References: <20070817.010638.24337787.anemo@mba.ocn.ne.jp>
 <Pine.LNX.4.64.0708171258360.5492@fbirervta.pbzchgretzou.qr>
 <200708170823.15894.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 17 2007 08:23, David Brownell wrote:
>On Friday 17 August 2007, Jan Engelhardt wrote:
>> On Aug 17 2007 01:06, Atsushi Nemoto wrote:
>> >Add an MODULE_ALIAS() to make this platform driver hotplug-aware.
>> >
>> >...
>> >+MODULE_ALIAS("ds1742");
>> 
>> Why exactly is this needed? What script refers to the module as ds1742 instead
>> of rtc-ds1742? Regular hotplug (e.g. udev/modprobe) also go by PCI ID or
>> whatever is applicable and load the module which provides support for said ID.
>
>Most busses don't have managed device IDs like PCI, USB, or PNP.
>
>The platform, spi, and i2c busses use the driver name, which is
>obviously managed within the scope of all Linux drivers.
>
Yeah but that does not tell me why it needs the ds1742 alias
if scripts (whatever they use to discover it) could modprobe rtc-ds1742
instead.


	Jan
-- 
