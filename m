Return-Path: <linux-kernel-owner+w=401wt.eu-S1751136AbZGTClN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136AbZGTClN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 22:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbZGTClM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 22:41:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57438 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbZGTClL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 22:41:11 -0400
Message-ID: <04d801ca08e3$9f9bd9b0$808410ac@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       <linux-kernel@vger.kernel.org>
References: <4A5C3BC0.6020701@cn.fujitsu.com> <87skguuqh3.fsf@basil.nowhere.org>
Subject: Re: [PATCH 1/2] Add function to convert between calendar time and broken-down time for universal use
Date: Mon, 20 Jul 2009 10:41:45 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2180
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6K2fjJ7009002

* From: "Andi Kleen" <andi@firstfloor.org>
>> +
>> +static void __offtime(__kernel_time_t totalsecs, int offset,
>> +         unsigned int *year, unsigned int *mon, unsigned int *mday,
>> +         unsigned int *hour, unsigned int *min, unsigned int *sec,
>> +         unsigned int *wday, unsigned int *yday)
>> +{
>> +    long days, rem, y;
>> +    const unsigned short *ip;
>> +
>> +    days = totalsecs / SECS_PER_DAY;
> 
> Does this handle leap seconds? Doesn't seem to.

Hello, Andi

Thank for your attention.

It seems that we don't need to deal with leap seconds in conversion because
unix time is not counting leap seconds..

There is some detail in http://en.wikipedia.org/wiki/Unix_time

Thanks
Zhaolei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
