Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab0BLJ5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:57:18 -0500
Received: from smtp.nokia.com ([192.100.122.233]:27387 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0BLJ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:57:15 -0500
From: <samu.p.onkalo@nokia.com>
To: <eric.piel@tremplin-utc.net>
CC: <linux-kernel@vger.kernel.org>, <daniel@caiaq.de>, <pavel@ucw.cz>,
       <lm-sensors@lm-sensors.org>
Date: Fri, 12 Feb 2010 10:56:14 +0100
Subject: RE: [lm-sensors] [PATCH 0/6] lis3lv02d: Power management, click and
 threshold interrupts
Thread-Topic: [lm-sensors] [PATCH 0/6] lis3lv02d: Power management, click
 and threshold interrupts
Thread-Index: AcqrTuM0ukF7T2ozT7uBVntUlwsFtgAW9WsAAAepOQA=
Message-ID: <62697B07E9803846BC582181BD6FB6B82661C50472@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1265271848-26559-1-git-send-email-samu.p.onkalo@nokia.com>
	<4B7457D0.4080507@tremplin-utc.net>
 <62697B07E9803846BC582181BD6FB6B82661C5029E@NOK-EUMSG-02.mgdnok.nokia.com>
In-Reply-To: <62697B07E9803846BC582181BD6FB6B82661C5029E@NOK-EUMSG-02.mgdnok.nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 12 Feb 2010 09:56:23.0517 (UTC) FILETIME=[A26AE0D0:01CAABC9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o1C9vvmE004639


>>Hello,
>>Sorry, I haven't had time to fully review the patches. Nevertheless,
>>I've tested them on my HP laptop with a 12bit device, and can confirm
>>it's all fine.
>>
>>The only hiccup is in patch 6: it declares the joystick with 3 buttons,
>>although on this hardware it's impossible to have this feature. So, it
>>would be nice if input_set_capability() could be conditionned.
>
>I'll add configuration option to platform data or do you prefer some
>other
>way to enable this?
>

You obviously meant that enable those only for 8 bit device, since
12 bit doesn't have click detection. I can do that.

-Samu



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
