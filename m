Return-Path: <linux-kernel-owner+w=401wt.eu-S1751459AbZFHEVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbZFHEVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 00:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbZFHEVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 00:21:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:32638 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbZFHEVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 00:21:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,322,1241420400"; 
   d="scan'208";a="697331987"
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 8 Jun 2009 12:23:29 +0800
Subject: RE: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
Thread-Topic: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
Thread-Index: Acnmt+T9Z6wocCinQV6umhx3C9/gDQBMh+2w
Message-ID: <38D9F46DFF92C54980D2F2C1E8EE313001A45F4F3C@pdsmsx503.ccr.corp.intel.com>
References: <20090606164455.GB27257@intel.com>
 <20090606160413.08c254cf@lxorguk.ukuu.org.uk>
In-Reply-To: <20090606160413.08c254cf@lxorguk.ukuu.org.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n584Lt54001859



>-----Original Message-----
>From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
>Sent: 2009Äê6ÔÂ6ÈÕ 23:04
>To: Gao, Yunpeng
>Cc: gregkh@suse.de; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
>
>On Sun, 7 Jun 2009 00:44:55 +0800
>Yunpeng Gao <yunpeng.gao@intel.com> wrote:
>
>> Hi Greg,
>>
>>    This is the first Intel Moorestown NAND driver patch for mainline. I
>>    generated it and complie it against Linus' kernel tree, tag v2.6.30-rc8.
>
>Flash drivers should go to David Woodhouse <dwmw2@infradead.org> as he
>maintains the mtd  layer flash support code (which you don't seem to be
>using ?)

Hi Alan,

The Moorestown NAND flash driver is licensed from the Moorestown NAND controller vendor. It's a standalone NAND driver. According to the vendor, this driver has some advanced features specific to the controller hardware and is difficult to port to MTD subsystem. 

As the driver is still under development now and not ready for submitting to either block or MTD subsystem, I think it's better to first submit it to staging for widely review. Then after all features of the driver were enabled, we can discuss and decide which subsystem to submit it to.

Thanks.

Rgds,
Yunpeng
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
