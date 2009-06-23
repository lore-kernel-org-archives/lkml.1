Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbZFWK5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbZFWK5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbZFWK5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:57:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:15070 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019AbZFWK5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:57:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,275,1243839600"; 
   d="scan'208";a="157495076"
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: Greg KH <gregkh@suse.de>, David Woodhouse <dwmw2@infradead.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 23 Jun 2009 18:59:24 +0800
Subject: RE: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
Thread-Topic: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
Thread-Index: Acnom9fsbC6nmM8RQLmVFIrKq5NfOwLTVFEA
Message-ID: <38D9F46DFF92C54980D2F2C1E8EE313001A47964EB@pdsmsx503.ccr.corp.intel.com>
References: <20090606164455.GB27257@intel.com>
 <20090606160413.08c254cf@lxorguk.ukuu.org.uk>
 <38D9F46DFF92C54980D2F2C1E8EE313001A45F4F3C@pdsmsx503.ccr.corp.intel.com>
 <1244458030.30939.216.camel@macbook.infradead.org>
 <20090609003839.GB22766@suse.de>
In-Reply-To: <20090609003839.GB22766@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5NAwj54013596


>-----Original Message-----
>From: Greg KH [mailto:gregkh@suse.de]
>Sent: 2009Äê6ÔÂ9ÈÕ 8:39
>To: David Woodhouse
>Cc: Gao, Yunpeng; Alan Cox; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
>
>On Mon, Jun 08, 2009 at 11:47:10AM +0100, David Woodhouse wrote:
>> On Mon, 2009-06-08 at 12:23 +0800, Gao, Yunpeng wrote:
>> > The Moorestown NAND flash driver is licensed from the Moorestown NAND
>> > controller vendor. It's a standalone NAND driver. According to the
>> > vendor, this driver has some advanced features specific to the
>> > controller hardware and is difficult to port to MTD subsystem.
>>
>> I don't believe it. If the MTD subsystem doesn't support certain
>> features, the MTD subsystem needs to be updated to cope.
>
>Based on this response, I am guessing that you do not want me to take
>this in the staging tree? :)
>
>If so, please let me know and I'll drop it.
>
>thanks,
>
>greg k-h

Hi Greg, David and Alan,

I have discussed with the architect of Moorestown NAND driver today, and we agreed that the Moorestown NAND driver can not be ported to MTD subsystem.
The reason is: 
The NAND driver has to keep compatibility with Moorestown IA Firmware (which also operates on NAND device and is close source), and if the NAND driver is ported to MTD, the driver has to be changed much and thus will fail to keep the compatibility with Firmware.

As this is a standalone NAND driver, I think I can re-submit it to the block subsystem (maintained by Jens Axboe). Thus the NAND driver need not to change its architecture and can keep the compatibility with Firmware.

Also, it'll be better if the NAND driver can be in Greg's staging tree before the driver becomes 'good enough' and accepted by the block subsystem. Because some customers and partners want to get the latest NAND driver code from the kernel tree before the driver is accepted finally.

Does this suggestion make sense?

Thanks for your time.

Rgds,
Yunpeng Gao




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
