Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbZGAX6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbZGAX6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 19:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZGAX6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 19:58:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:59394 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbZGAX6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 19:58:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,328,1243839600"; 
   d="scan'208";a="426991860"
From: "Du, Alek" <alek.du@intel.com>
To: David Brownell <david-b@pacbell.net>
CC: lkml <linux-kernel@vger.kernel.org>
Date: Thu, 2 Jul 2009 07:56:13 +0800
Subject: RE: [PATCH] gpio: add Intel Moorestown Platform Langwell chip gpio
 driver
Thread-Topic: [PATCH] gpio: add Intel Moorestown Platform Langwell chip gpio
 driver
Thread-Index: Acn6o57Xmj/ils0uR525xX7zlxXEHAAAoPyA
Message-ID: <EADF0A36011179459010BDF5142A457501C9F4603D@pdsmsx502.ccr.corp.intel.com>
References: <EADF0A36011179459010BDF5142A457501C9F46019@pdsmsx502.ccr.corp.intel.com>
 <200907011628.08799.david-b@pacbell.net>
In-Reply-To: <200907011628.08799.david-b@pacbell.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n61NwNoU003697

David,
>-----Original Message-----
>From: David Brownell [mailto:david-b@pacbell.net]
>Sent: 2009Äê7ÔÂ2ÈÕ 7:28
>To: Du, Alek
>Cc: lkml
>Subject: Re: [PATCH] gpio: add Intel Moorestown Platform Langwell chip gpio
>driver
>> Subject: [PATCH] gpio: add Intel Moorestown Platform Langwell chip gpio driver
>>
>> The Langwell chip has a 64-pin gpio block, which is exposed as a PCI device.
>
>Is this a dedicated GPIO-only device?  Or is it like e.g. ICH8
>which shares that device with other functions?

Yes, the GPIO block is just one function of Langwell chip, the Langwell chip is an IOH (IO hub) for the whole system. But the devices on the chip are all exposed as PCI devices.

>
>
>So if LNG is Liquid Natural Gass, then LNW is ... Liquid Natural Water??
>
>Spell it out please.  And use the same name in the driver.name too.

:-), interesting.

>
>You're sure this isn't like a trimmed-down PXA part?
>I think I know some of the history of that register
>model ...  :)

Yeah, I guess it is just like the PXA gpio style, but now the device is PCI style and for i386 arch.

>> +struct lnw_driver_data {
>> +	unsigned	gpio_base;
>> +	unsigned	gpio_nr;
>> +} lnw_driver_datas[] __devinitdata = {
>> +	{ .gpio_base = 0, .gpio_nr = 64 },
>
>Hmm, passing gpio_base here is kind of ugly.
>
>But I guess you're working with platforms that don't
>really have good ways to pass platform-specific data
>through device->platform_data, so you're stuck with
>being ugly...

Yes, for this PCI device, I know it is the only way to pass platform specific data as this.

Thanks for reviewing it. I will submit version 2 according to your comments.

Thanks,
Alek
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
