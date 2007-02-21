Return-Path: <linux-kernel-owner+w=401wt.eu-S1423077AbXBUUV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423077AbXBUUV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423080AbXBUUV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:21:27 -0500
Received: from webmail15.mail.yandex.net ([213.180.200.30]:52899 "EHLO
	webmail15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423077AbXBUUV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:21:26 -0500
Date: Wed, 21 Feb 2007 23:21:10 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45DCA9B6.000001.09623@webmail15.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: lsorense@csclub.uwaterloo.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: cat problem in tiny_tty driver (the source included)
X-MsgDayCount: 4
X-BornDate: 1134853200
In-Reply-To: <20070221200904.GG22464@csclub.uwaterloo.ca>
Reply-To: Mockern@yandex.ru
References: <45DC5F34.000008.04893@tide.yandex.ru> <20070221151554.GA22466@csclub.uwaterloo.ca> <45DC9EA0.000007.11000@webmail18.yandex.ru> <20070221200904.GG22464@csclub.uwaterloo.ca>
X-Source-Ip: 84.185.219.101
Content-Type: text/plain;
  charset="KOI8-R"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cat < /dev/my_tty does nothing, just stopped for reading. I tried to send a data,
but there was no respond, just waiting.


>On Wed, Feb 21, 2007 at 10:33:52PM +0300, Mockern wrote:
>> Thank you very much for you help.
>> 
>> BTW, for cat < /dev/my_tty1 can see here something wrong?
>> as I understand tiny_timer function sends data to tty level
>> by calling tty_flip_buffer_push(tty).
>> 
>> Is this enough to support cat < /dev/my_tty1?
>
>I don't really know the tty layer very much.  I just saw a very obvious
>bug in the code.
>
>Does cat from the device give an error or does it just not do anything?
>
>What does strace say for that?
>
>--
>Len Sorensen
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


-- 
Сегодня удачный день, чтобы завести почту на Яндексе http://mail.yandex.ru
