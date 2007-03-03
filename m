Return-Path: <linux-kernel-owner+w=401wt.eu-S1030304AbXCCOrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030304AbXCCOrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030310AbXCCOrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:47:35 -0500
Received: from colgate.yandex.ru ([213.180.200.34]:38483 "EHLO
	colgate.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030304AbXCCOre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:47:34 -0500
Date: Sat, 3 Mar 2007 17:47:21 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45E98A79.000001.09982@colgate.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: hjk@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question: 20 microseconds delay
X-MsgDayCount: 3
X-BornDate: 1134853200
In-Reply-To: <200703031533.42152.hjk@linutronix.de>
Reply-To: Mockern@yandex.ru
References: <45E98415.000002.30135@webmail9.yandex.ru> <200703031533.42152.hjk@linutronix.de>
X-Source-Ip: 84.185.232.70
Content-Type: text/plain;
  charset="KOI8-R"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is that I need to use wait_event_timeout function 

>Am Samstag 03 Mдrz 2007 15:20 schrieb Mockern:
>> Hi,
>>
>> I have a question.
>>
>> I need to use 20 microsecond delay in my driver.
>> What exact jiffies value I should define to get 20 microseconds?
>
>You can't do it with jiffies as they have 1 millisecond resolution at best. 
>You'd use something like usleep(20) instead.
>
>Hans
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


-- 
Сегодня удачный день, чтобы завести почту на Яндексе http://mail.yandex.ru
