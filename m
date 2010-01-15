Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab0AONT1 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815Ab0AONT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:19:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:25900 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab0AONTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:19:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="233119926"
From: "Mahalingam, Nithish" <nithish.mahalingam@intel.com>
To: "avorontsov@ru.mvista.com" <avorontsov@ru.mvista.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>, "cbou@mail.ru" <cbou@mail.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 15 Jan 2010 18:49:15 +0530
Subject: RE: [RFC] [PATCH] Adding Intel Moorestown PMIC Battery Driver
Thread-Topic: [RFC] [PATCH] Adding Intel Moorestown PMIC Battery Driver
Thread-Index: AcqV5GfLM2id1JTnR8eraaDuxr4cGgAAKQxA
Message-ID: <175E0F9A9EFCEA46A65F5552BB0572980445DB321C@bgsmsx502.gar.corp.intel.com>
References: <175E0F9A9EFCEA46A65F5552BB0572980445D2BE30@bgsmsx502.gar.corp.intel.com>
 <20100111213242.GA3985@oksana.dev.rtsoft.ru>
 <175E0F9A9EFCEA46A65F5552BB0572980445DB31FB@bgsmsx502.gar.corp.intel.com>
 <20100115131229.GA30213@oksana.dev.rtsoft.ru>
In-Reply-To: <20100115131229.GA30213@oksana.dev.rtsoft.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id o0FDJZ50024527

>>>> +       unsigned int batt_charge_now;           /* in mAS */
>>>> +       unsigned int batt_prev_charge_full;     /* in mAS */
>>> +       unsigned int batt_charge_rate;          /* in units per second */
>>> 
>>> Per include/linux/power_supply.h and
>>> Documentation/power/power_supply_class.txt
>>> 
>>> * All voltages, currents, charges, energies, time and temperatures in uV,
>>> * uA, uAh, uWh, seconds and tenths of degree Celsius unless otherwise
>>> * stated. It's driver's job to convert its raw values to units in which
>>> * this class operates.
>> 
>> I just now checked the hardware spec and it is indeed mAh. I will correct 
>> the comment appropriately.
> 
> Note, if the hardware reports the values in mAh (milli), the driver
> still have to convert them to uAh (micro) before reporting the values
> to userspace.

Yup will take care, sorry for not making it clear here.


Regards,
Nithish
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
