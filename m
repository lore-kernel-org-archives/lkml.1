Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbZGTC4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbZGTC4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 22:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZGTC4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 22:56:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49978 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbZGTC4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 22:56:30 -0400
Message-ID: <04e101ca08e5$be078fa0$808410ac@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Pavel Machek" <pavel@ucw.cz>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <hirofumi@mail.parknet.co.jp>,
       <linux-kernel@vger.kernel.org>
References: <4A5C3BC0.6020701@cn.fujitsu.com> <20090714151040.b7b3b26d.akpm@linux-foundation.org> <20090718115019.GH1433@ucw.cz>
Subject: Re: [PATCH 1/2] Add function to convert between calendar time andbroken-down time for universal use
Date: Mon, 20 Jul 2009 10:56:55 +0800
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6K2uiJ7009077

* From: "Pavel Machek" <pavel@ucw.cz>
>> > +extern void gmtime(__kernel_time_t totalsecs,
>> > +        unsigned int *year, unsigned int *mon, unsigned int *mday,
>> > +        unsigned int *hour, unsigned int *min, unsigned int *sec,
>> > +        unsigned int *wday, unsigned int *yday);
>> > +extern void localtime(__kernel_time_t totalsecs,
>> > +        unsigned int *year, unsigned int *mon, unsigned int *mday,
>> > +        unsigned int *hour, unsigned int *min, unsigned int *sec,
>> > +        unsigned int *wday, unsigned int *yday);
> 
> 
> Should year/mon/.../yday be passed up as a structure?

Hello, Pavel

Thanks for your attention.

Actually, I considered to introduce a struct as your think, but finally I
choose to use arguments list instead of a struct, because:
1: User can easy to call this function without define a struct
2: Get rid of adding a additional struct into kernel

In fact, I think both(use a struct or not) should be ok.

Thanks
Zhaolei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
